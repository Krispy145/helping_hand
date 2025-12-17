# Data Model (suggested)

## Users (minimal)
User {
  id: string
  displayName: string
  photoUrl?: string
  verificationStatus: "unverified" | "pending" | "verified" | "failed"
  safetyRiskScore: number (internal)
  createdAt, updatedAt
}

## Availability (ephemeral)
Availability {
  id
  userId
  categories: string[]
  geoHashApprox
  radiusMeters
  startsAt, endsAt (TTL)
  status: "active" | "paused" | "expired"
}

## HelpRequestDraft (private)
HelpRequestDraft {
  id
  requesterId
  category
  description
  geoHashApprox
  timeframe: { earliestStart, latestEnd }
  attachments?
  status: "draft" | "pending_vetting" | "rejected" | "approved"
  createdAt, updatedAt
}

## HelpRequestVetted (visible)
HelpRequestVetted {
  id
  draftId
  requesterId
  category
  descriptionRedacted?   // optional safer summary
  geoHashApprox
  timeframe
  status: "open" | "matched" | "cancelled" | "expired"
  createdAt
}

## Session (match)
Session {
  id
  requestId
  helperId
  helpeeId
  status: "active" | "completed" | "ended_early" | "disputed"
  consent: {
    sharePreciseLocation: boolean
    shareDisplayName: boolean
    mediaPostingAllowed: boolean
  }
  preciseLocation?: { lat, lng } (TTL + access restriction)
  startedAt, endedAt
}

## ChatMessage (session-scoped)
ChatMessage {
  id
  sessionId
  senderId
  body
  createdAt
  moderationFlags?: string[]
}

## Post (positivity feed)
Post {
  id
  sessionId?
  authorId
  mediaUrls?
  text
  consentedUserIds: string[]  // must include all visible individuals
  visibility: "public" | "community" | "private"
  createdAt
}

## Report
Report {
  id
  reporterId
  targetUserId?
  sessionId?
  type: "helper_abuse" | "helpee_abuse" | "scam" | "theft" | "minor_inhumanity" | ...
  severity: "low" | "medium" | "high"
  description
  evidenceUrls?
  status: "new" | "triaged" | "actioned" | "rejected"
  createdAt
}

## SafetyIncident (system-generated)
SafetyIncident {
  id
  userId
  source: "request_vetting" | "rate_limit" | "report_pattern"
  reasonCode
  detailsRedacted?
  createdAt
}
