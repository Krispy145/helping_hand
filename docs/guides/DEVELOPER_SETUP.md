# Developer Setup Guide

## Prerequisites
-   **Flutter SDK**: 3.x (Stable)
-   **Node.js**: v20+
-   **Docker**: For running the database stack.
-   **Shorebird CLI** (Optional, for deploy verification).

## 1. Monorepo Structure
This project is a Monorepo containing:
-   `apps/api`: NestJS Backend.
-   `apps/mobile`: Flutter Mobile App.
-   `apps/web_pulse`: Flutter Web App.
-   `packages/models`: Shared Dart Data Transfer Objects (DTOs).
-   `packages/ui`: Shared Flutter UI components & Theming.

## 2. Initial Setup

### Backend
1.  Navigate to `apps/api`.
2.  Install dependencies: `npm install`.
3.  Start Docker services: `docker-compose up -d` (from root).
4.  Initialize Database:
    ```bash
    npx prisma migrate dev
    npx prisma generate
    ```
5.  Start Server: `npm run start:dev`.

### Frontend
1.  Navigate to `apps/mobile`.
2.  Install dependencies: `flutter pub get`.
3.  Generate Code (Riverpod/Freezed/Mappable):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  Run App:
    ```bash
    flutter run --flavor dev
    ```

## 3. Shared Packages
If you modify `packages/models`:
1.  Run build_runner in `packages/models`.
2.  Run `flutter pub upgrade` in `apps/mobile` to link changes.

## 4. Testing
-   **Backend**: `npm run test` (Unit) / `npm run test:e2e` (End-to-End).
-   **Mobile**: `flutter test`.
-   **Push (FCM)**: [Push Notifications](PUSH_NOTIFICATIONS.md). Local Android does **not** need Google Play Console. A real iPhone needs a paid Apple Developer Program membership for the APNs `.p8`.
