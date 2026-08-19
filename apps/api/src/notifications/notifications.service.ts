import { Inject, Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import type { INotificationService } from '../domain/services/notification.service.interface';

export type SessionPushEvent =
  | 'help_offered'
  | 'new_message'
  | 'assist_completed'
  | 'assist_ended';

const COPY: Record<SessionPushEvent, { title: string; body: string }> = {
  help_offered: {
    title: 'Someone is offering help',
    body: 'Open the conversation when you are ready.',
  },
  new_message: {
    title: 'New message',
    body: 'You have a new message in your conversation.',
  },
  assist_completed: {
    title: 'Request completed',
    body: 'The assist was marked as offered.',
  },
  assist_ended: {
    title: 'Assist ended',
    body: 'The request is open on the map again.',
  },
};

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly prisma: PrismaService,
    @Inject('INotificationService')
    private readonly push: INotificationService,
  ) {}

  async registerDevice(userId: string, token: string, platform?: string) {
    const trimmed = token.trim();
    if (!trimmed) return { registered: false };

    await this.prisma.deviceToken.upsert({
      where: { token: trimmed },
      update: {
        userId,
        platform: platform?.trim() || 'unknown',
      },
      create: {
        userId,
        token: trimmed,
        platform: platform?.trim() || 'unknown',
      },
    });
    return { registered: true };
  }

  async unregisterDevice(token: string) {
    const trimmed = token.trim();
    if (!trimmed) return { unregistered: false };
    await this.prisma.deviceToken.deleteMany({ where: { token: trimmed } });
    return { unregistered: true };
  }

  async notifyUser(
    userId: string,
    event: SessionPushEvent,
    data: Record<string, string>,
  ) {
    const devices = await this.prisma.deviceToken.findMany({
      where: { userId },
      select: { token: true },
    });
    const tokens = devices.map((device) => device.token);
    if (tokens.length === 0) return;

    const copy = COPY[event];
    try {
      await this.push.send(tokens, copy.title, copy.body, {
        type: event,
        ...data,
      });
    } catch (error) {
      this.logger.warn(`Push failed for ${event}`, error);
    }
  }
}
