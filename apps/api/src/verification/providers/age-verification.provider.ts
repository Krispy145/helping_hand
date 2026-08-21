export const AGE_VERIFICATION_PROVIDER = 'AGE_VERIFICATION_PROVIDER';

export type CreateAgeVerificationSessionInput = {
  referenceId: string;
  ttlSeconds: number;
  minimumAge: number;
  estimationThreshold: number;
  callbackUrl: string;
  cancelUrl: string;
  notificationUrl: string | null;
};

export type CreatedAgeVerificationSession = {
  providerSessionId: string;
  expiresAt: Date;
  launchUrl: string | null;
  documentLaunchUrl: string | null;
};

export type ProviderSessionStatus =
  | 'PENDING'
  | 'IN_PROGRESS'
  | 'COMPLETE'
  | 'FAIL'
  | 'ERROR'
  | 'CANCELLED'
  | 'EXPIRED';

export type ProviderSessionResult = {
  providerSessionId: string;
  status: ProviderSessionStatus;
  method: string | null;
  documentAvailable: boolean;
};

export type ProviderWebhookEvent = {
  providerSessionId: string;
  notificationId: string;
  state: string;
  method: string | null;
};

export interface AgeVerificationProvider {
  readonly name: string;
  createSession(
    input: CreateAgeVerificationSessionInput,
  ): Promise<CreatedAgeVerificationSession>;
  getSessionResult(
    providerSessionId: string,
  ): Promise<ProviderSessionResult | null>;
  parseWebhook(body: Record<string, unknown>): ProviderWebhookEvent | null;
  verifyWebhook?(body: Record<string, unknown>): boolean;
}
