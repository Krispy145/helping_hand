import { generateKeyPairSync, constants, createSign } from 'crypto';
import {
  verifyYotiNotificationSignature,
  looksLikeYotiNotification,
} from './yoti-webhook.verifier';

function sign(payload: Record<string, unknown>, privateKey: string): string {
  const rest = { ...payload };
  delete rest.sequence_number;
  delete rest.signature;
  const canonical = JSON.stringify(rest).replace(/\s/g, '');
  const signer = createSign('RSA-SHA256');
  signer.update(canonical, 'utf8');
  return signer.sign(
    {
      key: privateKey,
      padding: constants.RSA_PKCS1_PSS_PADDING,
    },
    'base64',
  );
}

describe('Yoti webhook signature', () => {
  const { publicKey, privateKey } = generateKeyPairSync('rsa', {
    modulusLength: 2048,
  });
  const publicPem = publicKey
    .export({ type: 'spki', format: 'pem' })
    .toString();
  const privatePem = privateKey
    .export({ type: 'pkcs8', format: 'pem' })
    .toString();

  const basePayload = {
    method: 'AGE_ESTIMATION',
    result: true,
    session_key: '69db8ad4-c983-40b3-b95a-a8fa576e70a6',
    reference_id: 'attempt-1',
    id: '2480375e-ddc0-4832-9b82-b1d14af5cf75',
    timestamp: 1613482863,
    state: 'COMPLETE',
    check_type: 'PASSIVE',
    sequence_number: 1,
  };

  it('accepts a valid PSS signature', () => {
    const signature = sign(basePayload, privatePem);
    expect(
      verifyYotiNotificationSignature({ ...basePayload, signature }, publicPem),
    ).toBe(true);
  });

  it('rejects a tampered payload', () => {
    const signature = sign(basePayload, privatePem);
    expect(
      verifyYotiNotificationSignature(
        { ...basePayload, state: 'FAIL', signature },
        publicPem,
      ),
    ).toBe(false);
  });

  it('rejects a missing signature', () => {
    expect(verifyYotiNotificationSignature(basePayload, publicPem)).toBe(false);
  });

  it('detects Yoti notification payloads', () => {
    expect(
      looksLikeYotiNotification({ session_key: 'abc', signature: 'sig' }),
    ).toBe(true);
    expect(
      looksLikeYotiNotification({ referenceId: 'abc', approved: true }),
    ).toBe(false);
  });
});
