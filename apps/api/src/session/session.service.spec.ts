/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { ForbiddenException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { SessionStatus } from '@prisma/client';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { SessionService } from './session.service';

describe('SessionService push', () => {
  let service: SessionService;
  const mockPrisma = {
    session: { findUnique: jest.fn(), update: jest.fn(), delete: jest.fn() },
    message: { create: jest.fn(), findMany: jest.fn(), deleteMany: jest.fn() },
    request: { findUnique: jest.fn(), update: jest.fn() },
    $transaction: jest.fn(),
    $queryRaw: jest.fn(),
  };
  const mockNotifications = {
    notifyUser: jest.fn().mockResolvedValue(undefined),
  };

  const session = {
    id: 'session-1',
    requestId: 'req-1',
    helperId: 'helper-1',
    status: SessionStatus.ACTIVE,
    request: {
      userId: 'helpee-1',
      title: 'Need groceries',
      description: 'A few essentials.',
      category: null,
      urgency: 'MEDIUM',
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    mockPrisma.$transaction.mockImplementation(
      async (fn: (tx: typeof mockPrisma) => Promise<unknown>) => fn(mockPrisma),
    );
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: NotificationsService, useValue: mockNotifications },
      ],
    }).compile();
    service = module.get(SessionService);
  });

  it('alerts the other person when a message is saved, without the body', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    mockPrisma.message.create.mockResolvedValue({
      id: 'msg-1',
      sessionId: 'session-1',
      senderId: 'helper-1',
      content: 'I can help this afternoon. Call me 0821234567',
    });

    await service.saveMessage(
      'session-1',
      'helper-1',
      'I can help this afternoon. Call me 0821234567',
    );

    expect(mockNotifications.notifyUser).toHaveBeenCalledWith(
      'helpee-1',
      'new_message',
      { sessionId: 'session-1', requestId: 'req-1' },
    );
    const payload = mockNotifications.notifyUser.mock.calls[0];
    expect(JSON.stringify(payload)).not.toContain('0821234567');
  });

  it('alerts the other person when an assist is completed', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    mockPrisma.session.findUnique
      .mockResolvedValueOnce(session)
      .mockResolvedValueOnce({
        ...session,
        status: SessionStatus.COMPLETED,
        request: { ...session.request, user: { id: 'helpee-1', name: 'Pat' } },
        helper: { id: 'helper-1', name: 'Alex' },
      });

    await service.completeAssist('session-1', 'helper-1');
    expect(mockNotifications.notifyUser).toHaveBeenCalledWith(
      'helpee-1',
      'assist_completed',
      { sessionId: 'session-1', requestId: 'req-1' },
    );
  });

  it('alerts the other person when an assist ends', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    await service.cancelAssist('session-1', 'helpee-1');
    expect(mockNotifications.notifyUser).toHaveBeenCalledWith(
      'helper-1',
      'assist_ended',
      { sessionId: 'session-1', requestId: 'req-1' },
    );
  });

  it('does not notify a stranger', async () => {
    mockPrisma.session.findUnique.mockResolvedValue(session);
    await expect(
      service.saveMessage('session-1', 'stranger', 'hello'),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(mockNotifications.notifyUser).not.toHaveBeenCalled();
  });
});
