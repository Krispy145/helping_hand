# MVP Implementation Plan: Helping Hand

**Goal:** Build a functional, safety-gated MVP that allows verified users to request help, have it vetted by AI, and connect with local helpers.

## 1. Safety & Infrastructure (The Foundation)
**Priority:** Critical
- [x] **Project Setup:**
  - [x] Initialize Monorepo structure (`apps/mobile`, `apps/api`, `apps/web_pulse`).
  - [x] Initialize Shared Packages (`packages/models`, `packages/ui`).
  - [x] **Shared:** Setup Slang (i18n) & ThemeExtensions in `packages/ui`.
  - [x] **Mobile:** Setup `flutter_flavorizr` (Dev/Stg/Prod) & `flutter_native_splash`.
  - [ ] **Mobile:** Initialize `shorebird` for OTA updates.
  - [x] **Mobile:** Configure `go_router` Deep Linking & FCM.
  - [x] **Web:** Initialize Firebase Hosting.
  - [x] **Backend:** Setup NestJS + Docker Compose (Postgres, Redis).
  - [x] **Backend:** Setup `NotificationModule` (FCM + Interface).
- [ ] **Database & Data:**
  - [x] Define Prisma Schema (User, Request, Report).
  - [ ] Setup PostGIS extension (Planned).
- [ ] **Identity Gate:**
  - Mock "Provider" Webhook for dev.
  - User model with `verificationStatus`.
- **Automated Vetting Engine (Stubbed for speed, then logic):**
  - `VettingModule` in NestJS (Queue-based).
  - Regex Filter implementation.
  - LLM Service integration (OpenAI/Anthropic adapter).

## 2. Core User Flows
**Priority:** High

### A. Authentication & Onboarding
- [x] **Frontend:** Login/Register Screens.
- [x] **Backend:** Auth Module (JWT + Passport).
- [x] **Shared:** Auth DTOs.
- [x] **State:** Auth Persistence (Secure Storage).

### B. Request Lifecycle
- [ ] **Draft Mode:** User creates request -> `status: draft`.
- [ ] **Vetting Trigger:** User submits -> `status: pending_vetting`.
- [ ] **Helpers View:**
  - `GET /requests/nearby` (Only returns `status: approved` & `geoHash` approx).
- [ ] **Session Start:** Helper "Accepts" -> Session Created.

### C. Active Session
- [ ] **Chat:** Real-time WebSocket (Gateway).
- [ ] **Safety Controls:**
  - "End Session" button (Both sides).
  - "Report" button (Generates `Report` record).
  - Location sharing toggle (Boolean flag in Session).

## 3. Verification Plan

### Automated Tests
- **Backend (Jest):**
  - Unit tests for `VettingService` (ensure regex blocks bad words).
  - Integration tests for `AuthService` (tokens).
  - E2E tests for the "Draft -> Approved" flow.
- **Frontend (Flutter Test):**
  - Widget tests for the "Emergency Button" presence.
  - Golden tests for the Request Form.

### Manual Verification
- **Safety Drill:**
  1. Create a request with "scam" keywords.
  2. Verify it is auto-rejected.
  3. Verify it does NOT appear in the Helper feed.
- **Happy Path:**
  1. User A (Verified) posts valid request.
  2. User B (Helper) sees it.
  3. User B accepts.
  4. Chat works.
  5. Session ends -> Chat locks.
