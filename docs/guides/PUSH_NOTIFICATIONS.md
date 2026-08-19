# Push Notifications

Session alerts go through **FCM**. Chat bodies are never included — copy is generic (`New message`, `Someone is offering help`, and so on).

Identity stays Nest JWT. Firebase is only used to deliver the push.

## Accounts you need (and do not need)

| What | Needed to **test locally**? | Needed later to **ship**? |
| :--- | :--- | :--- |
| Firebase project (`helping-hand-dev-145` for dev) | Yes | Yes, one project per environment |
| Nest Admin service-account JSON | Yes (to *send* pushes) | Yes |
| **Apple Developer Program** (paid) + APNs `.p8` | **Only for a real iPhone** | Yes, for TestFlight / App Store |
| **Google Play Console** | **No** | Yes, to publish the Android app |

A free Apple ID is enough to run the iOS simulator. It is **not** enough to create an APNs key. That key lives under [Certificates, Identifiers & Keys](https://developer.apple.com/account/resources/authkeys/list) and requires an enrolled **Apple Developer Program** team.

Google Play Console is for store listing, signing, and tracks. Local Android FCM uses Google Play **services** on the emulator/device, not a Play Console login.

## Recommended first test: Android

Use an **Android emulator with a Google Play system image** (or a physical Android phone). FCM works there without Play Console and without Apple.

The iOS simulator can log in and may even register a token, but it usually **does not show** real APNs/FCM banners. Test iPhone delivery only after the `.p8` is uploaded.

## One-time setup (dev)

Dev Firebase project: `helping-hand-dev-145`.  
Console: https://console.firebase.google.com/project/helping-hand-dev-145/overview

Client config is already in the repo (`google-services.json` / `GoogleService-Info.plist` for the `dev` flavor). Recreate or refresh with:

```bash
./scripts/setup_firebase.sh dev
```

Run that from the **repo root**, not `apps/`.

### API Admin key (required to send)

1. [Service accounts](https://console.firebase.google.com/project/helping-hand-dev-145/settings/serviceaccounts/adminsdk) → **Generate new private key**.
2. Save it **outside the repo**, for example `~/.config/helping-hand/helping-hand-dev-145.json`.
3. In the shell that starts Nest:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/helping-hand/helping-hand-dev-145.json"
```

4. Start Postgres (`docker compose up -d` from the repo root) and the API.
5. Confirm the log line `Firebase Admin Initialized`. If you see the “no credentials” warning, pushes will be skipped.

### iOS APNs `.p8` (physical iPhone only)

1. Enrol in the [Apple Developer Program](https://developer.apple.com/programs/).
2. Create a key with **Apple Push Notifications service (APNs)** enabled and download the `.p8` (Apple shows it once).
3. Note **Key ID** and **Team ID**.
4. Upload it in Firebase → [Cloud Messaging](https://console.firebase.google.com/project/helping-hand-dev-145/settings/cloudmessaging) for bundle `com.helping.dev`.

### Android SHA fingerprints (optional for FCM)

Not required for a basic notification test. Add debug SHA-1 / SHA-256 later if you turn on App Check or Google Sign-In:

```bash
cd apps/mobile/android
./gradlew :app:signingReport
```

Then paste them under Firebase → Project settings → Your apps → Android (`com.helping.dev`).

## How to test

You need **two accounts**. Background the receiving app so the system banner can appear.

1. Start Docker + API with `GOOGLE_APPLICATION_CREDENTIALS` set.
2. From `apps/mobile`:

```bash
flutter run --flavor dev
```

3. On **Android emulator**, forward the API port so `http://localhost:3000` reaches your Mac:

```bash
adb reverse tcp:3000 tcp:3000
```

   A physical Android phone cannot use `localhost`. Point it at your Mac’s LAN IP, or test on the emulator / iOS simulator instead.

4. Sign in on device A. Allow notification permission when asked.
5. Confirm the API logged `POST /notifications/devices` (token registered).
6. Sign in on device B as a second user (another emulator, or uninstall/reinstall and switch accounts).
7. From B, offer help on A’s request (or send a session message while A is backgrounded).

### What you should see

| Event | Receiver | Banner |
| :--- | :--- | :--- |
| Help offered | Requestor | “Someone is offering help” |
| New chat message | The other person | “New message” |
| Assist completed | The other person | “Request completed” |
| Assist ended / cancelled | The other person | “Assist ended” |

Chat text is never in the payload. The API log should show `Sent notification to 1 devices` (or similar). `Failed: 1` usually means a stale token or iOS without APNs.

## Troubleshooting

- **No `Firebase Admin Initialized`**: the debug/run config does not have `GOOGLE_APPLICATION_CREDENTIALS`. Cursor launch configs do not inherit a random terminal `export`.
- **No `POST /notifications/devices`**: Firebase failed to init (wrong flavor / missing `google-services.json`), permission denied, or the app never reached the API.
- **Android `localhost` connection errors**: run `adb reverse tcp:3000 tcp:3000`, or use a Google Play emulator.
- **iPhone silent / no banner**: APNs `.p8` missing, or you are on the simulator.
- **Token registered but no send**: the *other* user has no device token, or you notified the sender instead of the recipient.

## Later environments

```bash
./scripts/setup_firebase.sh stg
./scripts/setup_firebase.sh prod --yes
```

Each environment is its own Firebase project. Nest must use the Admin key from **the same project** the phones registered with. Never reuse the prod FCM project on staging.
