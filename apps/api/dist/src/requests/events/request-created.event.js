"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RequestCreatedEvent = void 0;
class RequestCreatedEvent {
    requestId;
    title;
    description;
    constructor(requestId, title, description) {
        this.requestId = requestId;
        this.title = title;
        this.description = description;
    }
}
exports.RequestCreatedEvent = RequestCreatedEvent;
//# sourceMappingURL=request-created.event.js.map