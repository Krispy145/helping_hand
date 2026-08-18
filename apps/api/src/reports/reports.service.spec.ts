/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, ForbiddenException } from '@nestjs/common';
import {
  Prisma,
  ReportType,
  RequestStatus,
  SessionStatus,
} from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { ReportsService } from './reports.service';

describe('ReportsService', () => {
  let service: ReportsService;

  const session = {
    id: 'session-1',
    helperId: 'helper-1',
    requestId: 'req-1',
    status: SessionStatus.ACTIVE,
    request: { userId: 'helpee-1' },
    helper: { id: 'helper-1' },
  };

  const mockPrisma = {
    session: { findUnique: jest.fn() },
    request: { findUnique: jest.fn() },
    $transaction: jest.fn(),
    report: { findMany: jest.fn() },
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();
    service = module.get(ReportsService);
  });

  it('creates a report, incident on the target, and disputes the session', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'helpee-1',
    });
    const created = {
      id: 'report-1',
      reporterId: 'helpee-1',
      targetUserId: 'helper-1',
      sessionId: 'session-1',
      requestId: 'req-1',
      type: ReportType.HELPER_MISCONDUCT,
      severity: 'HIGH',
      description: 'They asked me for a bank transfer.',
      evidenceUrls: [],
      status: 'NEW',
      sessionEnded: true,
      createdAt: new Date('2026-08-18T10:00:00Z'),
    };
    mockPrisma.$transaction.mockImplementation(
      async (fn: (tx: Record<string, unknown>) => Promise<unknown>) => {
        const tx = {
          report: { create: jest.fn().mockResolvedValue(created) },
          safetyIncident: { create: jest.fn().mockResolvedValue({}) },
          session: { update: jest.fn() },
          request: { update: jest.fn() },
        };
        const result = await fn(tx);
        expect(tx.safetyIncident.create).toHaveBeenCalledWith(
          expect.objectContaining({
            data: expect.objectContaining({
              userId: 'helper-1',
              reasonCode: ReportType.HELPER_MISCONDUCT,
            }),
          }),
        );
        expect(tx.session.update).toHaveBeenCalledWith({
          where: { id: 'session-1' },
          data: { status: SessionStatus.DISPUTED },
        });
        expect(tx.request.update).toHaveBeenCalledWith({
          where: { id: 'req-1' },
          data: { status: RequestStatus.APPROVED },
        });
        return result;
      },
    );

    const result = await service.create('helpee-1', {
      type: ReportType.HELPER_MISCONDUCT,
      description: 'They asked me for a bank transfer.',
      sessionId: 'session-1',
    });

    expect(result.id).toBe('report-1');
    expect(result.penalizes_reporter).toBe(false);
  });

  it('does not put a SafetyIncident on the victim for a scam report without a named target from the victim themselves', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(null);
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'helpee-1',
    });
    mockPrisma.$transaction.mockImplementation(
      async (fn: (tx: Record<string, unknown>) => Promise<unknown>) => {
        const tx = {
          report: {
            create: jest.fn().mockResolvedValue({
              id: 'report-2',
              reporterId: 'helpee-1',
              targetUserId: null,
              sessionId: null,
              requestId: 'req-1',
              type: ReportType.SCAM,
              severity: 'HIGH',
              description: 'Someone tried to scam me after we met.',
              evidenceUrls: [],
              status: 'NEW',
              sessionEnded: false,
              createdAt: new Date(),
            }),
          },
          safetyIncident: { create: jest.fn() },
          session: { update: jest.fn() },
          request: { update: jest.fn() },
        };
        const result = await fn(tx);
        expect(tx.safetyIncident.create).not.toHaveBeenCalled();
        return result;
      },
    );

    const result = await service.create('helpee-1', {
      type: ReportType.SCAM,
      description: 'Someone tried to scam me after we met.',
      requestId: 'req-1',
      targetUserId: undefined,
    });
    expect(result.penalizes_reporter).toBe(false);
  });

  it('rejects reporting a chat you are not in', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    await expect(
      service.create('stranger-1', {
        type: ReportType.UNSAFE_SITUATION,
        description: 'This felt unsafe to me in that chat.',
        sessionId: 'session-1',
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });

  it('maps unique violations to a conflict', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'helpee-1',
    });
    mockPrisma.$transaction.mockRejectedValue(
      new Prisma.PrismaClientKnownRequestError('dup', {
        code: 'P2002',
        clientVersion: '6.0.0',
      }),
    );
    await expect(
      service.create('helpee-1', {
        type: ReportType.HELPER_MISCONDUCT,
        description: 'They asked me for a bank transfer.',
        sessionId: 'session-1',
      }),
    ).rejects.toBeInstanceOf(ConflictException);
  });
});
