# CI/CD Pipeline Manual

## Overview
Helping Hand uses a 3-tier CI/CD strategy comprising **Development**, **Staging**, and **Production**. The pipeline handles Mobile (Android/iOS), Web (Firebase), and API (Docker) deployments synchronously.

## Branching Strategy

| Tier | Branch | Flavor ID | Firebase Project | API Tag |
| :--- | :--- | :--- | :--- | :--- |
| **Development** | `develop` | `dev` | `helping-hand-dev-145` | `dev-latest` |
| **Staging** | `staging` | `stg` | `helping-hand-stg-145` | `staging-latest` |
| **Production** | `main` | `prod` | `helping-hand-prod-145` | `prod-latest` |

## Triggers

### Automated
-   **Push to `develop`** -> Triggers [Dev Release]
-   **Push to `staging`** -> Triggers [Staging Release]
-   **Push to `main`** -> Triggers [Production Release]
-   **Pull Request** -> Triggers [CI Check] (Lint & Test only)

### Manual
You can manually trigger a release from your terminal using the helper script:

```bash
# Deploy to Development
./scripts/deploy.sh dev

# Deploy to Staging
./scripts/deploy.sh staging

# Deploy to Production (Use with caution!)
./scripts/deploy.sh prod
```

*Prerequisite: GitHub CLI (`gh`) must be installed and authenticated.*

### Firebase projects
Each environment is its own Firebase project (Android + iOS + Pulse Hosting). Create or refresh one from the **repo root**:

```bash
./scripts/setup_firebase.sh dev
./scripts/setup_firebase.sh stg
./scripts/setup_firebase.sh prod --yes
```

Do not run this from `apps/`. Hosting config lives at the monorepo root so Pulse, mobile, and the API Admin SDK share the same project.

## Infrastructure

### Fastlane (Mobile)
Located in `apps/mobile/android/fastlane` and `apps/mobile/ios/fastlane`.
-   **Android**: Builds App Bundle (`.aab`) and uploads to Play Console tracks (Internal/Beta/Production).
-   **iOS**: Builds Archive (`.ipa`) and uploads to TestFlight.

### Shorebird (Code Push)
Allows patching Dart code without store releases.
-   Run `shorebird release android` or `shorebird patch android` locally or via CI (future config).

### GitHub Actions
All workflows are capable of parallel execution.
-   `release_*.yml`: Orchestrators.
-   `call_*.yml`: Reusable logic.
