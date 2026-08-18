/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { Test, TestingModule } from '@nestjs/testing';
import {
  AppealStatus,
  ReportType,
  RequestStatus,
  SafetyIncidentSource,
  SessionStatus,
} from '@prisma/client';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { PulseService } from './pulse.service';

describe('PulseService', () => {
  let service: PulseService;

  const mockPrisma = {
    session: { count: jest.fn() },
    request: { count: jest.fn(), update: jest.fn() },
    report: { count: jest.fn() },
    safetyIncident: { count: jest.fn() },
    appeal: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    $transaction: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PulseService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();
    service = module.get(PulseService);
  });

  it('hides totals below the re-identification threshold', async () => {
    mockPrisma.session.count.mockResolvedValue(2);
    mockPrisma.request.count.mockResolvedValue(4);
    mockPrisma.report.count.mockResolvedValue(1);
    mockPrisma.safetyIncident.count.mockResolvedValue(0);

    const summary = await service.summary();

    expect(summary.sessions_completed).toBe(0);
    expect(summary.requests_helped).toBe(0);
    expect(summary.reports_filed).toBe(0);
    expect(summary.min_count).toBe(5);
    expect(mockPrisma.report.count).toHaveBeenCalledWith({
      where: {
        type: {
          in: [ReportType.SCAM, ReportType.THEFT, ReportType.UNSAFE_SITUATION],
        },
      },
    });
    expect(mockPrisma.session.count).toHaveBeenCalledWith({
      where: { status: SessionStatus.COMPLETED },
    });
  });

  it('returns open appeals without requester identity', async () => {
    mockPrisma.appeal.findMany.mockResolvedValue([
      {
        id: 'appeal-1',
        status: AppealStatus.OPEN,
        reason: 'This was a grocery run',
        createdAt: new Date('2026-08-18T10:00:00Z'),
        request: {
          id: 'req-1',
          title: 'Need groceries',
          description: 'A few essentials.',
          category: 'groceries',
          status: RequestStatus.REJECTED,
          urgency: 'MEDIUM',
          approxLat: -33.92,
          approxLng: 18.42,
          createdAt: new Date('2026-08-18T09:00:00Z'),
          updatedAt: new Date('2026-08-18T09:00:00Z'),
          incidents: [
            {
              reasonCode: 'RESTRICTED_CONTENT',
              triggeredRule: 'Stage 1: Restricted keyword (money)',
            },
          ],
        },
      },
    ]);

    const queue = await service.listQueue();

    expect(queue).toHaveLength(1);
    expect(queue[0]).toEqual(
      expect.objectContaining({
        appeal_id: 'appeal-1',
        reason_code: 'RESTRICTED_CONTENT',
        triggered_rule: 'Stage 1: Restricted keyword (money)',
      }),
    );
    expect(queue[0].request.user).toBeUndefined();
    expect(mockPrisma.appeal.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { status: AppealStatus.OPEN },
        include: expect.objectContaining({
          request: expect.objectContaining({
            include: expect.objectContaining({
              incidents: expect.objectContaining({
                where: { source: SafetyIncidentSource.REQUEST_VETTING },
              }),
            }),
          }),
        }),
      }),
    );
  });

  it('overturns an open appeal and approves the request', async () => {
    mockPrisma.appeal.findUnique.mockResolvedValue({
      id: 'appeal-1',
      requestId: 'req-1',
      status: AppealStatus.OPEN,
    });
    mockPrisma.$transaction.mockImplementation(
      async (fn: (tx: typeof mockPrisma) => Promise<unknown>) => {
        const tx = {
          request: { update: jest.fn() },
          appeal: {
            update: jest.fn().mockResolvedValue({
              id: 'appeal-1',
              status: AppealStatus.OVERTURNED,
              request: {
                id: 'req-1',
                title: 'Need groceries',
                description: 'A few essentials.',
                category: 'groceries',
                status: RequestStatus.APPROVED,
                urgency: 'MEDIUM',
                approxLat: -33.92,
                approxLng: 18.42,
                createdAt: new Date(),
                updatedAt: new Date(),
              },
            }),
          },
        };
        const result = await fn(tx as never);
        expect(tx.request.update).toHaveBeenCalledWith({
          where: { id: 'req-1' },
          data: { status: RequestStatus.APPROVED },
        });
        return result;
      },
    );

    const result = await service.overturn('appeal-1', 'mod-1');
    expect(result.status).toBe(AppealStatus.OVERTURNED);
    expect(result.request.status).toBe(RequestStatus.APPROVED);
  });

  it('rejects a second review of the same appeal', async () => {
    mockPrisma.appeal.findUnique.mockResolvedValue({
      id: 'appeal-1',
      status: AppealStatus.UPHELD,
    });
    await expect(service.uphold('appeal-1', 'mod-1')).rejects.toBeInstanceOf(
      ConflictException,
    );
  });

  it('throws when the appeal is missing', async () => {
    mockPrisma.appeal.findUnique.mockResolvedValue(null);
    await expect(service.overturn('missing', 'mod-1')).rejects.toBeInstanceOf(
      NotFoundException,
    );
  });
});
