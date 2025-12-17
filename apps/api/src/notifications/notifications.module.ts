import { Module } from '@nestjs/common';
import { FcmNotificationService } from '../infrastructure/notifications/fcm-notification.service';

@Module({
  providers: [
    {
      provide: 'INotificationService',
      useClass: FcmNotificationService,
    },
  ],
  exports: ['INotificationService'],
})
export class NotificationsModule {}
