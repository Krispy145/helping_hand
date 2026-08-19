/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { NotificationsService } from './notifications.service';

describe('NotificationsService', () => {
  let service: NotificationsService;
  const mockPrisma = {
    deviceToken: {
      upsert: jest.fn(),
      deleteMany: jest.fn(),
      findMany: jest.fn(),
    },
  };
  const mockPush = {
    send: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationsService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: 'INotificationService', useValue: mockPush },
      ],
    }).compile();
    service = module.get(NotificationsService);
  });

  it('stores a device token against the signed-in user', async () => {
    mockPrisma.deviceToken.upsert.mockResolvedValue({});
    await service.registerDevice('user-1', ' token-abc ', 'ios');
    expect(mockPrisma.deviceToken.upsert).toHaveBeenCalledWith({
      where: { token: 'token-abc' },
      update: { userId: 'user-1', platform: 'ios' },
      create: { userId: 'user-1', token: 'token-abc', platform: 'ios' },
    });
  });

  it('sends a session alert without including chat text', async () => {
    mockPrisma.deviceToken.findMany.mockResolvedValue([{ token: 't1' }]);
    mockPush.send.mockResolvedValue(undefined);

    await service.notifyUser('user-1', 'new_message', {
      sessionId: 'session-1',
      requestId: 'req-1',
    });

    expect(mockPush.send).toHaveBeenCalledWith(
      ['t1'],
      'New message',
      'You have a new message in your conversation.',
      {
        type: 'new_message',
        sessionId: 'session-1',
        requestId: 'req-1',
      },
    );
    const body = mockPush.send.mock.calls[0][2] as string;
    expect(body).not.toMatch(/hi|hello|phone|money/i);
  });

  it('skips send when the user has no devices', async () => {
    mockPrisma.deviceToken.findMany.mockResolvedValue([]);
    await service.notifyUser('user-1', 'help_offered', {
      sessionId: 'session-1',
    });
    expect(mockPush.send).not.toHaveBeenCalled();
  });
});
