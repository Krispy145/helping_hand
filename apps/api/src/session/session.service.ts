import {
  Injectable,
  ConflictException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import {
  Message,
  Prisma,
  RequestStatus,
  SessionStatus,
  VerificationFailureReason,
  VerificationStatus,
} from '@prisma/client';

type SessionWithRequest = Prisma.SessionGetPayload<{
  include: { request: true };
}>;

@Injectable()
export class SessionService {
  constructor(private prisma: PrismaService) {}

  async checkOfferAvailability(requestId: string, helperId: string) {
    const helper = await this.prisma.user.findUnique({
      where: { id: helperId },
      select: {
        verificationStatus: true,
        verificationFailureReason: true,
      },
    });
    if (!helper) throw new NotFoundException('User not found');
    if (helper.verificationStatus !== VerificationStatus.VERIFIED) {
      return {
        open: false,
        busy: false,
        reason:
          helper.verificationFailureReason ===
          VerificationFailureReason.UNDERAGE
            ? 'underage'
            : 'unverified',
      };
    }

    const request = await this.prisma.request.findUnique({
      where: { id: requestId },
      include: { session: true },
    });
    if (!request) throw new NotFoundException('Request not found');
    return this.offerAvailabilityFor(request, helperId);
  }

  async createSession(requestId: string, helperId: string) {
    try {
      const sessionId = await this.prisma.$transaction(async (tx) => {
        await tx.$queryRaw`SELECT id FROM "Request" WHERE id = ${requestId} FOR UPDATE`;

        const request = await tx.request.findUnique({
          where: { id: requestId },
          include: { session: true, user: true },
        });
        if (!request) throw new NotFoundException('Request not found');

        const availability = this.offerAvailabilityFor(request, helperId);
        if (availability.sessionId) {
          return availability.sessionId;
        }
        if (!availability.open) {
          if (availability.busy) {
            throw new ConflictException('This request is already busy');
          }
          if (availability.reason === 'own_request') {
            throw new ForbiddenException('You cannot assist your own request');
          }
          throw new ForbiddenException('This request is not open for help');
        }

        const helper = await tx.user.findUnique({ where: { id: helperId } });
        if (!helper) throw new NotFoundException('Helper not found');

        const created = await tx.session.create({
          data: {
            requestId,
            helperId,
            status: SessionStatus.ACTIVE,
          },
        });
        await tx.message.create({
          data: {
            sessionId: created.id,
            senderId: request.userId,
            content: this.buildRequestIntro(request),
          },
        });
        await tx.request.update({
          where: { id: requestId },
          data: { status: RequestStatus.IN_PROGRESS },
        });
        return created.id;
      });

      const request = await this.prisma.request.findUnique({
        where: { id: requestId },
      });
      if (request) {
        await this.ensureRequestIntroMessage(sessionId, request);
      }
      return this.getSession(sessionId, helperId);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('This request is already busy');
      }
      throw error;
    }
  }

  async getSession(sessionId: string, userId: string) {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
      include: {
        request: { include: { user: true } },
        helper: true,
      },
    });
    if (!session) throw new NotFoundException('Session not found');
    this.assertParticipant(session, userId);

    return {
      id: session.id,
      requestId: session.requestId,
      helperId: session.helperId,
      status: session.status,
      request: {
        title: session.request.title,
        description: session.request.description,
        category: session.request.category,
        urgency: session.request.urgency,
        status: session.request.status,
      },
      requester: {
        id: session.request.user.id,
        name: session.request.user.name,
      },
      helper: {
        id: session.helper.id,
        name: session.helper.name,
      },
    };
  }

  async saveMessage(
    sessionId: string,
    senderId: string,
    content: string,
  ): Promise<Message> {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
      include: { request: true },
    });
    if (!session) throw new NotFoundException('Session not found');
    if (session.status !== SessionStatus.ACTIVE)
      throw new ForbiddenException('Session is not active');
    this.assertParticipant(session, senderId);

    return this.prisma.message.create({
      data: {
        sessionId,
        senderId,
        content,
      },
    });
  }

  async getMessages(sessionId: string, userId: string): Promise<Message[]> {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
      include: { request: true },
    });
    if (!session) throw new NotFoundException('Session not found');
    this.assertParticipant(session, userId);
    await this.ensureRequestIntroMessage(sessionId, session.request);

    return this.prisma.message.findMany({
      where: { sessionId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async cancelAssist(sessionId: string, userId: string) {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
      include: { request: true },
    });
    if (!session) throw new NotFoundException('Session not found');
    this.assertParticipant(session, userId);
    if (session.status !== SessionStatus.ACTIVE) {
      throw new ForbiddenException('This session is no longer active');
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.message.deleteMany({ where: { sessionId } });
      await tx.session.delete({ where: { id: sessionId } });
      await tx.request.update({
        where: { id: session.requestId },
        data: { status: RequestStatus.APPROVED },
      });
    });

    return { status: 'CANCELLED', requestStatus: RequestStatus.APPROVED };
  }

  async completeAssist(sessionId: string, userId: string) {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
      include: { request: true },
    });
    if (!session) throw new NotFoundException('Session not found');
    this.assertParticipant(session, userId);
    if (session.status !== SessionStatus.ACTIVE) {
      throw new ForbiddenException('This session is no longer active');
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.session.update({
        where: { id: sessionId },
        data: { status: SessionStatus.COMPLETED },
      });
      await tx.request.update({
        where: { id: session.requestId },
        data: { status: RequestStatus.COMPLETED },
      });
    });

    return this.getSession(sessionId, userId);
  }

  async getUserSessions(userId: string) {
    const sessions = await this.prisma.session.findMany({
      where: {
        status: SessionStatus.ACTIVE,
        OR: [{ helperId: userId }, { request: { userId: userId } }],
      },
      include: {
        request: { include: { user: true } },
        helper: true,
      },
      orderBy: { updatedAt: 'desc' },
    });

    return sessions.map((session) => ({
      id: session.id,
      requestId: session.requestId,
      helperId: session.helperId,
      status: session.status,
      request: {
        title: session.request.title,
        description: session.request.description,
        category: session.request.category,
        urgency: session.request.urgency,
        status: session.request.status,
      },
      requester: {
        id: session.request.user.id,
        name: session.request.user.name,
      },
      helper: {
        id: session.helper.id,
        name: session.helper.name,
      },
    }));
  }

  private offerAvailabilityFor(
    request: {
      userId: string;
      status: RequestStatus;
      session?: { id: string; helperId: string; status: SessionStatus } | null;
    },
    helperId: string,
  ) {
    const activeSession =
      request.session?.status === SessionStatus.ACTIVE ? request.session : null;

    if (request.userId === helperId) {
      if (activeSession) {
        return {
          open: false,
          busy: true,
          reason: 'own_request' as const,
          sessionId: activeSession.id,
        };
      }
      return { open: false, busy: false, reason: 'own_request' as const };
    }
    if (activeSession) {
      if (activeSession.helperId === helperId) {
        return {
          open: false,
          busy: true,
          reason: 'already_helping' as const,
          sessionId: activeSession.id,
        };
      }
      return { open: false, busy: true, reason: 'busy' as const };
    }

    if (request.status === RequestStatus.IN_PROGRESS) {
      return { open: false, busy: true, reason: 'busy' as const };
    }

    if (request.status !== RequestStatus.APPROVED) {
      return { open: false, busy: false, reason: 'not_open' as const };
    }

    return { open: true, busy: false, reason: 'open' as const };
  }

  private assertParticipant(session: SessionWithRequest, userId: string) {
    if (session.helperId !== userId && session.request.userId !== userId) {
      throw new ForbiddenException('You are not a participant in this session');
    }
  }

  private buildRequestIntro(request: {
    title: string;
    description: string;
    category?: string | null;
    urgency: string;
  }): string {
    const lines = [request.title, '', request.description];
    const meta = [
      request.category ? `Category: ${request.category}` : null,
      `Urgency: ${request.urgency}`,
    ].filter(Boolean);
    if (meta.length > 0) {
      lines.push('', meta.join(' · '));
    }
    return lines.join('\n');
  }

  private async ensureRequestIntroMessage(
    sessionId: string,
    request: {
      userId: string;
      title: string;
      description: string;
      category?: string | null;
      urgency: string;
    },
  ) {
    const existing = await this.prisma.message.count({ where: { sessionId } });
    if (existing > 0) return;
    await this.prisma.message.create({
      data: {
        sessionId,
        senderId: request.userId,
        content: this.buildRequestIntro(request),
      },
    });
  }
}
