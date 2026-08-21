import { randomUUID } from 'crypto';
import {
  AgeVerificationProvider,
  CreateAgeVerificationSessionInput,
  CreatedAgeVerificationSession,
  ProviderSessionResult,
  ProviderWebhookEvent,
} from './age-verification.provider';

export class StubAgeVerificationProvider implements AgeVerificationProvider {
  readonly name = 'stub';

  createSession(
    input: CreateAgeVerificationSessionInput,
  ): Promise<CreatedAgeVerificationSession> {
    return Promise.resolve({
      providerSessionId: randomUUID(),
      expiresAt: new Date(Date.now() + input.ttlSeconds * 1000),
      launchUrl: null,
      documentLaunchUrl: null,
    });
  }

  getSessionResult(): Promise<ProviderSessionResult | null> {
    return Promise.resolve(null);
  }

  parseWebhook(body: Record<string, unknown>): ProviderWebhookEvent | null {
    if (typeof body.referenceId !== 'string' || !body.referenceId) {
      return null;
    }
    const approved = Boolean(body.approved);
    const isAdult = Boolean(body.isAdult);
    let state = 'ERROR';
    if (approved && isAdult) state = 'COMPLETE';
    else if (approved && !isAdult) state = 'FAIL';
    return {
      providerSessionId: body.referenceId,
      notificationId: `stub:${body.referenceId}:${state}`,
      state,
      method: 'STUB',
    };
  }
}
