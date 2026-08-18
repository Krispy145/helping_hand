import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestsController } from './requests.controller';
import { RequestsService } from './requests.service';
import { VerificationModule } from '../verification/verification.module';

@Module({
  imports: [VerificationModule],
  controllers: [RequestsController],
  providers: [RequestsService, PrismaService],
})
export class RequestsModule {}
