# Architecture Plan (Flutter + Backend) — Updated

## Guiding constraints
- Mandatory identity verification (anti-bot, anti-impersonation)
- Adults-only (18+) for MVP
- Privacy-first data minimization
- Requests must be vetted *before* reaching helpers
- Strong reporting and escalation pathways (incl. authorities and helplines)
- Scalable, auditable moderation and risk controls
- Public analytics are aggregated + thresholded (no PII)

---

## Recommended Backend Stack (practical + scalable)

### Core choice (suggested)
- **Backend API:** Node.js (NestJS) *or* Kotlin (Ktor) *or* Python (FastAPI)
- **Database:** Postgres (operational source of truth)
- **Cache/queues:** Redis (rate-limits + lightweight queues)
- **Async processing:** a queue worker for vetting + moderation tasks
- **Object storage:** S3-compatible (evidence media, consented posts)
- **Analytics:** event stream → warehouse → public dashboard API

### Safety & Moderation Layer (New)
- **Toxicity Classifier API:** Integrated real-time service (e.g., Perspective API, OpenAI Moderation, or self-hosted BERT).
- **LLM Gateway:** For contextual vetting analysis (e.g., GPT-4o-mini / Gemini Flash access).
- **Microservice:** logical separation for the "Vetting Pipeline" to decouple latency-sensitive chat from heavy analysis.

### Deployment
- Cloud Run / ECS / Kubernetes (start simple: Cloud Run or ECS)
- WAF + bot protection at the edge
- Centralized secrets manager

---

## Identity Verification & Authentication (no Firebase Auth)

### Goal
Make “being a real verified adult human” the gate to participate, without storing raw ID documents.

### Flow (recommended)
1. User creates an account with **email + device binding** (no trust yet).
2. User completes **3rd-party ID verification** (KYC-style provider).
3. Provider sends webhook result → backend marks user `verified`.
4. Backend issues app auth tokens:
   - **Access token (JWT, short-lived)**
   - **Refresh token (rotating, stored securely on device)**

### What to store
- `user_id` (internal)
- `verification_status`
- `verification_provider` + `provider_reference_id`
- `verified_at`
- minimal profile: display name + optional photo

### What NOT to store
- ID doc images
- legal name
- DOB/address (unless legally required; avoid in MVP)

---

## Request Vetting Pipeline (key safety requirement)

### Core rule
**No request reaches helpers until it is vetted.**

### Data structure idea
- `HelpRequestDraft` (private to requester)
- `HelpRequestVetted` (visible to eligible helpers)

### Vetting steps (MVP)
- **Automated AI Pipeline:** (See `16_REQUEST_VETTING.md`)
  - Stage 1: Regex/Keyword blocks (PII, Crypto)
  - Stage 2: Toxicity ML Scoring
  - Stage 3: LLM Intent Analysis (Anti-lure, safety policy check)
- If high risk:
  - request is blocked, not delivered
  - safety incident is recorded
  - user is routed to appropriate resources when relevant

### Vetting steps (V1+)
- Human moderation queue for **Appeals only**.
- “Safe alternatives” suggestions (resources instead of risky requests)

---

## Flutter Architecture

### State management
Use **Riverpod** for testable DI + scalable state.

### App layering (recommended)
- `presentation/` (screens + widgets)
- `application/` (use-cases, orchestration)
- `domain/` (entities, repository interfaces, rules)
- `data/` (API clients, DTOs, persistence)

### Privacy defaults
- Secure local storage for refresh tokens
- Approximate location for discovery
- Precise location only after:
  - session accepted
  - explicit consent granted
  - session is active (with TTL)

---

## Chat architecture
- Session-scoped chat room
- **Real-time Safety Filter:**
  - Pre-send hook: Check Toxicity Score.
  - Pre-send hook: Regex for Phone/URL.
- Auto-lock at session end
- Retention policy enforced (short retention unless reported)

---

## Reporting & Escalation architecture
- Reports are immutable records
- Moderation actions append-only (audit trail)
- Authority escalation: phase-based (roadmap)
