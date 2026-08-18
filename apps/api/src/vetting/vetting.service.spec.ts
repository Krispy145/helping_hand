/* eslint-disable @typescript-eslint/unbound-method, @typescript-eslint/no-unsafe-assignment */
import { Test, TestingModule } from '@nestjs/testing';
import { VettingService } from './vetting.service';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestStatus, SafetyIncidentSource } from '@prisma/client';
import {
  StubContentRiskClassifier,
  StubIntentAnalyzer,
} from './vetting-providers';

describe('VettingService', () => {
  let service: VettingService;
  let prisma: PrismaService;

  const mockPrismaService = {
    request: {
      update: jest.fn(),
      findUnique: jest.fn(),
    },
    safetyIncident: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VettingService,
        { provide: PrismaService, useValue: mockPrismaService },
        {
          provide: 'ContentRiskClassifier',
          useClass: StubContentRiskClassifier,
        },
        { provide: 'IntentAnalyzer', useClass: StubIntentAnalyzer },
      ],
    }).compile();

    service = module.get<VettingService>(VettingService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should approve valid content', async () => {
    const validText = 'I need help with groceries';
    const result = await service.vetRequest('req-1', validText);

    expect(result.status).toBe(RequestStatus.APPROVED);
    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-1' },
      data: { status: RequestStatus.APPROVED },
    });
    expect(prisma.safetyIncident.create).not.toHaveBeenCalled();
  });

  it('should reject content with restricted keywords and persist triggered_rule', async () => {
    const invalidText = 'This is a crypto scam';
    mockPrismaService.request.findUnique.mockResolvedValue({
      userId: 'user-1',
    });
    const result = await service.vetRequest('req-2', invalidText);

    expect(result.status).toBe(RequestStatus.REJECTED);
    expect(result.triggeredRule).toContain('Restricted keyword');
    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-2' },
      data: { status: RequestStatus.REJECTED },
    });
    expect(prisma.safetyIncident.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        userId: 'user-1',
        reasonCode: 'RESTRICTED_CONTENT',
        triggeredRule: expect.stringContaining('Restricted keyword'),
        requestId: 'req-2',
        source: SafetyIncidentSource.REQUEST_VETTING,
      }),
    });
  });

  it('should be case insensitive', async () => {
    const invalidText = 'Free MONEY now';
    mockPrismaService.request.findUnique.mockResolvedValue({
      userId: 'user-1',
    });
    await service.vetRequest('req-3', invalidText);

    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-3' },
      data: { status: RequestStatus.REJECTED },
    });
  });

  it('rejects phone numbers as PII', async () => {
    mockPrismaService.request.findUnique.mockResolvedValue({
      userId: 'user-1',
    });
    const result = await service.vetRequest(
      'req-4',
      'Call me on 082 123 4567 after you arrive',
    );
    expect(result.reasonCode).toBe('PII_LEAK');
    expect(result.userMessage).toMatch(/phone numbers/i);
  });

  it('rejects crisis text and returns helplines', async () => {
    mockPrismaService.request.findUnique.mockResolvedValue({
      userId: 'user-1',
    });
    const result = await service.vetRequest(
      'req-5',
      'I want to die and need someone to sit with me',
    );
    expect(result.reasonCode).toBe('CRISIS_SELF_HARM');
    expect(result.showHelplines).toBe(true);
    expect(result.helplines.length).toBeGreaterThan(0);
  });
});
