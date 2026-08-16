"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SessionController = void 0;
const common_1 = require("@nestjs/common");
const passport_1 = require("@nestjs/passport");
const session_service_1 = require("./session.service");
let SessionController = class SessionController {
    sessionService;
    constructor(sessionService) {
        this.sessionService = sessionService;
    }
    async createSession(req, requestId) {
        if (!requestId)
            throw new common_1.BadRequestException('requestId is required');
        return this.sessionService.createSession(requestId, req.user.userId);
    }
    async getMySessions(req) {
        return this.sessionService.getUserSessions(req.user.userId);
    }
    async checkAvailability(req, requestId) {
        if (!requestId)
            throw new common_1.BadRequestException('requestId is required');
        return this.sessionService.checkOfferAvailability(requestId, req.user.userId);
    }
    async cancelAssist(req, sessionId) {
        return this.sessionService.cancelAssist(sessionId, req.user.userId);
    }
    async completeAssist(req, sessionId) {
        return this.sessionService.completeAssist(sessionId, req.user.userId);
    }
    async getSessionMessages(req, sessionId) {
        return this.sessionService.getMessages(sessionId, req.user.userId);
    }
    async getSession(req, sessionId) {
        return this.sessionService.getSession(sessionId, req.user.userId);
    }
};
exports.SessionController = SessionController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('requestId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "createSession", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "getMySessions", null);
__decorate([
    (0, common_1.Get)('availability'),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Query)('requestId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "checkAvailability", null);
__decorate([
    (0, common_1.Post)(':id/cancel'),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "cancelAssist", null);
__decorate([
    (0, common_1.Post)(':id/complete'),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "completeAssist", null);
__decorate([
    (0, common_1.Get)(':id/messages'),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "getSessionMessages", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], SessionController.prototype, "getSession", null);
exports.SessionController = SessionController = __decorate([
    (0, common_1.Controller)('sessions'),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    __metadata("design:paramtypes", [session_service_1.SessionService])
], SessionController);
//# sourceMappingURL=session.controller.js.map