# Code Review & Best Practices — Agent Rules

## Non-negotiables
- No request becomes visible before vetting passes.
- No precise location shared without:
  - active session
  - explicit consent
- No logging PII (names, exact coordinates, chat bodies).
- Adults-only + verified-only enforcement must exist server-side (not just UI).

## Riverpod standards
- Providers are DI + state only
- Business rules live in use-cases (application layer)
- DTO/domain mapping is tested
- Avoid provider spaghetti: group by feature module

## Required engineering standards
- Feature-first module boundaries maintained
- Use-cases own business logic (not Widgets)
- All network calls typed and validated (DTO ↔ domain mapping)
- Error handling is explicit and user-friendly
- No debug logs containing PII

## Security rules
- All reads/writes are authorized
- Session data accessible only to the two participants + moderation service
- Media access locked down (signed URLs or strict ACLs)
- Rate limit endpoints susceptible to abuse

## PR checklist
- [ ] Tests added/updated
- [ ] No new PII stored unintentionally
- [ ] Consent and permission prompts unchanged or improved
- [ ] TTL/cleanup considered for any new collection/table
- [ ] Analytics events do not include user identifiers for public datasets
- [ ] Performance: no N+1 queries, no unbounded listeners
- [ ] Accessibility: labels, tap targets, readable contrast
