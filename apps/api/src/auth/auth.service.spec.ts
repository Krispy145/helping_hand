/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { ConflictException } from '@nestjs/common';
import { JwtModule, JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import * as bcrypt from 'bcrypt';
import { User, UserRole } from '../domain/entities/user.entity';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: JwtService;

  const mockRepo = {
    create: jest.fn(),
    findAll: jest.fn(),
    findById: jest.fn(),
    findByEmail: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
  };

  const now = new Date('2026-08-19T08:00:00Z');

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      imports: [
        JwtModule.register({
          secret: process.env.JWT_SECRET || 'dev_secret_key',
        }),
      ],
      providers: [
        AuthService,
        { provide: 'IUserRepository', useValue: mockRepo },
      ],
    }).compile();

    service = module.get(AuthService);
    jwtService = module.get(JwtService);
  });

  it('hashes the password before storing a new user and returns a JWT', async () => {
    mockRepo.findByEmail.mockResolvedValue(null);
    mockRepo.create.mockImplementation((user: User) =>
      Promise.resolve(
        new User({
          ...user,
          id: 'user-1',
          createdAt: now,
          updatedAt: now,
        }),
      ),
    );

    const result = await service.register({
      email: 'pat@example.com',
      password: 'password123',
      name: 'Pat',
    });

    const stored = mockRepo.create.mock.calls[0][0] as User;
    expect(stored.password).toBeDefined();
    expect(stored.password).not.toBe('password123');
    await expect(bcrypt.compare('password123', stored.password!)).resolves.toBe(
      true,
    );
    expect(result.access_token.split('.')).toHaveLength(3);
    expect(result.user.email).toBe('pat@example.com');
    expect(result.user).not.toHaveProperty('password');

    const payload = await jwtService.verifyAsync<{ sub: string }>(
      result.access_token,
    );
    expect(payload.sub).toBe('user-1');
  });

  it('rejects a duplicate email', async () => {
    mockRepo.findByEmail.mockResolvedValue(
      new User({ id: 'user-1', email: 'pat@example.com', role: UserRole.USER }),
    );

    await expect(
      service.register({
        email: 'pat@example.com',
        password: 'password123',
        name: 'Pat',
      }),
    ).rejects.toBeInstanceOf(ConflictException);
    expect(mockRepo.create).not.toHaveBeenCalled();
  });

  it('returns a token when login credentials match', async () => {
    const hashed = await bcrypt.hash('password123', 10);
    mockRepo.findByEmail.mockResolvedValue(
      new User({
        id: 'user-1',
        email: 'pat@example.com',
        password: hashed,
        name: 'Pat',
        role: UserRole.USER,
        createdAt: now,
        updatedAt: now,
      }),
    );

    const user = await service.validateUser('pat@example.com', 'password123');
    expect(user?.id).toBe('user-1');
    expect(user).not.toHaveProperty('password');

    const result = await service.login(user!);
    expect(result.access_token.split('.')).toHaveLength(3);
    expect(result.user.email).toBe('pat@example.com');
  });

  it('returns null for a wrong password', async () => {
    const hashed = await bcrypt.hash('password123', 10);
    mockRepo.findByEmail.mockResolvedValue(
      new User({
        id: 'user-1',
        email: 'pat@example.com',
        password: hashed,
        role: UserRole.USER,
      }),
    );

    await expect(
      service.validateUser('pat@example.com', 'wrong'),
    ).resolves.toBeNull();
  });
});
