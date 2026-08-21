import { INestApplication } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { JwtStrategy } from '../auth/jwt.strategy';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { AGE_VERIFICATION_PROVIDER } from './providers/age-verification.provider';
import { StubAgeVerificationProvider } from './providers/stub-age-verification.provider';
import { VerifiedAdultGuard } from './verified-adult.guard';
import { VerificationController } from './verification.controller';
import { VerificationService } from './verification.service';

describe('Verification HTTP', () => {
  let app: INestApplication<App>;

  const prisma = {
    user: {
      findUnique: jest.fn().mockResolvedValue(null),
      update: jest.fn(),
    },
    ageVerificationAttempt: {
      findFirst: jest.fn().mockResolvedValue(null),
      findUnique: jest.fn().mockResolvedValue(null),
      create: jest.fn(),
      update: jest.fn(),
    },
    ageVerificationNotification: {
      findUnique: jest.fn().mockResolvedValue(null),
      create: jest.fn(),
    },
    $transaction: jest.fn((ops: Promise<unknown>[]) => Promise.all(ops)),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    process.env.NODE_ENV = 'test';
    delete process.env.YOTI_SDK_ID;
    delete process.env.YOTI_API_KEY;

    const module: TestingModule = await Test.createTestingModule({
      imports: [
        PassportModule.register({ defaultStrategy: 'jwt' }),
        JwtModule.register({
          secret: process.env.JWT_SECRET || 'dev_secret_key',
          signOptions: { expiresIn: '1h' },
        }),
      ],
      controllers: [VerificationController],
      providers: [
        VerificationService,
        VerifiedAdultGuard,
        JwtStrategy,
        {
          provide: AGE_VERIFICATION_PROVIDER,
          useClass: StubAgeVerificationProvider,
        },
        { provide: PrismaService, useValue: prisma },
      ],
    }).compile();

    app = module.createNestApplication();
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  it('rejects unauthenticated session creation', async () => {
    await request(app.getHttpServer()).post('/verification/start').expect(401);
  });

  it('rejects unauthenticated status reads', async () => {
    await request(app.getHttpServer()).get('/verification/status').expect(401);
  });

  it('rejects an invalid stub webhook', async () => {
    await request(app.getHttpServer())
      .post('/verification/webhook')
      .set('x-webhook-secret', 'wrong')
      .send({ referenceId: 'ref-1', approved: true, isAdult: true })
      .expect(401);
  });
});
