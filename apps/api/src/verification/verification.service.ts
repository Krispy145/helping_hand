import {
  BadRequestException,
  ForbiddenException,
  Inject,
  Injectable,
  Logger,
  NotFoundException,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import {
  AgeVerificationAttempt,
  User,
  VerificationFailureReason,
  VerificationStatus,
} from '@prisma/client';
import { randomUUID } from 'crypto';
import { toPublicUser } from '../common/public-serializers';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import {
  EligibilityCheckDto,
  VerificationStubCompleteDto,
} from './dto/verification.dto';
import { AGE_VERIFICATION_PROVIDER } from './providers/age-verification.provider';
import type {
  AgeVerificationProvider,
  ProviderSessionResult,
  ProviderWebhookEvent,
} from './providers/age-verification.provider';
import { looksLikeYotiNotification } from './providers/yoti-webhook.verifier';
import {
  buildYotiUserViewUrl,
  loadVerificationConfig,
  VerificationConfig,
} from './verification.config';

const OPEN_ATTEMPT_STATUSES: VerificationStatus[] = [
  VerificationStatus.PENDING,
  VerificationStatus.REQUIRES_DOCUMENT,
];

@Injectable()
export class VerificationService {
  private readonly logger = new Logger(VerificationService.name);
  private readonly config: VerificationConfig;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(AGE_VERIFICATION_PROVIDER)
    private readonly provider: AgeVerificationProvider,
  ) {
    this.config = loadVerificationConfig();
  }

  get stubEnabled() {
    return this.config.stubEnabled && this.provider.name === 'stub';
  }

  get minimumUserAge() {
    return this.config.minimumUserAge;
  }

  async getStatus(userId: string) {
    const user = await this.expireIfNeeded(await this.requireUser(userId));
    const attempt = await this.latestAttempt(userId);
    return this.toStatus(user, attempt);
  }

  checkEligibility(dto: EligibilityCheckDto) {
    const dateOfBirth = dto.dateOfBirth?.trim();
    if (!dateOfBirth) {
      throw new BadRequestException('dateOfBirth is required');
    }
    const age = this.ageFromIsoDate(dateOfBirth);
    return {
      eligible: age >= this.config.minimumUserAge,
      age_threshold: this.config.minimumUserAge,
    };
  }

  async start(
    userId: string,
    method: 'age-estimation' | 'doc-scan' = 'age-estimation',
  ) {
    const user = await this.expireIfNeeded(await this.requireUser(userId));
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user, await this.latestAttempt(userId));
    }
    this.assertNotPermanentlyBlocked(user);

    const existing = await this.openAttempt(userId);
    if (existing) {
      return this.toStatus(user, existing);
    }

    const attemptId = randomUUID();
    let session;
    try {
      session = await this.provider.createSession({
        referenceId: attemptId,
        ttlSeconds: this.config.sessionTtlSeconds,
        minimumAge: this.config.minimumUserAge,
        estimationThreshold: this.config.ageEstimationThreshold,
        callbackUrl: this.config.callbackUrl,
        cancelUrl: this.config.cancelUrl,
        notificationUrl: this.config.notificationUrl,
      });
    } catch (error) {
      if (error instanceof ServiceUnavailableException) throw error;
      this.logger.warn('Provider session creation failed');
      throw new ServiceUnavailableException(
        'Age verification provider is unavailable',
      );
    }

    const [attempt, updated] = await this.prisma.$transaction([
      this.prisma.ageVerificationAttempt.create({
        data: {
          id: attemptId,
          userId,
          provider: this.provider.name,
          providerSessionId: session.providerSessionId,
          status: VerificationStatus.PENDING,
          ageThreshold: this.config.minimumUserAge,
          method: method === 'doc-scan' ? 'DOC_SCAN' : 'AGE_ESTIMATION',
          expiresAt: session.expiresAt,
        },
      }),
      this.prisma.user.update({
        where: { id: userId },
        data: {
          verificationStatus: VerificationStatus.PENDING,
          verificationProvider: this.provider.name,
          verificationProviderRef: session.providerSessionId,
          verificationFailureReason: null,
          verifiedAt: null,
          ageThreshold: this.config.minimumUserAge,
        },
      }),
    ]);

    return this.toStatus(updated, attempt, {
      launchUrl: session.launchUrl,
      documentLaunchUrl: session.documentLaunchUrl,
    });
  }

  async startDocument(userId: string) {
    const user = await this.expireIfNeeded(await this.requireUser(userId));
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user, await this.latestAttempt(userId));
    }
    this.assertNotPermanentlyBlocked(user);

    const existing = await this.openAttempt(userId);
    if (existing) {
      await this.prisma.user.update({
        where: { id: userId },
        data: { verificationStatus: VerificationStatus.REQUIRES_DOCUMENT },
      });
      const updated = await this.requireUser(userId);
      return this.toStatus(updated, existing);
    }
    return this.start(userId, 'doc-scan');
  }

  async refresh(userId: string) {
    const user = await this.expireIfNeeded(await this.requireUser(userId));
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user, await this.latestAttempt(userId));
    }

    const attempt = await this.openAttempt(userId);
    if (!attempt) {
      return this.toStatus(user, await this.latestAttempt(userId));
    }

    const result = await this.provider.getSessionResult(
      attempt.providerSessionId,
    );
    if (!result) {
      return this.toStatus(await this.requireUser(userId), attempt);
    }
    return this.applyProviderSessionResult(attempt, result);
  }

  async handleWebhook(
    secret: string | undefined,
    body: Record<string, unknown>,
  ) {
    if (looksLikeYotiNotification(body)) {
      if (!this.provider.verifyWebhook?.(body)) {
        throw new UnauthorizedException(
          'Invalid verification webhook signature',
        );
      }
      const event = this.provider.parseWebhook(body);
      if (!event) throw new BadRequestException('Invalid verification webhook');
      return this.handleProviderWebhook(event, true);
    }

    if (!this.stubEnabled) {
      throw new UnauthorizedException('Invalid verification webhook');
    }
    if (!secret || secret !== this.config.webhookSecret) {
      throw new UnauthorizedException('Invalid verification webhook secret');
    }
    const event = this.provider.parseWebhook(body);
    if (!event) throw new BadRequestException('Invalid verification webhook');
    return this.handleProviderWebhook(event, false);
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

    const referenceId = user.verificationProviderRef!;
    if (dto.outcome === 'verified') {
      return this.applyStubResult(referenceId, 'COMPLETE', 'STUB', false);
    }
    if (dto.outcome === 'underage') {
      return this.applyStubResult(referenceId, 'FAIL', 'STUB', false);
    }
    if (dto.outcome === 'document') {
      return this.applyStubResult(referenceId, 'ERROR', 'STUB', true);
    }
    return this.applyStubResult(referenceId, 'ERROR', 'STUB', false);
  }

  async assertVerifiedAdult(userId: string) {
    const user = await this.expireIfNeeded(await this.requireUser(userId));
    if (user.verificationStatus === VerificationStatus.VERIFIED) return user;
    if (user.verificationFailureReason === VerificationFailureReason.UNDERAGE) {
      throw new ForbiddenException(
        `Helping Hand is for adults ${this.config.minimumUserAge} and over.`,
      );
    }
    throw new ForbiddenException(
      'Verify your identity before requesting or offering help.',
    );
  }

  private async handleProviderWebhook(
    event: ProviderWebhookEvent,
    fetchCanonical: boolean,
  ) {
    const attempt = await this.prisma.ageVerificationAttempt.findUnique({
      where: { providerSessionId: event.providerSessionId },
    });
    if (!attempt) {
      throw new NotFoundException('Unknown verification reference');
    }

    const duplicate = await this.prisma.ageVerificationNotification.findUnique({
      where: { id: event.notificationId },
    });
    if (!duplicate) {
      await this.prisma.ageVerificationNotification.create({
        data: {
          id: event.notificationId,
          attemptId: attempt.id,
          state: event.state,
        },
      });
    }

    const user = await this.requireUser(attempt.userId);
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user, attempt);
    }

    if (fetchCanonical) {
      const result = await this.provider.getSessionResult(
        attempt.providerSessionId,
      );
      if (result) {
        return this.applyProviderSessionResult(attempt, result);
      }
    }

    return this.applyProviderSessionResult(attempt, {
      providerSessionId: event.providerSessionId,
      status: this.webhookStateToStatus(event.state),
      method: event.method,
      documentAvailable: event.state === 'ERROR',
    });
  }

  private webhookStateToStatus(state: string): ProviderSessionResult['status'] {
    switch (state) {
      case 'COMPLETE':
        return 'COMPLETE';
      case 'FAIL':
        return 'FAIL';
      case 'CANCELLED':
        return 'CANCELLED';
      case 'EXPIRED':
        return 'EXPIRED';
      case 'IN_PROGRESS':
        return 'IN_PROGRESS';
      case 'PENDING':
        return 'PENDING';
      default:
        return 'ERROR';
    }
  }

  private async applyStubResult(
    referenceId: string,
    status: ProviderSessionResult['status'],
    method: string,
    documentAvailable = true,
  ) {
    const attempt = await this.prisma.ageVerificationAttempt.findUnique({
      where: { providerSessionId: referenceId },
    });
    if (!attempt) throw new NotFoundException('Unknown verification reference');
    return this.applyProviderSessionResult(attempt, {
      providerSessionId: referenceId,
      status,
      method,
      documentAvailable,
    });
  }

  private async applyProviderSessionResult(
    attempt: AgeVerificationAttempt,
    result: ProviderSessionResult,
  ) {
    const user = await this.requireUser(attempt.userId);
    if (user.verificationStatus === VerificationStatus.VERIFIED) {
      return this.toStatus(user, attempt);
    }

    const mapped = this.mapProviderResult(result);
    const updatedAttempt = await this.prisma.ageVerificationAttempt.update({
      where: { id: attempt.id },
      data: {
        status: mapped.status,
        failureReason: mapped.failureReason,
        method: result.method ?? attempt.method,
        verifiedAt:
          mapped.status === VerificationStatus.VERIFIED ? new Date() : null,
      },
    });

    const updatedUser = await this.prisma.user.update({
      where: { id: attempt.userId },
      data: {
        verificationStatus: mapped.status,
        verificationFailureReason: mapped.failureReason,
        verifiedAt:
          mapped.status === VerificationStatus.VERIFIED ? new Date() : null,
        verificationProvider: attempt.provider,
        verificationProviderRef: attempt.providerSessionId,
        ageThreshold: attempt.ageThreshold,
      },
    });

    return this.toStatus(updatedUser, updatedAttempt);
  }

  private mapProviderResult(result: ProviderSessionResult): {
    status: VerificationStatus;
    failureReason: VerificationFailureReason | null;
  } {
    switch (result.status) {
      case 'COMPLETE':
        return { status: VerificationStatus.VERIFIED, failureReason: null };
      case 'FAIL':
        if (result.documentAvailable) {
          return {
            status: VerificationStatus.REQUIRES_DOCUMENT,
            failureReason: null,
          };
        }
        return {
          status: VerificationStatus.FAILED,
          failureReason: VerificationFailureReason.UNDERAGE,
        };
      case 'ERROR':
        if (result.documentAvailable) {
          return {
            status: VerificationStatus.REQUIRES_DOCUMENT,
            failureReason: null,
          };
        }
        return {
          status: VerificationStatus.FAILED,
          failureReason: VerificationFailureReason.PROVIDER_REJECTED,
        };
      case 'EXPIRED':
        return {
          status: VerificationStatus.FAILED,
          failureReason: VerificationFailureReason.EXPIRED,
        };
      case 'CANCELLED':
        return { status: VerificationStatus.PENDING, failureReason: null };
      default:
        return { status: VerificationStatus.PENDING, failureReason: null };
    }
  }

  private async expireIfNeeded(user: User): Promise<User> {
    if (!OPEN_ATTEMPT_STATUSES.includes(user.verificationStatus)) {
      return user;
    }
    const attempt = await this.latestAttempt(user.id);
    if (!attempt?.expiresAt || attempt.expiresAt > new Date()) {
      return user;
    }
    await this.prisma.ageVerificationAttempt.update({
      where: { id: attempt.id },
      data: {
        status: VerificationStatus.FAILED,
        failureReason: VerificationFailureReason.EXPIRED,
      },
    });
    return this.prisma.user.update({
      where: { id: user.id },
      data: {
        verificationStatus: VerificationStatus.FAILED,
        verificationFailureReason: VerificationFailureReason.EXPIRED,
        verifiedAt: null,
      },
    });
  }

  private async openAttempt(userId: string) {
    const attempt = await this.latestAttempt(userId);
    if (!attempt) return null;
    if (!OPEN_ATTEMPT_STATUSES.includes(attempt.status)) return null;
    if (attempt.expiresAt && attempt.expiresAt <= new Date()) return null;
    return attempt;
  }

  private async latestAttempt(userId: string) {
    return this.prisma.ageVerificationAttempt.findFirst({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  private assertNotPermanentlyBlocked(user: User) {
    if (
      user.verificationStatus === VerificationStatus.FAILED &&
      user.verificationFailureReason === VerificationFailureReason.UNDERAGE
    ) {
      throw new ForbiddenException(
        `Helping Hand is for adults ${this.config.minimumUserAge} and over.`,
      );
    }
  }

  private async requireUser(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  private ageFromIsoDate(value: string): number {
    const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
    if (!match) {
      throw new BadRequestException('dateOfBirth must be YYYY-MM-DD');
    }
    const year = Number(match[1]);
    const month = Number(match[2]);
    const day = Number(match[3]);
    const dob = new Date(Date.UTC(year, month - 1, day));
    if (
      dob.getUTCFullYear() !== year ||
      dob.getUTCMonth() !== month - 1 ||
      dob.getUTCDate() !== day
    ) {
      throw new BadRequestException('dateOfBirth must be a valid date');
    }
    const today = new Date();
    let age = today.getUTCFullYear() - year;
    const monthDiff = today.getUTCMonth() - (month - 1);
    if (monthDiff < 0 || (monthDiff === 0 && today.getUTCDate() < day)) {
      age -= 1;
    }
    if (age > 130 || age < 0) {
      throw new BadRequestException('dateOfBirth must be a valid date');
    }
    return age;
  }

  private toStatus(
    user: User,
    attempt?: AgeVerificationAttempt | null,
    urls?: { launchUrl?: string | null; documentLaunchUrl?: string | null },
  ) {
    return {
      ...toPublicUser(user, { includeEmail: true }),
      provider: user.verificationProvider,
      reference_id: user.verificationProviderRef,
      stub: this.stubEnabled,
      age_threshold: user.ageThreshold ?? this.config.minimumUserAge,
      launch_url:
        urls?.launchUrl ?? this.launchUrlFor(attempt, 'age-estimation'),
      document_launch_url:
        urls?.documentLaunchUrl ?? this.launchUrlFor(attempt, 'doc-scan'),
      expires_at: attempt?.expiresAt ?? null,
    };
  }

  private launchUrlFor(
    attempt: AgeVerificationAttempt | null | undefined,
    method: 'age-estimation' | 'doc-scan',
  ): string | null {
    if (!attempt || this.provider.name !== 'YOTI') return null;
    return buildYotiUserViewUrl(this.config, attempt.providerSessionId, method);
  }
}
