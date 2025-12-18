import { Test, TestingModule } from '@nestjs/testing';
import { VettingService } from './vetting.service';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestStatus } from '@prisma/client';

describe('VettingService', () => {
  let service: VettingService;
  let prisma: PrismaService;

  const mockPrismaService = {
    request: {
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VettingService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<VettingService>(VettingService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should approve valid content', async () => {
    const validText = 'I need help with groceries';
    await service.vetRequest('req-1', validText);

    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-1' },
      data: { status: RequestStatus.APPROVED },
    });
  });

  it('should reject content with restricted keywords', async () => {
    const invalidText = 'This is a crypto scam';
    await service.vetRequest('req-2', invalidText);

    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-2' },
      data: { status: RequestStatus.REJECTED },
    });
  });

  it('should be case insensitive', async () => {
    const invalidText = 'Free MONEY now';
    await service.vetRequest('req-3', invalidText);

    expect(prisma.request.update).toHaveBeenCalledWith({
      where: { id: 'req-3' },
      data: { status: RequestStatus.REJECTED },
    });
  });
});
