import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  AppealStatus,
  ReportType,
  RequestStatus,
  SafetyIncidentSource,
  SessionStatus,
} from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { toPublicRequest } from '../common/public-serializers';

const PUBLIC_MIN_COUNT = 5;

function publicCount(value: number) {
  return value < PUBLIC_MIN_COUNT ? 0 : value;
}

@Injectable()
export class PulseService {
  constructor(private readonly prisma: PrismaService) {}

  async summary() {
    const [
      sessionsCompleted,
      requestsApproved,
      requestsRejected,
      reportsFiled,
      crisisRouted,
      harmReports,
    ] = await Promise.all([
      this.prisma.session.count({
        where: { status: SessionStatus.COMPLETED },
      }),
      this.prisma.request.count({
        where: {
          status: {
            in: [
              RequestStatus.APPROVED,
              RequestStatus.IN_PROGRESS,
              RequestStatus.COMPLETED,
            ],
          },
        },
      }),
      this.prisma.request.count({
        where: { status: RequestStatus.REJECTED },
      }),
      this.prisma.report.count(),
      this.prisma.safetyIncident.count({
        where: { reasonCode: 'CRISIS_SELF_HARM' },
      }),
      this.prisma.report.count({
        where: {
          type: {
            in: [
              ReportType.SCAM,
              ReportType.THEFT,
              ReportType.UNSAFE_SITUATION,
            ],
          },
        },
      }),
    ]);

    return {
      sessions_completed: publicCount(sessionsCompleted),
      requests_helped: publicCount(requestsApproved),
      requests_rejected: publicCount(requestsRejected),
      reports_filed: publicCount(reportsFiled),
      crisis_support_routes: publicCount(crisisRouted),
      harm_reports: publicCount(harmReports),
      min_count: PUBLIC_MIN_COUNT,
    };
  }

  async listQueue() {
    const appeals = await this.prisma.appeal.findMany({
      where: { status: AppealStatus.OPEN },
      orderBy: { createdAt: 'asc' },
      include: {
        request: {
          include: {
            incidents: {
              where: { source: SafetyIncidentSource.REQUEST_VETTING },
              orderBy: { createdAt: 'desc' },
              take: 1,
            },
          },
        },
      },
    });

    return appeals.map((appeal) => {
      const incident = appeal.request.incidents[0];
      return {
        appeal_id: appeal.id,
        status: appeal.status,
        reason: appeal.reason,
        created_at: appeal.createdAt,
        request: toPublicRequest(appeal.request),
        triggered_rule: incident?.triggeredRule ?? null,
        reason_code: incident?.reasonCode ?? null,
      };
    });
  }

  async uphold(appealId: string, reviewerId: string) {
    return this.resolve(appealId, reviewerId, 'UPHELD');
  }

  async overturn(appealId: string, reviewerId: string) {
    return this.resolve(appealId, reviewerId, 'OVERTURNED');
  }

  private async resolve(
    appealId: string,
    reviewerId: string,
    status: 'UPHELD' | 'OVERTURNED',
  ) {
    const appeal = await this.prisma.appeal.findUnique({
      where: { id: appealId },
    });
    if (!appeal) {
      throw new NotFoundException('Appeal not found');
    }
    if (appeal.status !== AppealStatus.OPEN) {
      throw new ConflictException('This appeal has already been reviewed');
    }

    const updated = await this.prisma.$transaction(async (tx) => {
      if (status === 'OVERTURNED') {
        await tx.request.update({
          where: { id: appeal.requestId },
          data: { status: RequestStatus.APPROVED },
        });
      }

      return tx.appeal.update({
        where: { id: appealId },
        data: {
          status,
          reviewerId,
          reviewedAt: new Date(),
        },
        include: { request: true },
      });
    });

    return {
      appeal_id: updated.id,
      status: updated.status,
      request: toPublicRequest(updated.request),
    };
  }
}
