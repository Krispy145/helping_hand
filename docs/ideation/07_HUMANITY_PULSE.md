# Humanity Pulse — Updated Triggers & Reflections

## What we measure (aggregate only)
- Positive verified outcomes (sessions completed, consented positive posts)
- Negative signals:
  - credible misconduct reports
  - rejected malicious request attempts (“harm intent”)
  - scam/theft victim reports as societal harm indicators (not victim blame)

## Key distinction (avoid victim-blame)
Victim reports (e.g., “I was scammed”) should:
- increase *societal harm indicators*,
- NOT automatically penalize the victim’s personal trust/risk score.

## Trigger-driven routing (in-app)
If a request/report suggests:
- immediate danger → show emergency call options
- non-emergency crime → show police non-emergency route
- fraud/cybercrime → show official fraud reporting route
- suicidal ideation → show crisis helpline route

Log these as **anonymous aggregate counters** (“support routing events”)
to show how often communities are hitting crisis points — without exposing identities.

## Scoring philosophy (non-gamified)
- No public individual scores
- Use an internal **Risk/Trust score** only for safety gating:
  - eligibility for matching
  - rate limits
  - manual review escalation
