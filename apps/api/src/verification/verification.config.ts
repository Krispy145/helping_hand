export type VerificationLaunchMethod =
  | 'default'
  | 'age-estimation'
  | 'doc-scan';

export type VerificationConfig = {
  minimumUserAge: number;
  ageEstimationThreshold: number;
  sessionTtlSeconds: number;
  stubEnabled: boolean;
  yotiSdkId: string | null;
  yotiApiKey: string | null;
  yotiBaseUrl: string;
  yotiUserViewBaseUrl: string;
  callbackUrl: string;
  cancelUrl: string;
  notificationUrl: string | null;
  webhookSecret: string;
  webhookPublicKey: string | null;
};

const DEFAULT_MINIMUM_AGE = 18;
const DEFAULT_TTL_SECONDS = 900;
const DEFAULT_CALLBACK = 'helpinghand://verification/callback';
const DEFAULT_CANCEL = 'helpinghand://verification/cancel';
const DEFAULT_YOTI_API = 'https://age.yoti.com/api/v1';
const DEFAULT_YOTI_VIEW = 'https://age.yoti.com';

function parsePositiveInt(value: string | undefined, fallback: number): number {
  if (!value) return fallback;
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
}

export function isYotiConfigured(
  sdkId = process.env.YOTI_SDK_ID,
  apiKey = process.env.YOTI_API_KEY,
): boolean {
  return Boolean(sdkId && apiKey);
}

export function isStubEnabled(
  nodeEnv = process.env.NODE_ENV,
  stubFlag = process.env.VERIFICATION_STUB,
): boolean {
  if (stubFlag === 'false') return false;
  if (stubFlag === 'true') return true;
  return nodeEnv !== 'production';
}

export function loadVerificationConfig(
  env: NodeJS.ProcessEnv = process.env,
): VerificationConfig {
  const minimumUserAge = parsePositiveInt(
    env.MINIMUM_USER_AGE,
    DEFAULT_MINIMUM_AGE,
  );
  const estimationOverride = parsePositiveInt(
    env.YOTI_AGE_ESTIMATION_THRESHOLD,
    0,
  );
  const notificationUrl = env.YOTI_NOTIFICATION_URL?.trim() || null;

  return {
    minimumUserAge,
    ageEstimationThreshold:
      estimationOverride >= minimumUserAge
        ? estimationOverride
        : minimumUserAge + 3,
    sessionTtlSeconds: parsePositiveInt(
      env.YOTI_SESSION_TTL,
      DEFAULT_TTL_SECONDS,
    ),
    stubEnabled: isStubEnabled(env.NODE_ENV, env.VERIFICATION_STUB),
    yotiSdkId: env.YOTI_SDK_ID?.trim() || null,
    yotiApiKey: env.YOTI_API_KEY?.trim() || null,
    yotiBaseUrl: env.YOTI_API_BASE_URL?.trim() || DEFAULT_YOTI_API,
    yotiUserViewBaseUrl:
      env.YOTI_USER_VIEW_BASE_URL?.trim() || DEFAULT_YOTI_VIEW,
    callbackUrl: env.YOTI_CALLBACK_URL?.trim() || DEFAULT_CALLBACK,
    cancelUrl: env.YOTI_CANCEL_URL?.trim() || DEFAULT_CANCEL,
    notificationUrl:
      notificationUrl && notificationUrl.startsWith('https://')
        ? notificationUrl
        : null,
    webhookSecret: env.VERIFICATION_WEBHOOK_SECRET ?? 'dev-verification-secret',
    webhookPublicKey: env.YOTI_WEBHOOK_PUBLIC_KEY?.trim() || null,
  };
}

export function buildYotiUserViewUrl(
  config: Pick<VerificationConfig, 'yotiUserViewBaseUrl' | 'yotiSdkId'>,
  sessionId: string,
  method: VerificationLaunchMethod = 'default',
): string | null {
  if (!config.yotiSdkId) return null;
  const path =
    method === 'age-estimation'
      ? '/age-estimation'
      : method === 'doc-scan'
        ? '/doc-scan'
        : '';
  const url = new URL(`${config.yotiUserViewBaseUrl}${path}`);
  url.searchParams.set('sessionId', sessionId);
  url.searchParams.set('sdkId', config.yotiSdkId);
  return url.toString();
}
