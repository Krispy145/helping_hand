import { constants, createVerify } from 'crypto';

/**
 * Public key published by Yoti for Age Verification webhook signatures.
 * @see https://developers.yoti.com/age-verification/notifications
 */
export const YOTI_AVS_PUBLIC_KEY = `-----BEGIN PUBLIC KEY-----
MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAune8+8vPz/pQD6IzdWvX
Q66nh/RcywopCI01Wjo6i7vlH2iVOP1oCkgbObe12iMmVXKRiXgMNT6aXIGe6Ggw
dodzAmt3vT1fmrgub7Of6MgJ56ri2uH1O54DTjbnEbEcLXX13teOusZavntrkNpp
x1c8L0Ol41mRvImJeMHM6I16rLhqB/w1m7USMvof/K6GaP+VmmciZTPyZ6IsXxvB
k0ZoqWqrt2xENlg4O6LXMo7eHEiG+edm9uDpbZK1RhiCd6hyDZ/t4bBQNg4misFF
WezQSiUlPwBLRg1AJ3CNrtBzs49BZ30U7WSPUS0Gsq1lhhDtUtJUt4CdkDAfkVY6
2C6aaqKV940GcPFN7MjOeFus3VNJE3zyHVLT8DStuLMXHY+gQBGFOyxN6heZbm7a
Sl9fi7VXlDTlv1jpk4DFMQYF2fpAyomm95GavhllJnDxC2t8ebu0O23B88hPGI3K
kyLtPA8ie6UNmwNqLYpOEN/pwayYw75FcENBDxnWhoe9AgMBAAE=
-----END PUBLIC KEY-----`;

export function verifyYotiNotificationSignature(
  payload: Record<string, unknown>,
  publicKeyPem: string = YOTI_AVS_PUBLIC_KEY,
): boolean {
  const signature = payload.signature;
  if (typeof signature !== 'string' || signature.length === 0) {
    return false;
  }

  const rest: Record<string, unknown> = { ...payload };
  delete rest.sequence_number;
  delete rest.signature;
  const canonical = JSON.stringify(rest).replace(/\s/g, '');

  try {
    const verifier = createVerify('RSA-SHA256');
    verifier.update(canonical, 'utf8');
    return verifier.verify(
      {
        key: publicKeyPem,
        padding: constants.RSA_PKCS1_PSS_PADDING,
      },
      Buffer.from(signature, 'base64'),
    );
  } catch {
    return false;
  }
}

export function looksLikeYotiNotification(
  body: Record<string, unknown>,
): boolean {
  return (
    typeof body.session_key === 'string' && typeof body.signature === 'string'
  );
}
