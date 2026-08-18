import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  Prisma,
  ReportSeverity,
  ReportType,
  RequestStatus,
  SafetyIncidentSource,
  SessionStatus,
} from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { toPublicReport } from '../common/public-serializers';
import { CreateReportDto } from './dto/create-report.dto';

const VICTIM_REPORT_TYPES: ReportType[] = [ReportType.SCAM, ReportType.THEFT];
const HIGH_SEVERITY_TYPES: ReportType[] = [
  ReportType.SCAM,
  ReportType.THEFT,
  ReportType.UNSAFE_SITUATION,
];

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(reporterId: string, dto: CreateReportDto) {
    const description = dto.description?.trim() ?? '';
    if (description.length < 10) {
      throw new BadRequestException(
        'Please describe what happened in a bit more detail.',
      );
    }
    if (!dto.sessionId && !dto.requestId && !dto.targetUserId) {
      throw new BadRequestException(
        'A report must include a session, request, or person.',
      );
    }

    const session = dto.sessionId
      ? await this.prisma.session.findUnique({
          where: { id: dto.sessionId },
          include: { request: true, helper: true },
        })
      : null;
    if (dto.sessionId && !session) {
      throw new NotFoundException('Session not found');
    }
    if (
      session &&
      session.helperId !== reporterId &&
      session.request.userId !== reporterId
    ) {
      throw new ForbiddenException(
        'You can only report a chat you are part of',
      );
    }

    const requestId = dto.requestId ?? session?.requestId;
    const request = requestId
      ? await this.prisma.request.findUnique({ where: { id: requestId } })
      : null;
    if (requestId && !request) {
      throw new NotFoundException('Request not found');
    }

    const targetUserId = this.resolveTargetUserId(
      reporterId,
      dto,
      session,
      request,
    );
    if (targetUserId === reporterId) {
      throw new ForbiddenException('You cannot report yourself');
    }

    const endSession =
      dto.endSession !== false && session?.status === SessionStatus.ACTIVE;
    const severity = HIGH_SEVERITY_TYPES.includes(dto.type)
      ? ReportSeverity.HIGH
      : ReportSeverity.MEDIUM;

    try {
      const report = await this.prisma.$transaction(async (tx) => {
        const created = await tx.report.create({
          data: {
            reporterId,
            targetUserId,
            sessionId: session?.id,
            requestId: request?.id,
            type: dto.type,
            severity,
            description,
            evidenceUrls: dto.evidenceUrls ?? [],
            sessionEnded: endSession,
          },
        });

        if (targetUserId) {
          await tx.safetyIncident.create({
            data: {
              userId: targetUserId,
              source: SafetyIncidentSource.REPORT_PATTERN,
              reasonCode: dto.type,
              detailsRedacted: this.redactIncidentDetails(dto.type),
              reportId: created.id,
              requestId: request?.id,
            },
          });
        }

        if (endSession && session) {
          await tx.session.update({
            where: { id: session.id },
            data: { status: SessionStatus.DISPUTED },
          });
          await tx.request.update({
            where: { id: session.requestId },
            data: {
              status: this.requestStatusAfterReport(dto.type),
            },
          });
        }

        return created;
      });

      return toPublicReport(report);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('You have already reported this.');
      }
      throw error;
    }
  }

  async findMine(reporterId: string) {
    const reports = await this.prisma.report.findMany({
      where: { reporterId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
    return reports.map((report) => toPublicReport(report));
  }

  private resolveTargetUserId(
    reporterId: string,
    dto: CreateReportDto,
    session: { helperId: string; request: { userId: string } } | null,
    request: { userId: string } | null,
  ): string | undefined {
    if (dto.targetUserId) return dto.targetUserId;
    if (session) {
      return session.helperId === reporterId
        ? session.request.userId
        : session.helperId;
    }
    if (request && request.userId !== reporterId) {
      return request.userId;
    }
    return undefined;
  }

  private requestStatusAfterReport(type: ReportType): RequestStatus {
    if (type === ReportType.HELPER_MISCONDUCT) {
      return RequestStatus.APPROVED;
    }
    return RequestStatus.CANCELLED;
  }

  private redactIncidentDetails(type: ReportType): string {
    if (VICTIM_REPORT_TYPES.includes(type)) {
      return 'Victim harm report against another user. Reporter is not penalized.';
    }
    return 'User report filed against this account.';
  }
}
