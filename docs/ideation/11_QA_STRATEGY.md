# QA Strategy

## Quality goals
- Safety-critical UX correctness (permissions, consent, reporting, urgent routing)
- Reliability in vetting + matching + session lifecycle
- Privacy: no unintended data persistence or leakage
- Performance: fast discovery and chat

## Test pyramid
### Unit tests (lots)
- domain entities, use-cases, risk rules
- vetting rule engine
- permission/consent gating logic
- TTL/expiry logic for availability + sessions

### Integration tests (some)
- draft → submit → vetting approve/reject
- request → accept → session → chat → end
- report creation → moderation pipeline (mocked)

### E2E tests (few but essential)
- onboarding + verification gating
- request help with vetting outcomes
- consent prompts and location sharing
- urgent help routing surfaces at the right time

## Release gates (non-negotiable)
- No crashes in smoke flows
- Adults-only + verified-only enforced server-side
- Vetting gate proven (cannot bypass via direct API calls)
- Approx location for discovery; precise only after match + consent
- Session auto-ends at expiry; chat locks after end
- Reports can be submitted even if media upload fails
- Public dashboard endpoints verified to not expose PII

## Regression checklist (every release)
- Unverified user cannot request or offer help
- Rejected malicious drafts are not visible, and create incidents
- “Get urgent help” always reachable
- Posts require consented individuals list
- Rate limiting works for spam requests/reports/messages

## Device matrix (minimum)
- iPhone: current + one older iOS version
- Android: one Pixel-like + one Samsung-like
- Optional: Web build with careful location + auth UX
