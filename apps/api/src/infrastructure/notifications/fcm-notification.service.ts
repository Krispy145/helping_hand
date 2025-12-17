import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { INotificationService } from '../../domain/services/notification.service.interface';

@Injectable()
export class FcmNotificationService implements INotificationService, OnModuleInit {
  private readonly logger = new Logger(FcmNotificationService.name);

  onModuleInit() {
    if (!admin.apps.length) {
      try {
        admin.initializeApp({
          credential: admin.credential.applicationDefault(),
        });
        this.logger.log('Firebase Admin Initialized');
      } catch (error) {
        this.logger.warn('Firebase Admin initialization failed (likely no credentials provided for local dev). Notifications will not be sent.', error);
      }
    }
  }

  async send(tokens: string[], title: string, body: string, data?: Record<string, string>): Promise<void> {
    if (tokens.length === 0) return;

    try {
      const response = await admin.messaging().sendEachForMulticast({
        tokens,
        notification: {
          title,
          body,
        },
        data,
      });
      this.logger.log(`Sent notification to ${response.successCount} devices. Failed: ${response.failureCount}`);
    } catch (error) {
      this.logger.error('Error sending notification', error);
    }
  }
}
