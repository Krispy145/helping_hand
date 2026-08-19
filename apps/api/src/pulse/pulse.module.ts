import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RolesGuard } from '../auth/roles.guard';
import { PulseController } from './pulse.controller';
import { PublicPulseController } from './public-pulse.controller';
import { PulseService } from './pulse.service';

@Module({
  controllers: [PublicPulseController, PulseController],
  providers: [PulseService, PrismaService, RolesGuard],
})
export class PulseModule {}
