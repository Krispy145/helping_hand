/* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-return */
import { ForbiddenException, UnauthorizedException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { VerificationFailureReason, VerificationStatus } from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { VerificationService } from './verification.service';

describe('VerificationService', () => {
  let service: VerificationService;

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
    createdAt: new Date('2026-08-18T10:00:00Z'),
    updatedAt: new Date('2026-08-18T10:00:00Z'),
  };

  const mockPrisma = {
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    process.env.NODE_ENV = 'test';
    delete process.env.VERIFICATION_STUB;
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VerificationService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();
    service = module.get(VerificationService);
  });

  it('starts a stub verification and stores a provider reference', async () => {
    mockPrisma.user.findUnique.mockResolvedValue(user);
    mockPrisma.user.update.mockImplementation(({ data }) => ({
      ...user,
      ...data,
    }));

    const result = await service.start('user-1');
    expect(result.verification_status).toBe(VerificationStatus.PENDING);
    expect(result.provider).toBe('stub');
    expect(result.stub).toBe(true);
    expect(result.reference_id).toEqual(expect.any(String));
  });

  it('marks a provider-approved adult as verified without storing a date of birth', async () => {
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationProviderRef: 'ref-1',
      verificationStatus: VerificationStatus.PENDING,
    });
    mockPrisma.user.update.mockImplementation(({ data }) => ({
      ...user,
      verificationProviderRef: 'ref-1',
      ...data,
    }));

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
    mockPrisma.user.findUnique.mockResolvedValue({
      ...user,
      verificationProviderRef: 'ref-1',
      verificationStatus: VerificationStatus.PENDING,
    });
    mockPrisma.user.update.mockImplementation(({ data }) => ({
      ...user,
      verificationProviderRef: 'ref-1',
      ...data,
    }));

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

  it('blocks unverified users from participating', async () => {
    mockPrisma.user.findUnique.mockResolvedValue(user);
    await expect(service.assertVerifiedAdult('user-1')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });
});
