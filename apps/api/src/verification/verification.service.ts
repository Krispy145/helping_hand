import {
  ForbiddenException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { VerificationFailureReason, VerificationStatus } from '@prisma/client';
import { randomUUID } from 'crypto';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { toPublicUser } from '../common/public-serializers';
import {
  VerificationStubCompleteDto,
  VerificationWebhookDto,
} from './dto/verification.dto';

const STUB_PROVIDER = 'stub';

@Injectable()
export class VerificationService {
  constructor(private readonly prisma: PrismaService) {}

  get stubEnabled() {
    if (process.env.VERIFICATION_STUB === 'false') return false;
    return process.env.NODE_ENV !== 'production';
  }

  async getStatus(userId: string) {
    const user = await this.requireUser(userId);
    return this.toStatus(user);
  }

  async start(userId: string) {
    const user = await this.requireUser(userId);
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user);
    }
    if (
      user.verificationStatus === VerificationStatus.FAILED &&
      user.verificationFailureReason === VerificationFailureReason.UNDERAGE
    ) {
      throw new ForbiddenException('Helping Hand is for adults 18 and over.');
    }

    const updated = await this.prisma.user.update({
      where: { id: userId },
      data: {
        verificationStatus: VerificationStatus.PENDING,
        verificationProvider: STUB_PROVIDER,
        verificationProviderRef: randomUUID(),
        verificationFailureReason: null,
        verifiedAt: null,
      },
    });
    return this.toStatus(updated);
  }

  async handleWebhook(secret: string | undefined, dto: VerificationWebhookDto) {
    const expected =
      process.env.VERIFICATION_WEBHOOK_SECRET ?? 'dev-verification-secret';
    if (!secret || secret !== expected) {
      throw new UnauthorizedException('Invalid verification webhook secret');
    }
    return this.applyProviderResult(dto.referenceId, dto.approved, dto.isAdult);
  }

  async stubComplete(userId: string, dto: VerificationStubCompleteDto) {
    if (!this.stubEnabled) {
      throw new NotFoundException();
    }

    let user = await this.requireUser(userId);
    if (!user.verificationProviderRef) {
      await this.start(userId);
      user = await this.requireUser(userId);
    }

    if (dto.outcome === 'verified') {
      return this.applyProviderResult(
        user.verificationProviderRef!,
        true,
        true,
      );
    }
    if (dto.outcome === 'underage') {
      return this.applyProviderResult(
        user.verificationProviderRef!,
        true,
        false,
      );
    }
    return this.applyProviderResult(user.verificationProviderRef!, false, true);
  }

  async assertVerifiedAdult(userId: string) {
    const user = await this.requireUser(userId);
    if (user.verificationStatus === VerificationStatus.VERIFIED) return user;
    if (user.verificationFailureReason === VerificationFailureReason.UNDERAGE) {
      throw new ForbiddenException('Helping Hand is for adults 18 and over.');
    }
    throw new ForbiddenException(
      'Verify your identity before requesting or offering help.',
    );
  }

  private async applyProviderResult(
    referenceId: string,
    approved: boolean,
    isAdult: boolean,
  ) {
    const user = await this.prisma.user.findUnique({
      where: { verificationProviderRef: referenceId },
    });
    if (!user) throw new NotFoundException('Unknown verification reference');

    if (!isAdult) {
      const updated = await this.prisma.user.update({
        where: { id: user.id },
        data: {
          verificationStatus: VerificationStatus.FAILED,
          verificationFailureReason: VerificationFailureReason.UNDERAGE,
          verifiedAt: null,
        },
      });
      return this.toStatus(updated);
    }

    if (!approved) {
      const updated = await this.prisma.user.update({
        where: { id: user.id },
        data: {
          verificationStatus: VerificationStatus.FAILED,
          verificationFailureReason:
            VerificationFailureReason.PROVIDER_REJECTED,
          verifiedAt: null,
        },
      });
      return this.toStatus(updated);
    }

    const updated = await this.prisma.user.update({
      where: { id: user.id },
      data: {
        verificationStatus: VerificationStatus.VERIFIED,
        verificationFailureReason: null,
        verifiedAt: new Date(),
      },
    });
    return this.toStatus(updated);
  }

  private async requireUser(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  private toStatus(user: {
    verificationStatus: VerificationStatus;
    verificationProvider: string | null;
    verificationProviderRef: string | null;
    verifiedAt: Date | null;
    verificationFailureReason: VerificationFailureReason | null;
    id: string;
    email: string;
    name: string | null;
    role: string;
    createdAt: Date;
    updatedAt: Date;
  }) {
    return {
      ...toPublicUser(user, { includeEmail: true }),
      provider: user.verificationProvider,
      reference_id: user.verificationProviderRef,
      stub: this.stubEnabled,
    };
  }
}
