# CI/CD & Deployment Strategy

This document outlines the strategy for automating the build, test, and deployment capability of **Helping Hand**.

## Goals
1.  **Automated Quality Control**: Run tests and linting on every PR.
2.  **Automated Distribution**: Deploy to App Store/Play Store (TestFlight/Internal Testing) via Fastlane.
3.  **Over-the-Air Updates**: Use Shorebird for instant code patches.

## 1. Tooling Stack

### Fastlane
-   **Android**: Handle signing, building App Bundles (.aab), and uploading to Google Play Console.
-   **iOS**: Handle signing (Match), building archives (.ipa), and uploading to TestFlight.

### Shorebird
-   **Code Push**: Allows pushing Dart-only changes instantly to users without a full store release.
-   **Integration**: Wraps the standard `flutter build` commands.

### GitHub Actions
-   **CI**: Lint, Test (Unit/Widget), Build Checks.
-   **CD**: Trigger Fastlane lanes on merge to `main` (for staging) or `release/*` (for prod).

## 2. Implementation Steps

### Phase 1: Preparation & Credentials
- [ ] **Android Keystore**: Generate upload keystore.
- [ ] **iOS Certificates**: Setup Match repository (requires private repo/storage). *Note: For MVP/User setup, we might stick to manual signing initially or basic Fastlane `cert`/`sigh` if Match is too complex for now.*
- [ ] **API Keys**: Apple App Store Connect API Key, Google Play Service Account JSON.
- [ ] **Secrets Management**: GitHub Secrets for all keys.

### Phase 2: Fastlane Configuration (`apps/mobile/android` & `apps/mobile/ios`)
- [ ] **Initialize Fastlane**: `fastlane init`.
- [ ] **Define Lanes**:
    -   `lane :beta`: Build & Upload to TestFlight / Internal Testing.
    -   `lane :deploy`: Promote to Production (manual trigger).
    -   `lane :shorebird_patch`: Run shorebird patch command.

### Phase 3: Shorebird Initialization
- [ ] **Init**: `shorebird init` in `apps/mobile`.
- [ ] **Login**: Authenticate CI with Shorebird token.
- [ ] **Update Workflows**: Use `shorebird release android` / `shorebird release ios`.

### Phase 4: GitHub Actions Workflows
- [ ] **`ci.yml`**: On PR. Runs `flutter test`, `flutter analyze`.
- [ ] **`cd_beta.yml`**: On push to `main`. Deploys to Staging flavors.
- [ ] **`cd_prod.yml`**: On push to `release/*`. Deploys to Prod flavors.

## 3. Immediate Action Plan (This Session)

1.  **Dependencies**: Add Shorebird and Fastlane to the project.
2.  **CI Workflow**: Create `.github/workflows/ci.yml` to enforce quality.
3.  **Fastlane Stubbing**: Initialize the Fastlane directory structures (User will need to provide keys later).

> [!IMPORTANT]
> Full CD requires sensitive keys (Apple Developer Account, Google Play Console JSON). We will set up the *scaffolding* and scripts now, but the actual "upload to store" will fail until valid keys are placed in secrets/env.
