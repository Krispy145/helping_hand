# Helping Hand

Helping Hand is a safety-first app for connecting people who need help with nearby people willing to help. A request is never shown to helpers until it has been vetted. Discovery uses approximate location only; chat is locked to one session and can be reported or ended by either person.

This monorepo holds the mobile app, the NestJS API, and Pulse (staff/public web).

## How it works

**Mobile (`apps/mobile`)** is a Flutter app (Riverpod, `go_router`, Dev/Stg/Prod flavors). People sign in with email (JWT, not Firebase Auth), pass a configurable 18+ age check via Yoti (stubbed locally), post a request, find approved requests on a map or feed, offer help, and chat in-session. Generic push alerts (FCM) fire on help offered, new messages, and session end — chat text is never in the payload.

**Pulse (`apps/web_pulse`)** is Flutter web: anonymous public totals plus a staff login for vetting appeals.

**API (`apps/api`)** is NestJS with Prisma/Postgres. It owns identity, request vetting (keyword/PII/crisis filters; toxicity/LLM still stubbed), nearby discovery, Socket.io chat, reports, Pulse stats, FCM via Firebase Admin, and age verification. Shared Dart DTOs live in `packages/models`; the design system is `packages/ui`.

Local stack: Postgres + Redis via Docker, API on port **3000**, Pulse on **8081**. See [Developer Setup](docs/guides/DEVELOPER_SETUP.md).

## Age verification

Helping Hand is adults-only. The backend decides eligibility; Flutter never marks an account verified.

**Local / Dev stub:** copy `apps/api/.env.example` to `apps/api/.env` and leave `YOTI_SDK_ID` and `YOTI_API_KEY` empty. The API uses an in-process stub and does **not** call Yoti. After `npx prisma migrate dev`, the mobile verification screen shows dev-only outcome buttons (old enough / underage / document fallback).

**Yoti (staging and production):** create an Age Verification application in [Yoti Hub](https://developers.yoti.com/age-verification/quick-start). Put `YOTI_SDK_ID` and `YOTI_API_KEY` on the API only — never in the Flutter app. Set HTTPS `YOTI_NOTIFICATION_URL` for webhooks. Facial estimation uses a higher threshold than `MINIMUM_USER_AGE` (default 21 vs 18). Full setup: [Age Verification](docs/guides/AGE_VERIFICATION.md).

## Repository Structure

-   **`apps/`**: Application entry points.
    -   `mobile`: Flutter Mobile App (Android/iOS).
    -   `web_pulse`: Flutter Web Admin/Portal.
    -   `api`: NestJS Backend API.
-   **`packages/`**: Shared libraries.
    -   `models`: Shared Dart/Flutter Data Transfer Objects.
    -   `ui`: Shared Flutter UI components and theme.
-   **`docs/`**: Project documentation.
-   **`scripts/`**: Utility scripts (e.g., deployment).

## Documentation

### 🚀 Getting Started
-   [Developer Setup Guide](docs/guides/DEVELOPER_SETUP.md): How to build and run the project locally.
-   [Authentication Guide](docs/guides/AUTHENTICATION.md): Understanding the auth flow.
-   [Age Verification](docs/guides/AGE_VERIFICATION.md): Yoti over-age check, webhooks, and local stub.
-   [Push Notifications](docs/guides/PUSH_NOTIFICATIONS.md): FCM setup and how to test session alerts.
-   [CI/CD Manual](docs/guides/CI_CD_MANUAL.md): Deployment pipelines and release strategy.

### 📅 Planning & Roadmap
-   [MVP Plan](docs/planning/01_MVP_PLAN.md)
-   [Technical Foundation](docs/planning/02_TECHNICAL_FOUNDATION.md)
-   [Testing Strategy](docs/planning/03_TESTING_RELEASE.md)
-   [CI/CD Setup Plan](docs/planning/04_CI_CD_SETUP.md)

### 💡 Core Concepts (Ideation)
-   [Vision](docs/ideation/01_VISION.md)
-   [Architecture](docs/ideation/08_ARCHITECTURE.md)
-   [Data Model](docs/ideation/09_DATA_MODEL.md)
-   [Threat Model & Safety](docs/ideation/13_THREAT_MODEL.md)
-   [API Contracts](docs/ideation/10_API_CONTRACTS.md)
