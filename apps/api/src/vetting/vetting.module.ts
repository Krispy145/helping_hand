import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { VettingListener } from './vetting.listener';
import { VettingService } from './vetting.service';
import {
  StubContentRiskClassifier,
  StubIntentAnalyzer,
} from './vetting-providers';

@Module({
  providers: [
    VettingService,
    VettingListener,
    PrismaService,
    { provide: 'ContentRiskClassifier', useClass: StubContentRiskClassifier },
    { provide: 'IntentAnalyzer', useClass: StubIntentAnalyzer },
  ],
  exports: [VettingService],
})
export class VettingModule {}
