import { loadVerificationConfig } from './verification.config';

describe('loadVerificationConfig', () => {
  it('defaults the minimum age to 18 and estimates above that threshold', () => {
    const config = loadVerificationConfig({
      NODE_ENV: 'test',
    } as NodeJS.ProcessEnv);
    expect(config.minimumUserAge).toBe(18);
    expect(config.ageEstimationThreshold).toBe(21);
  });

  it('keeps facial estimation at or above the legal minimum', () => {
    const config = loadVerificationConfig({
      MINIMUM_USER_AGE: '21',
      YOTI_AGE_ESTIMATION_THRESHOLD: '18',
    } as NodeJS.ProcessEnv);
    expect(config.minimumUserAge).toBe(21);
    expect(config.ageEstimationThreshold).toBe(24);
  });

  it('drops non-HTTPS notification URLs', () => {
    const config = loadVerificationConfig({
      YOTI_NOTIFICATION_URL: 'http://localhost:3000/verification/webhook',
    } as NodeJS.ProcessEnv);
    expect(config.notificationUrl).toBeNull();
  });
});
