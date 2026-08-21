/* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-member-access */
import { ForbiddenException, UnauthorizedException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { VerificationFailureReason, VerificationStatus } from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import {
  AGE_VERIFICATION_PROVIDER,
  AgeVerificationProvider,
} from './providers/age-verification.provider';
import { StubAgeVerificationProvider } from './providers/stub-age-verification.provider';
import { VerificationService } from './verification.service';

describe('VerificationService', () => {
  let service: VerificationService;
  const now = new Date('2026-08-18T10:00:00Z');

  const user = {
    id: 'user-1',
    email: 'pat@example.com',
    name: 'Pat',
    role: 'USER',
    verificationStatus: VerificationStatus.UNVERIFIED,
    verificationProvider: null,
    verificationProviderRef: null,
    verifiedAt: null,
    verificationFailureReason: null,
    ageThreshold: null,
    createdAt: now,
    updatedAt: now,
  };

  const mockPrisma = {
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    ageVerificationAttempt: {
      findFirst: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    ageVerificationNotification: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    $transaction: jest.fn((ops: Promise<unknown>[]) => Promise.all(ops)),
  };

  const stubProvider = new StubAgeVerificationProvider();

  beforeEach(async () => {
    jest.clearAllMocks();
    process.env.NODE_ENV = 'test';
    process.env.MINIMUM_USER_AGE = '18';
    delete process.env.VERIFICATION_STUB;
    delete process.env.YOTI_SDK_ID;
    delete process.env.YOTI_API_KEY;
    mockPrisma.ageVerificationAttempt.findFirst.mockResolvedValue(null);
    mockPrisma.ageVerificationAttempt.findUnique.mockResolvedValue(null);
    mockPrisma.ageVerificationNotification.findUnique.mockResolvedValue(null);
    mockPrisma.ageVerificationNotification.create.mockResolvedValue({});
    mockPrisma.user.findUnique.mockResolvedValue(user);
    mockPrisma.user.update.mockImplementation(({ data }) => ({
      ...user,
      ...data,
    }));
    mockPrisma.ageVerificationAttempt.create.mockImplementation(({ data }) => ({
      ...data,
      createdAt: now,
      updatedAt: now,
      method: data.method ?? null,
      failureReason: null,
      verifiedAt: null,
    }));
    mockPrisma.ageVerificationAttempt.update.mockImplementation(({ data }) => ({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-1',
      ageThreshold: 18,
      createdAt: now,
      updatedAt: now,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
      ...data,
    }));

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VerificationService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AGE_VERIFICATION_PROVIDER, useValue: stubProvider },
      ],
    }).compile();
    service = module.get(VerificationService);
  });

  it('starts a stub verification and stores a provider reference', async () => {
    const result = await service.start('user-1');
    expect(result.verification_status).toBe(VerificationStatus.PENDING);
    expect(result.provider).toBe('stub');
    expect(result.stub).toBe(true);
    expect(result.reference_id).toEqual(expect.any(String));
    expect(result.age_threshold).toBe(18);
    expect(mockPrisma.ageVerificationAttempt.create).toHaveBeenCalled();
  });

  it('does not create another session while one is already pending', async () => {
    mockPrisma.ageVerificationAttempt.findFirst.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-open',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'AGE_ESTIMATION',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2099-01-01T00:00:00Z'),
    });
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.PENDING,
      verificationProviderRef: 'ref-open',
    });

    const result = await service.start('user-1');
    expect(result.reference_id).toBe('ref-open');
    expect(mockPrisma.ageVerificationAttempt.create).not.toHaveBeenCalled();
  });

  it('returns current status for an already verified user', async () => {
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.VERIFIED,
      verifiedAt: now,
      ageThreshold: 18,
    });
    const result = await service.start('user-1');
    expect(result.verification_status).toBe(VerificationStatus.VERIFIED);
    expect(mockPrisma.ageVerificationAttempt.create).not.toHaveBeenCalled();
  });

  it('marks a provider-approved adult as verified without storing a date of birth', async () => {
    mockPrisma.ageVerificationAttempt.findUnique.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-1',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'STUB',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
    });
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationProviderRef: 'ref-1',
      verificationStatus: VerificationStatus.PENDING,
    });

    const result = await service.handleWebhook('dev-verification-secret', {
      referenceId: 'ref-1',
      approved: true,
      isAdult: true,
    });
    expect(result.verification_status).toBe(VerificationStatus.VERIFIED);
    expect(result.verified_at).toEqual(expect.any(Date));
    expect(mockPrisma.user.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.not.objectContaining({ dateOfBirth: expect.anything() }),
      }),
    );
  });

  it('fails underage results and blocks another start', async () => {
    mockPrisma.ageVerificationAttempt.findUnique.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-1',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'STUB',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
    });
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationProviderRef: 'ref-1',
      verificationStatus: VerificationStatus.PENDING,
    });

    const failed = await service.handleWebhook('dev-verification-secret', {
      referenceId: 'ref-1',
      approved: true,
      isAdult: false,
    });
    expect(failed.verification_status).toBe(VerificationStatus.FAILED);
    expect(failed.verification_failure_reason).toBe(
      VerificationFailureReason.UNDERAGE,
    );

    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.FAILED,
      verificationFailureReason: VerificationFailureReason.UNDERAGE,
    });
    await expect(service.start('user-1')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });

  it('rejects webhooks with the wrong secret', async () => {
    await expect(
      service.handleWebhook('nope', {
        referenceId: 'ref-1',
        approved: true,
        isAdult: true,
      }),
    ).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('ignores a replayed webhook that would downgrade a verified user', async () => {
    mockPrisma.ageVerificationAttempt.findUnique.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-1',
      status: VerificationStatus.VERIFIED,
      ageThreshold: 18,
      method: 'STUB',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: now,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
    });
    mockPrisma.ageVerificationNotification.findUnique.mockResolvedValue({
      id: 'stub:ref-1:FAIL',
    });
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.VERIFIED,
      verificationProviderRef: 'ref-1',
      verifiedAt: now,
      ageThreshold: 18,
    });

    const result = await service.handleWebhook('dev-verification-secret', {
      referenceId: 'ref-1',
      approved: true,
      isAdult: false,
    });
    expect(result.verification_status).toBe(VerificationStatus.VERIFIED);
  });

  it('blocks unverified users from participating', async () => {
    await expect(service.assertVerifiedAdult('user-1')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });

  it('checks eligibility without persisting a date of birth', () => {
    const eligible = service.checkEligibility({
      dateOfBirth: '1990-01-01',
    });
    expect(eligible).toEqual({ eligible: true, age_threshold: 18 });
    const tooYoung = service.checkEligibility({
      dateOfBirth: '2015-01-01',
    });
    expect(tooYoung.eligible).toBe(false);
    expect(mockPrisma.user.update).not.toHaveBeenCalled();
  });

  it('marks expired open sessions', async () => {
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.PENDING,
      verificationProviderRef: 'ref-old',
    });
    mockPrisma.ageVerificationAttempt.findFirst.mockResolvedValue({
      id: 'attempt-old',
      userId: 'user-1',
      provider: 'stub',
      providerSessionId: 'ref-old',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'AGE_ESTIMATION',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2020-01-01T00:00:00Z'),
    });

    const result = await service.getStatus('user-1');
    expect(result.verification_status).toBe(VerificationStatus.FAILED);
    expect(result.verification_failure_reason).toBe(
      VerificationFailureReason.EXPIRED,
    );
  });
});

