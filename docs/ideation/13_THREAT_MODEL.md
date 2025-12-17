# Threat Model (practical)

## Key threats and mitigations

### 1) Stalking / location abuse
Mitigations:
- approximate discovery until match
- precise location only during active session + consent + TTL
- block user instantly; end session instantly
- prevent repeated “pinging” via rate limits

### 2) Fake accounts / impersonation
Mitigations:
- mandatory ID verification
- webhook-validated verification result
- ban evasion resistance (privacy-preserving device/account signals)
- edge bot protection (WAF)

### 3) Scam requests
Mitigations:
- disallow money transfer requests
- **Automated Vetting Pipeline:**
    - Regex pattern blocks for crypto/cashapp
    - LLM-based intent analysis (anti-script detection)
- education prompts + official reporting routes

### 4) Harassment in chat (Proactive Defense)
Mitigations:
- **Toxicity Detection:** Real-time ML scores every message. High toxicity (threats, slurs) is **blocked before delivery**.
- **Link/Phone Mitigation:** Regex detection for phone numbers and URLs.
    - *Warning Mode:* Prompt user "For safety, keep chat in-app" (sender sees warning).
    - *Block Mode:* High-risk account/context results in message block.
- Session-only chat + auto-lock on end.
- Report from chat screen.

### 5) Coordinated abuse / brigading reports
Mitigations:
- credibility scoring for reports
- evidence required for severe penalties
- appeal process
- human moderation for high-impact actions

### 6) Public analytics re-identification
Mitigations:
- minimum thresholds per region/time bucket
- coarse geographies
- suppress small counts
- do not publish raw event streams
