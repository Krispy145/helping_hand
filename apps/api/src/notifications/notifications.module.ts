import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { FcmNotificationService } from '../infrastructure/notifications/fcm-notification.service';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';

@Module({
  controllers: [NotificationsController],
  providers: [
    PrismaService,
    NotificationsService,
    {
      provide: 'INotificationService',
      useClass: FcmNotificationService,
    },
  ],
  exports: [NotificationsService],
})
export class NotificationsModule {}
