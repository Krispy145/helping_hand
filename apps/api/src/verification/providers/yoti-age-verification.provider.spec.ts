import { ServiceUnavailableException } from '@nestjs/common';
import { loadVerificationConfig } from '../verification.config';
import { YotiAgeVerificationProvider } from './yoti-age-verification.provider';

describe('YotiAgeVerificationProvider', () => {
  const originalFetch = global.fetch;

  const config = loadVerificationConfig({
    ...process.env,
    YOTI_SDK_ID: 'sdk-id',
    YOTI_API_KEY: 'api-key',
    YOTI_API_BASE_URL: 'https://age.yoti.com/api/v1',
    YOTI_USER_VIEW_BASE_URL: 'https://age.yoti.com',
    MINIMUM_USER_AGE: '18',
    YOTI_AGE_ESTIMATION_THRESHOLD: '21',
  });

  const provider = new YotiAgeVerificationProvider(config);

  afterEach(() => {
    global.fetch = originalFetch;
    jest.resetAllMocks();
  });

  it('creates an OVER session and returns method-specific launch URLs', async () => {
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () =>
        Promise.resolve({
          id: 'session-1',
          expires_at: '2026-08-18T10:15:00Z',
          status: 'PENDING',
        }),
    }) as unknown as typeof fetch;

    const created = await provider.createSession({
      referenceId: 'attempt-1',
      ttlSeconds: 900,
      minimumAge: 18,
      estimationThreshold: 21,
      callbackUrl: 'helpinghand://verification/callback',
      cancelUrl: 'helpinghand://verification/cancel',
      notificationUrl: 'https://api.example.com/verification/webhook',
    });

    expect(created.providerSessionId).toBe('session-1');
    expect(created.launchUrl).toContain('/age-estimation');
    expect(created.launchUrl).toContain('sessionId=session-1');
    expect(created.documentLaunchUrl).toContain('/doc-scan');

    const [, request] = (global.fetch as jest.Mock).mock.calls[0] as [
      string,
      RequestInit,
    ];
    expect(request.headers).toEqual(
      expect.objectContaining({
        Authorization: 'Bearer api-key',
        'Yoti-SDK-Id': 'sdk-id',
      }),
    );
    expect(typeof request.body).toBe('string');
    const body = JSON.parse(request.body as string) as Record<string, unknown>;
    expect(body.type).toBe('OVER');
    expect(body.age_estimation).toEqual(
      expect.objectContaining({
        allowed: true,
        threshold: 21,
        level: 'PASSIVE',
      }),
    );
    expect(body.doc_scan).toEqual(
      expect.objectContaining({ allowed: true, threshold: 18 }),
    );
    expect(body).not.toHaveProperty('age');
  });

  it('maps session results without exposing an estimated age', async () => {
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () =>
        Promise.resolve({
          id: 'session-1',
          status: 'COMPLETE',
          method: 'AGE_ESTIMATION',
          age: 24,
          doc_scan: { allowed: true, attempts_remaining: 1 },
        }),
    }) as unknown as typeof fetch;

    const result = await provider.getSessionResult('session-1');
    expect(result).toEqual({
      providerSessionId: 'session-1',
      status: 'COMPLETE',
      method: 'AGE_ESTIMATION',
      documentAvailable: true,
    });
    expect(result).not.toHaveProperty('age');
  });

  it('throws when Yoti is unavailable', async () => {
    global.fetch = jest.fn().mockResolvedValue({
      ok: false,
      status: 503,
    }) as unknown as typeof fetch;

    await expect(
      provider.createSession({
        referenceId: 'attempt-1',
        ttlSeconds: 900,
        minimumAge: 18,
        estimationThreshold: 21,
        callbackUrl: 'https://example.com/callback',
        cancelUrl: 'https://example.com/cancel',
        notificationUrl: null,
      }),
    ).rejects.toBeInstanceOf(ServiceUnavailableException);
  });
});
