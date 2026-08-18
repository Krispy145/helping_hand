"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toPublicUser = toPublicUser;
exports.toPublicRequest = toPublicRequest;
exports.toPublicReport = toPublicReport;
function toPublicUser(user, options) {
    return {
        id: user.id,
        email: options?.includeEmail ? user.email : '',
        name: user.name,
        role: user.role,
        created_at: user.createdAt,
        updated_at: user.updatedAt,
    };
}
function toPublicRequest(request, options) {
    return {
        id: request.id,
        title: request.title,
        description: request.description,
        category: request.category,
        status: request.status,
        urgency: request.urgency,
        lat: request.lat,
        lng: request.lng,
        created_at: request.createdAt,
        updated_at: request.updatedAt,
        user: options?.includeRequester && request.user
            ? toPublicUser(request.user, { includeEmail: false })
            : undefined,
    };
}
function toPublicReport(report) {
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
//# sourceMappingURL=public-serializers.js.map