# Observability & Operations

## What to log (safely)
- request/session lifecycle events (IDs only)
- vetting outcomes (reason codes, redacted)
- moderation actions and reason codes
- error traces without PII
- rate limit triggers

## What NOT to log
- exact GPS coordinates
- chat message bodies
- legal identity details
- evidence media contents

## Metrics
- time to vet (draft submit → decision)
- time to match
- session completion rate
- report rate per 100 sessions
- dispute resolution time
- retention of helpers/helpees
- % requests rejected by vetting

## Alerts
- spike in rejected drafts (possible abuse wave)
- spike in reports
- spike in failed verification webhooks
- abnormal request bursts in a region
- elevated crash rate
