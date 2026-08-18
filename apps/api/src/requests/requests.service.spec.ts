/* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
} from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { RequestStatus, RequestUrgency, Prisma } from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { VettingService } from '../vetting/vetting.service';
import { RequestsService } from './requests.service';

describe('RequestsService', () => {
  let service: RequestsService;

  const mockPrisma = {
    request: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    appeal: {
      create: jest.fn(),
    },
    $queryRaw: jest.fn(),
  };

  const mockVetting = {
    vetRequest: jest.fn().mockResolvedValue({
      status: RequestStatus.APPROVED,
      triggeredRule: null,
      reasonCode: null,
      userMessage: null,
      showHelplines: false,
      helplines: [],
      confidenceScore: null,
    }),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    mockVetting.vetRequest.mockResolvedValue({
      status: RequestStatus.APPROVED,
      triggeredRule: null,
      reasonCode: null,
      userMessage: null,
      showHelplines: false,
      helplines: [],
      confidenceScore: null,
    });
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RequestsService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: VettingService, useValue: mockVetting },
      ],
    }).compile();

    service = module.get(RequestsService);
  });

  it('rejects create without a finite location', async () => {
    await expect(
      service.create('user-1', {
        title: 'Need groceries',
        description: 'A few essentials.',
        urgency: RequestUrgency.MEDIUM,
      } as never),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(mockPrisma.request.create).not.toHaveBeenCalled();
  });

  it('stores precise coords plus a geohash cell and returns only the cell center', async () => {
    const lat = -33.9249123;
    const lng = 18.4241456;
    const createdAt = new Date('2026-08-18T10:00:00Z');

    mockPrisma.request.create.mockImplementation(({ data }) => {
      expect(data.lat).toBe(lat);
      expect(data.lng).toBe(lng);
      expect(data.geoHashApprox).toHaveLength(6);
      expect(data.approxLat).not.toBe(lat);
      expect(data.approxLng).not.toBe(lng);
      return {
        id: 'req-1',
        title: data.title,
        description: data.description,
        category: data.category ?? null,
        status: data.status,
        urgency: data.urgency,
        lat: data.lat,
        lng: data.lng,
        geoHashApprox: data.geoHashApprox,
        approxLat: data.approxLat,
        approxLng: data.approxLng,
        createdAt,
        updatedAt: createdAt,
      };
    });
    mockPrisma.request.findUnique.mockImplementation(
      () => mockPrisma.request.create.mock.results[0]?.value,
    );

    const result = await service.create('user-1', {
      title: 'Need groceries',
      description: 'A few essentials.',
      urgency: RequestUrgency.MEDIUM,
      lat,
      lng,
    });

    expect(result.lat).not.toBe(lat);
    expect(result.lng).not.toBe(lng);
    expect(result.lat).toBe(
      mockPrisma.request.create.mock.calls[0][0].data.approxLat,
    );
    expect(result.lng).toBe(
      mockPrisma.request.create.mock.calls[0][0].data.approxLng,
    );
    expect(mockVetting.vetRequest).toHaveBeenCalled();
  });

  it('never persists phone numbers when creating a request', async () => {
    mockPrisma.request.create.mockImplementation(({ data }) => ({
      id: 'req-pii',
      ...data,
      category: data.category ?? null,
      createdAt: new Date(),
      updatedAt: new Date(),
    }));
    mockPrisma.request.findUnique.mockImplementation(
      () => mockPrisma.request.create.mock.results[0]?.value,
    );

    await service.create('user-1', {
      title: 'Call me',
      description: 'My number is 082 123 4567',
      urgency: RequestUrgency.MEDIUM,
      lat: -33.92,
      lng: 18.42,
    });

    expect(mockPrisma.request.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        title: '[details removed]',
        description: 'Contact details were removed after vetting.',
      }),
    });
    expect(mockVetting.vetRequest).toHaveBeenCalledWith(
      'req-pii',
      'Call me My number is 082 123 4567',
    );
  });

  it('queries map bounds against approx coordinates', async () => {
    mockPrisma.request.findMany.mockResolvedValue([]);

    await service.findAllInBounds(-34, 18, -33, 19);

    expect(mockPrisma.request.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          status: { in: [RequestStatus.APPROVED, RequestStatus.IN_PROGRESS] },
          approxLat: { gte: -34, lte: -33 },
          approxLng: { gte: 18, lte: 19 },
        }),
      }),
    );
  });

  it('lists only approved and in-progress requests', async () => {
    mockPrisma.request.findMany.mockResolvedValue([]);

    await service.findAll();

    expect(mockPrisma.request.findMany).toHaveBeenCalledWith({
      where: {
        status: { in: [RequestStatus.APPROVED, RequestStatus.IN_PROGRESS] },
      },
      orderBy: { createdAt: 'desc' },
    });
  });

  it('lets the owner appeal a rejected request once', async () => {
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'user-1',
      status: RequestStatus.REJECTED,
      title: 'Need groceries',
      description: 'A few essentials.',
      category: 'groceries',
      urgency: RequestUrgency.MEDIUM,
      approxLat: -33.92,
      approxLng: 18.42,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
    mockPrisma.appeal.create.mockResolvedValue({
      id: 'appeal-1',
      status: 'OPEN',
    });

    const result = await service.appeal('user-1', 'req-1');

    expect(result.appeal_id).toBe('appeal-1');
    expect(mockPrisma.appeal.create).toHaveBeenCalledWith({
      data: {
        requestId: 'req-1',
        userId: 'user-1',
        reason: 'I believe this was blocked by mistake.',
      },
    });
  });

  it('blocks appeals from anyone except the requester', async () => {
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'user-1',
      status: RequestStatus.REJECTED,
    });

    await expect(service.appeal('user-2', 'req-1')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });

  it('blocks a second appeal', async () => {
    mockPrisma.request.findUnique.mockResolvedValue({
      id: 'req-1',
      userId: 'user-1',
      status: RequestStatus.REJECTED,
    });
    mockPrisma.appeal.create.mockRejectedValue(
      new Prisma.PrismaClientKnownRequestError('Unique constraint failed', {
        code: 'P2002',
        clientVersion: '6.0.0',
      }),
    );

    await expect(service.appeal('user-1', 'req-1')).rejects.toBeInstanceOf(
      ConflictException,
    );
  });
});
