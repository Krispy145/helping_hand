# Privacy & Data Minimization

## Principle
Store the minimum data required to operate the system safely.

## Data classes
### On-device only (preferred)
- Full legal name / ID details (never stored by Helping Hand backend)
- Personal notes / wellbeing preferences
- Trusted contacts (if implemented)

### Backend (minimal)
- Stable internal user ID
- Verification status + provider reference token (not raw ID docs)
- Display name (non-legal)
- Session/event records (time-bounded, access-controlled)
- Reports and moderation actions (with retention limits)

### Shared per-session (consented)
- Precise location during session window
- Display name
- Optional: temporary session contact token

## Retention policy (suggested)
- Availability pings: minutes-hours (auto-expire)
- Precise session location: only during session + short grace period (e.g., 24h) for disputes
- Chat messages: session duration + limited retention (e.g., 30 days) unless reported
- Reports: longer retention (e.g., 1–2 years) for safety/legal needs
- Analytics: aggregated, anonymized, thresholded

## Encryption
- In transit: TLS everywhere
- At rest: provider-managed encryption
- Later: consider E2EE for chat

## Privacy risks to mitigate
- Re-identification in small areas: thresholds + coarse geobins for public dashboards
- Location stalking: approximate discovery until match; session-only precision sharing; block/hide
