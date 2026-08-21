import { Logger, ServiceUnavailableException } from '@nestjs/common';
import {
  AgeVerificationProvider,
  CreateAgeVerificationSessionInput,
  CreatedAgeVerificationSession,
  ProviderSessionResult,
  ProviderSessionStatus,
  ProviderWebhookEvent,
} from './age-verification.provider';
import {
  VerificationConfig,
  buildYotiUserViewUrl,
} from '../verification.config';
import {
  looksLikeYotiNotification,
  verifyYotiNotificationSignature,
  YOTI_AVS_PUBLIC_KEY,
} from './yoti-webhook.verifier';

type YotiCreateSessionResponse = {
  id?: string;
  expires_at?: string;
  status?: string;
};

type YotiMethodState = {
  allowed?: boolean;
  attempts_remaining?: number;
};

type YotiSessionResultResponse = {
  id?: string;
  status?: string;
  method?: string;
  expires_at?: string;
  doc_scan?: YotiMethodState;
};

const PROVIDER_STATUSES: ProviderSessionStatus[] = [
  'PENDING',
  'IN_PROGRESS',
  'COMPLETE',
  'FAIL',
  'ERROR',
  'CANCELLED',
  'EXPIRED',
];

export class YotiAgeVerificationProvider implements AgeVerificationProvider {
  readonly name = 'YOTI';
  private readonly logger = new Logger(YotiAgeVerificationProvider.name);

  constructor(private readonly config: VerificationConfig) {}

  async createSession(
    input: CreateAgeVerificationSessionInput,
  ): Promise<CreatedAgeVerificationSession> {
    const sdkId = this.requireSdkId();
    const body = {
      type: 'OVER',
      ttl: input.ttlSeconds,
      age_estimation: {
        allowed: true,
        threshold: input.estimationThreshold,
        level: 'PASSIVE',
        retry_limit: 2,
      },
      digital_id: {
        allowed: true,
        threshold: input.minimumAge,
        age_estimation_allowed: true,
        age_estimation_threshold: input.estimationThreshold,
        retry_limit: 1,
      },
      doc_scan: {
        allowed: true,
        threshold: input.minimumAge,
        authenticity: 'AUTO',
        level: 'PASSIVE',
        retry_limit: 1,
      },
      credit_card: { allowed: false },
      mobile: { allowed: false },
      reference_id: input.referenceId,
      callback: { auto: true, url: input.callbackUrl },
      cancel_url: input.cancelUrl,
      retry_enabled: true,
      resume_enabled: true,
      synchronous_checks: true,
      ...(input.notificationUrl
        ? { notification_url: input.notificationUrl }
        : {}),
    };

    const response = await this.request<YotiCreateSessionResponse>(
      'POST',
      '/sessions',
      body,
    );
    if (!response.id) {
      throw new ServiceUnavailableException(
        'Age verification provider did not return a session',
      );
    }

    return {
      providerSessionId: response.id,
      expiresAt: response.expires_at
        ? new Date(response.expires_at)
        : new Date(Date.now() + input.ttlSeconds * 1000),
      launchUrl: buildYotiUserViewUrl(
        {
          yotiUserViewBaseUrl: this.config.yotiUserViewBaseUrl,
          yotiSdkId: sdkId,
        },
        response.id,
        'age-estimation',
      ),
      documentLaunchUrl: buildYotiUserViewUrl(
        {
          yotiUserViewBaseUrl: this.config.yotiUserViewBaseUrl,
          yotiSdkId: sdkId,
        },
        response.id,
        'doc-scan',
      ),
    };
  }

  async getSessionResult(
    providerSessionId: string,
  ): Promise<ProviderSessionResult | null> {
    try {
      const result = await this.request<YotiSessionResultResponse>(
        'GET',
        `/sessions/${encodeURIComponent(providerSessionId)}/result`,
      );
      const status = this.toStatus(result.status);
      if (!status) return null;
      return {
        providerSessionId: result.id ?? providerSessionId,
        status,
        method: typeof result.method === 'string' ? result.method : null,
        documentAvailable:
          result.doc_scan?.allowed === true &&
          (result.doc_scan.attempts_remaining ?? 0) > 0,
      };
    } catch (error) {
      this.logger.warn(
        `Unable to fetch Yoti session result (${this.errorCode(error)})`,
      );
      return null;
    }
  }

  parseWebhook(body: Record<string, unknown>): ProviderWebhookEvent | null {
    if (!looksLikeYotiNotification(body)) return null;
    if (typeof body.session_key !== 'string' || typeof body.id !== 'string') {
      return null;
    }
    return {
      providerSessionId: body.session_key,
      notificationId: body.id,
      state: typeof body.state === 'string' ? body.state : 'ERROR',
      method: typeof body.method === 'string' ? body.method : null,
    };
  }

  verifyWebhook(body: Record<string, unknown>): boolean {
    return verifyYotiNotificationSignature(
      body,
      this.config.webhookPublicKey ?? YOTI_AVS_PUBLIC_KEY,
    );
  }

  private toStatus(value: string | undefined): ProviderSessionStatus | null {
    if (!value) return null;
    return PROVIDER_STATUSES.includes(value as ProviderSessionStatus)
      ? (value as ProviderSessionStatus)
      : null;
  }

  private requireSdkId(): string {
    if (!this.config.yotiSdkId || !this.config.yotiApiKey) {
      throw new ServiceUnavailableException(
        'Age verification provider is not configured',
      );
    }
    return this.config.yotiSdkId;
  }

  private async request<T>(
    method: 'GET' | 'POST',
    path: string,
    body?: Record<string, unknown>,
  ): Promise<T> {
    const sdkId = this.requireSdkId();
    let response: Response;
    try {
      response = await fetch(`${this.config.yotiBaseUrl}${path}`, {
        method,
        headers: {
          Authorization: `Bearer ${this.config.yotiApiKey}`,
          'Content-Type': 'application/json',
          'Yoti-SDK-Id': sdkId,
        },
        body: body ? JSON.stringify(body) : undefined,
      });
    } catch {
      throw new ServiceUnavailableException(
        'Age verification provider is unavailable',
      );
    }

    if (!response.ok) {
      this.logger.warn(`Yoti ${method} ${path} failed with ${response.status}`);
      throw new ServiceUnavailableException(
        'Age verification provider is unavailable',
      );
    }

    return (await response.json()) as T;
  }

  private errorCode(error: unknown): string {
    if (error instanceof ServiceUnavailableException) return 'unavailable';
    return 'error';
  }
}
