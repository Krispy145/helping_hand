"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toPublicUser = toPublicUser;
exports.toPublicRequest = toPublicRequest;
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
//# sourceMappingURL=public-serializers.js.map