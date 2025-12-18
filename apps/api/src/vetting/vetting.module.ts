import { Module } from '@nestjs/common';
import { VettingService } from './vetting.service';
import { VettingListener } from './vetting.listener';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';

@Module({
  providers: [VettingService, VettingListener, PrismaService],
})
export class VettingModule {}
