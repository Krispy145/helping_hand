# Age Verification

Helping Hand is adults-only. Users must pass an independent over-age check before they can request or offer help. Flutter never decides eligibility and never stores identity documents, selfies, biometrics, or dates of birth.

## Why Yoti

[Yoti Age Verification](https://developers.yoti.com/age-verification/quick-start) is a dedicated over-age service:

1. Facial age estimation with passive liveness / anti-spoofing.
2. Digital ID where available.
3. Government ID document scan when estimation cannot confidently establish eligibility.

The API answers “is this person over the configured threshold?” rather than returning a full identity record. That matches the product’s data-minimization rules.

The provider is behind `AgeVerificationProvider`. A later swap to Persona, Veriff, or Sumsub should implement that interface; the Flutter app only consumes `/verification/*`.

## Flutter flow

1. Registration / onboarding (unchanged).
2. Age-restricted actions call `ensureVerifiedAdult()`.
3. The verification screen asks for date of birth locally, then `POST /verification/eligibility`. The date is **not stored**.
4. If eligible, `POST /verification/start` creates a server-side session.
5. Flutter opens the Yoti user view returned by the backend (`https://age.yoti.com/age-estimation?sessionId=&sdkId=`).
6. On app resume, Flutter calls `POST /verification/refresh` and polls while status is `PENDING`.
7. `REQUIRES_DOCUMENT` shows “Verify with government ID”, which opens the doc-scan user view.
8. `VERIFIED` returns the user to the original action. Already-verified users are not asked again.

The client cannot mark itself verified. Stub buttons exist only when the API reports `stub: true` (non-production without Yoti credentials).

## Backend flow

```text
Flutter  --POST /verification/start-->  API
API      --POST /api/v1/sessions---->  Yoti (Bearer API key + Yoti-SDK-Id)
Yoti     --session id--------------->  API
API      --launch URL--------------->  Flutter
Flutter  --opens age.yoti.com------->  Yoti user view
Yoti     --POST /verification/webhook--> API (signed)
API      --GET /sessions/{id}/result--> Yoti (authoritative)
API      --updates User + Attempt--->  Postgres
Flutter  --POST /verification/refresh--> API
```

Credentials used: `YOTI_SDK_ID` and `YOTI_API_KEY` from [Yoti Hub](https://developers.yoti.com/age-verification/quick-start). They never leave the API.

## Database model

`User` keeps a denormalized gate used by `VerifiedAdultGuard`:

- `verificationStatus` (`UNVERIFIED` default for existing users — never auto-verified)
- `verificationProvider` / `verificationProviderRef`
- `verifiedAt`
- `verificationFailureReason`
- `ageThreshold` (threshold the user was checked against)

`AgeVerificationAttempt` retains audit history (session id, status, threshold, method name, expiry).  
`AgeVerificationNotification` stores Yoti notification ids for webhook idempotency.

Not stored: estimated facial age, selfies, ID images, legal names, dates of birth, or raw provider payloads.

## Webhook handling

`POST /verification/webhook` accepts Yoti notifications. Signatures are verified with RSA-SHA256 + PSS padding against Yoti’s published public key ([notifications](https://developers.yoti.com/age-verification/notifications)).

After a valid signature the API fetches `GET /sessions/{id}/result` and applies that status. Replays cannot downgrade a `VERIFIED` user. `COMPLETE` is sticky.

Local development can omit `YOTI_NOTIFICATION_URL` (must be HTTPS). The app then relies on `/verification/refresh`.

## Environment variables

See `apps/api/.env.example`.

| Variable | Purpose |
| --- | --- |
| `MINIMUM_USER_AGE` | Legal / product minimum. Backend is authoritative. Default `18`. |
| `YOTI_AGE_ESTIMATION_THRESHOLD` | Facial-estimation threshold. Must be ≥ `MINIMUM_USER_AGE`. Default `minimum + 3` (Yoti recommends a buffer above the barrier to entry). |
| `YOTI_SDK_ID` / `YOTI_API_KEY` | Yoti Hub credentials. Server-side only. |
| `YOTI_SESSION_TTL` | Session lifetime in seconds (default `900`). |
| `YOTI_NOTIFICATION_URL` | HTTPS webhook endpoint. |
| `YOTI_CALLBACK_URL` / `YOTI_CANCEL_URL` | Return URLs. Default `helpinghand://verification/callback` and `.../cancel`. |
| `VERIFICATION_STUB` | Force the stub provider. Default on when Yoti is unset and `NODE_ENV !== production`. |

## Local development / testing

Without Yoti credentials the stub provider is used. The verification screen shows dev-only outcome buttons. Automated tests mock Yoti (`fetch`) and never call the production API.

```bash
cd apps/api
cp .env.example .env   # fill DATABASE_URL / JWT_SECRET
npx prisma migrate dev
npm test
```

## Sandbox / testing configuration

1. Create an Age Verification application in Yoti Hub (sandbox).
2. Copy SDK ID and API key into the API environment.
3. Expose the API with HTTPS (ngrok or similar) and set `YOTI_NOTIFICATION_URL=https://<host>/verification/webhook`.
4. Keep `MINIMUM_USER_AGE=18` and `YOTI_AGE_ESTIMATION_THRESHOLD=21` unless Yoti advises otherwise for your market.

## Production setup

1. Use a production Yoti Age Verification application.
2. Set `NODE_ENV=production`. Do **not** set `VERIFICATION_STUB=true`.
3. Set HTTPS `YOTI_NOTIFICATION_URL` on the public API.
4. Prefer an `https://` app callback / universal link if the Yoti dashboard requires HTTPS redirects; otherwise the existing `helpinghand://` scheme returns users to the app.
5. Confirm `VerifiedAdultGuard` remains on request-create and session-create.

## Privacy / data retention

Helping Hand stores the verification assertion only. Yoti processes the selfie or document under their own policy. Copy on the verification screen matches this split: we do not keep those images; the provider does for the duration of their check.

Production logs record session id, notification id, and state only — never estimated age, documents, or dates of birth.

## Replacing Yoti later

Implement `AgeVerificationProvider` (`createSession`, `getSessionResult`, `parseWebhook`, `verifyWebhook`) and return it from `createAgeVerificationProvider()`. Keep the REST contract and Prisma models. Flutter continues to open a `launch_url` / `document_launch_url` and poll `/verification/refresh`.
