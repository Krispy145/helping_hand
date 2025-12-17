# Request Vetting & Safety Gating (Automated)

## Why vetting exists
Helping Hand must prevent:
- malicious lures (robbery/assault setups)
- scam solicitation
- coercion/harassment
- illegal or unsafe assistance requests

## Core rule
**No request reaches helpers until it is vetted.**

---

## Automated Vetting Pipeline (Real-Time)

To ensure scalability and speed, vetting is **100% automated** in the MVP, using a multi-stage AI pipeline. Human moderators only review *appeals*, not the initial queue.

### Stage 1: Deterministic Filters (Latency: <10ms)
*Rejects obvious violations instantly.*
- **Regex & Keyword Blocklist:**
    - Block crypto wallet addresses, known scam URL patterns.
    - Block slurs, rigorous profanity, and hate speech matching.
    - Block "money blocked" terms (e.g., "cashapp", "venmo", "send money").
- **PII Leak Protection:**
    - Auto-reject if request contains phone numbers, email addresses, or social handles (users must use in-app chat).
    - **Outcome:** Immediate Rejection with specific error ("Please remove phone numbers...").

### Stage 2: ML & Toxicity Classifiers (Latency: ~100ms)
*Checks for tone/harm.*
- **Toxicity Scoring:** (e.g., Perspective API, OpenAI Moderation, or local BERT model)
    - Scores for: `Severe Toxicity`, `Threat`, `Self-Harm`, `Sexual`.
    - **Thresholds:**
        - High score (>0.8): **Auto-Reject**.
        - Medium score (0.5-0.8): **Flag for Stage 3**.
        - Low score: **Pass to Stage 3** (or Auto-Approve if trusted user).

### Stage 3: Contextual LLM Analysis (Latency: ~1-2s)
*Understanding intent.*
- **Model:** Fast, reasoning-capable LLM (e.g., GPT-4o-mini, Gemini Flash, Claude Haiku).
- **System Prompt:** Analyzes the *intent* of the request against specific Safety Policy rules.
    - *Is this a request for accommodation?* (Reject -> "Place to stay not allowed in MVP").
    - *Is this a romantic/sexual solicitation?* (Reject).
    - *Is this a lure unrelated to help?* (Reject).
    - *Does this look like a scam script?* (Reject).
- **Outcome:**
    - **Approved:** Becomes visible to helpers.
    - **Rejected:** User receives a polite, specific reason + alternatives.
    - **Unsure:** (Rare) Defaults to Rejected for MVP safety, or triggers "Try again with more detail".

---

## Outcomes & Consequences

### Approved
- Helper discovery uses only approximate geo until accepted.
- Helper can accept/decline.

### Rejected (Malicious/Policy Violation)
- Request never visible to helpers.
- **Shadow-ban potential:** If high confidence of malice (e.g., "robbery lure"), the user is silently flagged, and future requests are auto-rejected or delayed.
- **Resources:** If rejected for "Mental Health/Crisis" text, immediately show the **Humanity Support UI** with local helpline numbers.

### Appeals
- User can appeal a rejection *once*.
- Appeals go to a human moderation queue (async, SLA 24h).
- If appeal wins: Request is reinstated + System learns (fine-tuning dataset).

---

## Safety Incident Records
All vetting rejections generate a `SafetyIncident` record containing:
- `original_text`
- `triggered_rule` (e.g., "Stage 3: Accommodation Policy")
- `confidence_score`
- These records feed the **user risk profile**.
