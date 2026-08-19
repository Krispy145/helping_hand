# Testing & Release Strategy

This document outlines the testing protocols and release preparation steps for the Helping Hand platform.

## 1. Testing Layers

### A. Backend (NestJS)
**Goal**: Ensure API reliability, data integrity, and business logic correctness.

#### 1. Unit Tests
- **Scope**: Individual Services and Utility functions.
- **Tools**: Jest.
- **Naming**: `*.spec.ts`.
- **Coverage**:
    - `VettingService`: Keyword filtering (Done).
    - `AuthService`: Token generation, hashing (Done).
    - `RequestsService`: CRUD logic (Mocking Prisma) (Done).

#### 2. Integration Tests
- **Scope**: Controller + Service + Database (In-Memory or Test Container).
- **Tools**: Jest + Supertest.
- **Key Flows**:
    - `POST /auth/login` -> Get Token (Done).
    - `POST /requests` (Authorized) -> 201 Created (Done; mocked persistence).
    - `GET /requests/nearby` -> Returns valid data types (Done; public approx coords).

#### 3. E2E Tests
- **Scope**: Full application flow.
- **Tools**: Jest (End-to-End config).
- **Critical Paths**: User Registration -> Login -> Create Request -> Verify Event Trigger -> Discovery.

### B. Frontend (Flutter)
**Goal**: Ensure UI responsiveness, state management stability, and error handling.

#### 1. Unit Tests (Logic)
- **Scope**: Repositories, Notifiers (Riverpod), Providers.
- **Tools**: `flutter_test`, `mockito`.
- **Coverage**:
    - `AuthNotifier`: State transitions (Loading -> Data/Error).
    - `RequestRepository`: Mapping JSON to DTOs.

#### 2. Widget Tests (UI properties)
- **Scope**: Individual Screens and Components.
- **Tools**: `flutter_test`.
- **Coverage**:
    - `CreateRequestScreen`: Form validation errors show up (Done).
    - `FeedScreen`: Loading spinner appears, then list (Done).

#### 3. Integration/Golden Tests
- **Scope**: Visual regression and flow.
- **Tools**: `integration_test` (Flutter SDK).
- **Coverage**: Navigation from Login to Home.

## 2. CI/CD Pipeline (Planned)

### Pull Request Checks
1.  **Lint**: `npm run lint` (API), `flutter analyze` (Mobile).
2.  **Test**: `npm run test` (API), `flutter test` (Mobile).
3.  **Build**: Verify compilation.

### Release Staging
1.  **Shorebird**: Push patch for Mobile.
2.  **Docker**: Build API image and push to registry.
3.  **Deploy**: Auto-deploy to Staging environment.

## 3. Linter Rules

- **Typescript**: Strict mode, Prettier formatting.
- **Dart**: `flutter_lints` (recommended), pedantic rules.
- **Commit**: Conventional Commits (feat, fix, chore, etc.).

## 4. Current Status (v0.3.0)

- [x] Auth Feature Implementation
- [x] Request Feature Implementation
- [x] Vetting Logic (Unit Tested)
- [x] Discovery Feed
- [x] Auth + request HTTP tests (mocked persistence)
- [x] Create-request / feed widget tests
- [ ] Full Coverage (E2E against a live database still pending)
