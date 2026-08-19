import { Module } from '@nestjs/common';
import { SessionService } from './session.service';
import { SessionController } from './session.controller';
import { SessionGateway } from './session.gateway';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { VerificationModule } from '../verification/verification.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [VerificationModule, NotificationsModule],
  controllers: [SessionController],
  providers: [SessionService, SessionGateway, PrismaService],
  exports: [SessionService],
})
export class SessionModule {}
