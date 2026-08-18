type PublicUserSource = {
  id: string;
  email: string;
  name?: string | null;
  role: string;
  verificationStatus?: string | null;
  verifiedAt?: Date | null;
  verificationFailureReason?: string | null;
  createdAt: Date;
  updatedAt: Date;
};

type PublicRequestSource = {
  id: string;
  title: string;
  description: string;
  category?: string | null;
  status: string;
  urgency: string;
  lat?: number | null;
  lng?: number | null;
  approxLat?: number | null;
  approxLng?: number | null;
  createdAt: Date;
  updatedAt: Date;
  user?: PublicUserSource | null;
};

export function toPublicUser(
  user: PublicUserSource,
  options?: { includeEmail?: boolean },
) {
  return {
    id: user.id,
    email: options?.includeEmail ? user.email : '',
    name: user.name,
    role: user.role,
    verification_status: user.verificationStatus ?? 'UNVERIFIED',
    verified_at: options?.includeEmail ? (user.verifiedAt ?? null) : undefined,
    verification_failure_reason: options?.includeEmail
      ? (user.verificationFailureReason ?? null)
      : undefined,
    created_at: user.createdAt,
    updated_at: user.updatedAt,
  };
}

export function toPublicRequest(
  request: PublicRequestSource,
  options?: { includeRequester?: boolean },
) {
  return {
    id: request.id,
    title: request.title,
    description: request.description,
    category: request.category,
    status: request.status,
    urgency: request.urgency,
    lat: request.approxLat ?? null,
    lng: request.approxLng ?? null,
    created_at: request.createdAt,
    updated_at: request.updatedAt,
    user:
      options?.includeRequester && request.user
        ? toPublicUser(request.user, { includeEmail: false })
        : undefined,
  };
}

type PublicReportSource = {
  id: string;
  type: string;
  severity: string;
  description: string;
  status: string;
  sessionId?: string | null;
  requestId?: string | null;
  targetUserId?: string | null;
  sessionEnded: boolean;
  createdAt: Date;
};

export function toPublicReport(report: PublicReportSource) {
  return {
    id: report.id,
    type: report.type,
    severity: report.severity,
    description: report.description,
    status: report.status,
    session_id: report.sessionId ?? null,
    request_id: report.requestId ?? null,
    target_user_id: report.targetUserId ?? null,
    session_ended: report.sessionEnded,
    penalizes_reporter: false,
    created_at: report.createdAt,
  };
}
