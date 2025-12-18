import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { Session, Message, SessionStatus } from '@prisma/client';
// import { VettingService } from '../vetting/vetting.service'; // TODO: Enable when connecting

@Injectable()
export class SessionService {
  constructor(
    private prisma: PrismaService,
    // private vettingService: VettingService,
  ) {}

  async createSession(requestId: string, helperId: string): Promise<Session> {
    const request = await this.prisma.request.findUnique({ where: { id: requestId } });
    if (!request) throw new NotFoundException('Request not found');

    // Basic validation could go here (e.g. check if request is PENDING_VETTING or APPROVED)

    return this.prisma.session.create({
      data: {
        requestId,
        helperId,
        status: SessionStatus.ACTIVE,
      },
    });
  }

  async saveMessage(sessionId: string, senderId: string, content: string): Promise<Message> {
    const session = await this.prisma.session.findUnique({ where: { id: sessionId } });
    if (!session) throw new NotFoundException('Session not found');
    if (session.status !== SessionStatus.ACTIVE) throw new ForbiddenException('Session is not active');

    // Security: Check if sender is part of session
    // This is often handled by Gateway guards, but good to have here too if called directly vs WS
    // For now assuming caller validates ownership or Gateway does.

    // TODO: content = await this.vettingService.sanitize(content);

    return this.prisma.message.create({
      data: {
        sessionId,
        senderId,
        content,
      },
    });
  }

  async getMessages(sessionId: string, userId: string): Promise<Message[]> {
    // Validate access
    const session = await this.prisma.session.findUnique({ 
        where: { id: sessionId },
        include: { request: true }
    });
    
    if (!session) throw new NotFoundException('Session not found');
    
    if (session.helperId !== userId && session.request.userId !== userId) {
        throw new ForbiddenException('You are not a participant in this session');
    }

    return this.prisma.message.findMany({
      where: { sessionId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async getUserSessions(userId: string): Promise<Session[]> {
    return this.prisma.session.findMany({
      where: {
        OR: [
          { helperId: userId },
          { request: { userId: userId } }
        ]
      },
      include: {
        request: true,
        helper: { select: { id: true, name: true } } // minimal helper info
      },
      orderBy: { updatedAt: 'desc' }
    });
  }
}
