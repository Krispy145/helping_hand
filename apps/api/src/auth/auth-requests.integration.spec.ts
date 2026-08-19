/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { ForbiddenException, INestApplication } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { Test, TestingModule } from '@nestjs/testing';
import * as bcrypt from 'bcrypt';
import request from 'supertest';
import { App } from 'supertest/types';
import { User, UserRole } from '../domain/entities/user.entity';
import { RequestsController } from '../requests/requests.controller';
import { RequestsService } from '../requests/requests.service';
import { VerificationService } from '../verification/verification.service';
import { VerifiedAdultGuard } from '../verification/verified-adult.guard';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtStrategy } from './jwt.strategy';

describe('Auth + Requests HTTP', () => {
  let app: INestApplication<App>;
  const users = new Map<string, User>();

  const userRepo = {
    create: jest.fn((user: User) => {
      const created = new User({
        ...user,
        id: `user-${users.size + 1}`,
        createdAt: new Date('2026-08-19T08:00:00Z'),
        updatedAt: new Date('2026-08-19T08:00:00Z'),
      });
      users.set(created.id, created);
      return Promise.resolve(created);
    }),
    findAll: jest.fn(),
    findById: jest.fn((id: string) => Promise.resolve(users.get(id) ?? null)),
    findByEmail: jest.fn((email: string) =>
      Promise.resolve(
        [...users.values()].find((user) => user.email === email) ?? null,
      ),
    ),
    update: jest.fn(),
    delete: jest.fn(),
  };

  const requestsService = {
    create: jest.fn(),
    findAll: jest.fn(),
    appeal: jest.fn(),
    findAllNearby: jest.fn(),
    findAllInBounds: jest.fn(),
  };

  const verification = {
    assertVerifiedAdult: jest.fn(),
  };

  beforeEach(async () => {
    users.clear();
    jest.clearAllMocks();
    verification.assertVerifiedAdult.mockResolvedValue({});
    requestsService.create.mockResolvedValue({
      id: 'req-1',
      title: 'Need groceries',
      status: 'APPROVED',
      lat: -33.924,
      lng: 18.424,
    });
    requestsService.findAllNearby.mockResolvedValue([
      {
        id: 'req-1',
        title: 'Need groceries',
        lat: -33.924,
        lng: 18.424,
      },
    ]);
    requestsService.findAllInBounds.mockResolvedValue([
      {
        id: 'req-1',
        title: 'Need groceries',
        lat: -33.924,
        lng: 18.424,
      },
    ]);

    const hashed = await bcrypt.hash('password123', 10);
    users.set(
      'user-seed',
      new User({
        id: 'user-seed',
        email: 'pat@example.com',
        password: hashed,
        name: 'Pat',
        role: UserRole.USER,
        createdAt: new Date('2026-08-19T08:00:00Z'),
        updatedAt: new Date('2026-08-19T08:00:00Z'),
      }),
    );

    const module: TestingModule = await Test.createTestingModule({
      imports: [
        PassportModule.register({ defaultStrategy: 'jwt' }),
        JwtModule.register({
          secret: process.env.JWT_SECRET || 'dev_secret_key',
          signOptions: { expiresIn: '1h' },
        }),
      ],
      controllers: [AuthController, RequestsController],
      providers: [
        AuthService,
        JwtStrategy,
        VerifiedAdultGuard,
        { provide: 'IUserRepository', useValue: userRepo },
        { provide: RequestsService, useValue: requestsService },
        { provide: VerificationService, useValue: verification },
      ],
    }).compile();

    app = module.createNestApplication();
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  async function loginToken() {
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'pat@example.com', password: 'password123' })
      .expect(201);
    return response.body.access_token as string;
  }

  it('returns a JWT on login', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'pat@example.com', password: 'password123' })
      .expect(201);

    expect(response.body.access_token).toEqual(expect.any(String));
    expect(response.body.user.email).toBe('pat@example.com');
  });

  it('rejects invalid credentials', async () => {
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'pat@example.com', password: 'nope' })
      .expect(401);
  });

  it('rejects registering an email that already exists', async () => {
    await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: 'pat@example.com',
        password: 'password123',
        name: 'Pat',
      })
      .expect(409);
  });

  it('refuses to create a request without a token', async () => {
    await request(app.getHttpServer())
      .post('/requests')
      .send({
        title: 'Need groceries',
        description: 'A few essentials.',
        urgency: 'MEDIUM',
        lat: -33.9249,
        lng: 18.4241,
      })
      .expect(401);
    expect(requestsService.create).not.toHaveBeenCalled();
  });

  it('creates a request for a verified adult', async () => {
    const token = await loginToken();
    const response = await request(app.getHttpServer())
      .post('/requests')
      .set('Authorization', `Bearer ${token}`)
      .send({
        title: 'Need groceries',
        description: 'A few essentials.',
        urgency: 'MEDIUM',
        lat: -33.9249,
        lng: 18.4241,
      })
      .expect(201);

    expect(verification.assertVerifiedAdult).toHaveBeenCalledWith('user-seed');
    expect(requestsService.create).toHaveBeenCalledWith(
      'user-seed',
      expect.objectContaining({ title: 'Need groceries' }),
    );
    expect(response.body.lat).toBe(-33.924);
    expect(response.body.lng).toBe(18.424);
  });

  it('blocks request creation when the adult gate fails', async () => {
    verification.assertVerifiedAdult.mockRejectedValue(
      new ForbiddenException(
        'Verify your identity before requesting or offering help.',
      ),
    );
    const token = await loginToken();
    await request(app.getHttpServer())
      .post('/requests')
      .set('Authorization', `Bearer ${token}`)
      .send({
        title: 'Need groceries',
        description: 'A few essentials.',
        urgency: 'MEDIUM',
        lat: -33.9249,
        lng: 18.4241,
      })
      .expect(403);
    expect(requestsService.create).not.toHaveBeenCalled();
  });

  it('returns public nearby coordinates for an authorized helper', async () => {
    const token = await loginToken();
    const response = await request(app.getHttpServer())
      .get('/requests/nearby')
      .query({ lat: -33.9249, lng: 18.4241, radius: 10 })
      .set('Authorization', `Bearer ${token}`)
      .expect(200);

    expect(requestsService.findAllNearby).toHaveBeenCalledWith(
      -33.9249,
      18.4241,
      10,
    );
    expect(response.body[0].lat).toBe(-33.924);
    expect(response.body[0].lng).toBe(18.424);
  });
});