describe('VerificationService with Yoti provider', () => {
  let service: VerificationService;
  const now = new Date('2026-08-18T10:00:00Z');
  const mockPrisma = {
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    ageVerificationAttempt: {
      findFirst: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    ageVerificationNotification: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    $transaction: jest.fn((ops: Promise<unknown>[]) => Promise.all(ops)),
  };

  const createSession = jest.fn();
  const getSessionResult = jest.fn();
  const parseWebhook = jest.fn();
  const verifyWebhook = jest.fn();
  const yotiProvider: AgeVerificationProvider = {
    name: 'YOTI',
    createSession,
    getSessionResult,
    parseWebhook,
    verifyWebhook,
  };

  const user = {
    id: 'user-1',
    email: 'pat@example.com',
    name: 'Pat',
    role: 'USER',
    verificationStatus: VerificationStatus.UNVERIFIED,
    verificationProvider: null,
    verificationProviderRef: null,
    verifiedAt: null,
    verificationFailureReason: null,
    ageThreshold: null,
    createdAt: now,
    updatedAt: now,
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    process.env.NODE_ENV = 'test';
    process.env.MINIMUM_USER_AGE = '18';
    mockPrisma.ageVerificationAttempt.findFirst.mockResolvedValue(null);
    mockPrisma.user.findUnique.mockResolvedValue(user);
    mockPrisma.user.update.mockImplementation(({ data }) => ({
      ...user,
      ...data,
    }));
    mockPrisma.ageVerificationAttempt.create.mockImplementation(({ data }) => ({
      ...data,
      createdAt: now,
      updatedAt: now,
      failureReason: null,
      verifiedAt: null,
    }));
    mockPrisma.ageVerificationAttempt.update.mockImplementation(({ data }) => ({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'YOTI',
      providerSessionId: 'yoti-session',
      ageThreshold: 18,
      createdAt: now,
      updatedAt: now,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
      ...data,
    }));
    createSession.mockResolvedValue({
      providerSessionId: 'yoti-session',
      expiresAt: new Date('2026-08-18T10:15:00Z'),
      launchUrl:
        'https://age.yoti.com/age-estimation?sessionId=yoti-session&sdkId=sdk',
      documentLaunchUrl:
        'https://age.yoti.com/doc-scan?sessionId=yoti-session&sdkId=sdk',
    });
    verifyWebhook.mockReturnValue(true);
    parseWebhook.mockImplementation((body) => ({
      providerSessionId: body.session_key,
      notificationId: body.id,
      state: body.state,
      method: body.method,
    }));
    getSessionResult.mockResolvedValue({
      providerSessionId: 'yoti-session',
      status: 'COMPLETE',
      method: 'AGE_ESTIMATION',
      documentAvailable: false,
    });

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VerificationService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AGE_VERIFICATION_PROVIDER, useValue: yotiProvider },
      ],
    }).compile();
    service = module.get(VerificationService);
  });

  it('creates a Yoti session and returns the hosted user-view URL', async () => {
    const result = await service.start('user-1');
    expect(result.provider).toBe('YOTI');
    expect(result.launch_url).toContain('age.yoti.com');
    expect(result.stub).toBe(false);
    expect(createSession).toHaveBeenCalledWith(
      expect.objectContaining({
        minimumAge: 18,
        estimationThreshold: 21,
      }),
    );
  });

  it('rejects unsigned Yoti webhooks', async () => {
    verifyWebhook.mockReturnValue(false);
    await expect(
      service.handleWebhook(undefined, {
        session_key: 'yoti-session',
        signature: 'nope',
        id: 'n1',
        state: 'COMPLETE',
      }),
    ).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('applies a signed Yoti success webhook using the canonical session result', async () => {
    mockPrisma.ageVerificationAttempt.findUnique.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'YOTI',
      providerSessionId: 'yoti-session',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'AGE_ESTIMATION',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2026-08-18T10:15:00Z'),
    });
    mockPrisma.ageVerificationNotification.findUnique.mockResolvedValue(null);
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.PENDING,
      verificationProviderRef: 'yoti-session',
    });

    const result = await service.handleWebhook(undefined, {
      session_key: 'yoti-session',
      signature: 'valid',
      id: 'note-1',
      state: 'COMPLETE',
      method: 'AGE_ESTIMATION',
    });
    expect(getSessionResult).toHaveBeenCalledWith('yoti-session');
    expect(result.verification_status).toBe(VerificationStatus.VERIFIED);
  });

  it('does not let refresh mark a different user verified', async () => {
    mockPrisma.ageVerificationAttempt.findFirst.mockResolvedValue({
      id: 'attempt-1',
      userId: 'user-1',
      provider: 'YOTI',
      providerSessionId: 'yoti-session',
      status: VerificationStatus.PENDING,
      ageThreshold: 18,
      method: 'AGE_ESTIMATION',
      failureReason: null,
      createdAt: now,
      updatedAt: now,
      verifiedAt: null,
      expiresAt: new Date('2099-01-01T00:00:00Z'),
    });
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationStatus: VerificationStatus.PENDING,
      verificationProviderRef: 'yoti-session',
    });

    await service.refresh('user-1');
    expect(mockPrisma.user.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id: 'user-1' } }),
    );
  });
});
