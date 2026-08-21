# API Contracts (abstract)

This file describes *intentional* contracts, not a specific framework.

## Auth
- POST /auth/register
- POST /auth/login
- POST /auth/refresh
- POST /auth/logout
- GET  /auth/me

## Verification
- POST /verification/start
- POST /verification/document
- POST /verification/refresh
- POST /verification/eligibility
- POST /verification/webhook (provider → backend)
- GET  /verification/status
- POST /verification/stub-complete (non-production stub only)

## Availability
- POST /availability/start
- POST /availability/pause
- POST /availability/stop
- GET  /availability/nearby?category=&geo=&radius=

## Requests (draft + vetting gate)
- POST /requests/draft
- PATCH /requests/draft/{id}
- POST /requests/draft/{id}/submit (→ pending vetting)
- GET  /requests/nearby (vetted only)
- POST /requests/{id}/cancel
- POST /requests/{id}/accept (helper accepts → creates session)

## Sessions
- GET  /sessions/{id}
- POST /sessions/{id}/end
- POST /sessions/{id}/consent (update share toggles)
- POST /sessions/{id}/location (precise, session-only)

## Chat
- GET  /sessions/{id}/messages
- POST /sessions/{id}/messages

## Reports
- POST /reports
- GET  /reports/mine

## Public analytics (Humanity Pulse)
- GET /public/pulse/summary
- GET /public/pulse/timeseries?region=&range=
- GET /public/pulse/categories?region=&range=
