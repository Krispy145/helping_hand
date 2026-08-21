import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import {
  AGE_VERIFICATION_PROVIDER,
  AgeVerificationProvider,
} from './providers/age-verification.provider';
import { StubAgeVerificationProvider } from './providers/stub-age-verification.provider';
import { YotiAgeVerificationProvider } from './providers/yoti-age-verification.provider';
import { VerifiedAdultGuard } from './verified-adult.guard';
import { VerificationController } from './verification.controller';
import {
  isYotiConfigured,
  loadVerificationConfig,
} from './verification.config';
import { VerificationService } from './verification.service';

export function createAgeVerificationProvider(): AgeVerificationProvider {
  const config = loadVerificationConfig();
  if (
    isYotiConfigured(
      config.yotiSdkId ?? undefined,
      config.yotiApiKey ?? undefined,
    )
  ) {
    return new YotiAgeVerificationProvider(config);
  }
  if (config.stubEnabled) {
    return new StubAgeVerificationProvider();
  }
  return new YotiAgeVerificationProvider(config);
}

@Module({
  controllers: [VerificationController],
  providers: [
    VerificationService,
    VerifiedAdultGuard,
    PrismaService,
    {
      provide: AGE_VERIFICATION_PROVIDER,
      useFactory: createAgeVerificationProvider,
    },
  ],
  exports: [VerificationService, VerifiedAdultGuard],
})
export class VerificationModule {}
