import { OnModuleInit } from '@nestjs/common';
import { INotificationService } from '../../domain/services/notification.service.interface';
export declare class FcmNotificationService implements INotificationService, OnModuleInit {
    private readonly logger;
    onModuleInit(): void;
    send(tokens: string[], title: string, body: string, data?: Record<string, string>): Promise<void>;
}
