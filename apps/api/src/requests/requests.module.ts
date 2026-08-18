import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestsController } from './requests.controller';
import { RequestsService } from './requests.service';
import { VerificationModule } from '../verification/verification.module';
import { VettingModule } from '../vetting/vetting.module';

@Module({
  imports: [VerificationModule, VettingModule],
  controllers: [RequestsController],
  providers: [RequestsService, PrismaService],
})
export class RequestsModule {}
