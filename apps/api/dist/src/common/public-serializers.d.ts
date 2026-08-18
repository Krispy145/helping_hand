type PublicUserSource = {
    id: string;
    email: string;
    name?: string | null;
    role: string;
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
    createdAt: Date;
    updatedAt: Date;
    user?: PublicUserSource | null;
};
export declare function toPublicUser(user: PublicUserSource, options?: {
    includeEmail?: boolean;
}): {
    id: string;
    email: string;
    name: string | null | undefined;
    role: string;
    created_at: Date;
    updated_at: Date;
};
export declare function toPublicRequest(request: PublicRequestSource, options?: {
    includeRequester?: boolean;
}): {
    id: string;
    title: string;
    description: string;
    category: string | null | undefined;
    status: string;
    urgency: string;
    lat: number | null | undefined;
    lng: number | null | undefined;
    created_at: Date;
    updated_at: Date;
    user: {
        id: string;
        email: string;
        name: string | null | undefined;
        role: string;
        created_at: Date;
        updated_at: Date;
    } | undefined;
};
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
export declare function toPublicReport(report: PublicReportSource): {
    id: string;
    type: string;
    severity: string;
    description: string;
    status: string;
    session_id: string | null;
    request_id: string | null;
    target_user_id: string | null;
    session_ended: boolean;
    penalizes_reporter: boolean;
    created_at: Date;
};
export {};
