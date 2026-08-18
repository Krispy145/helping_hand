import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { VerifiedAdultGuard } from './verified-adult.guard';
import { VerificationController } from './verification.controller';
import { VerificationService } from './verification.service';

@Module({
  controllers: [VerificationController],
  providers: [VerificationService, VerifiedAdultGuard, PrismaService],
  exports: [VerificationService, VerifiedAdultGuard],
})
export class VerificationModule {}
