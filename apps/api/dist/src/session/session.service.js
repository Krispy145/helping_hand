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
Object.defineProperty(exports, "__esModule", { value: true });
exports.SessionService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../infrastructure/persistence/prisma/prisma.service");
const client_1 = require("@prisma/client");
let SessionService = class SessionService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async createSession(requestId, helperId) {
        const request = await this.prisma.request.findUnique({ where: { id: requestId } });
        if (!request)
            throw new common_1.NotFoundException('Request not found');
        return this.prisma.session.create({
            data: {
                requestId,
                helperId,
                status: client_1.SessionStatus.ACTIVE,
            },
        });
    }
    async saveMessage(sessionId, senderId, content) {
        const session = await this.prisma.session.findUnique({ where: { id: sessionId } });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        if (session.status !== client_1.SessionStatus.ACTIVE)
            throw new common_1.ForbiddenException('Session is not active');
        return this.prisma.message.create({
            data: {
                sessionId,
                senderId,
                content,
            },
        });
    }
    async getMessages(sessionId, userId) {
        const session = await this.prisma.session.findUnique({
            where: { id: sessionId },
            include: { request: true }
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        if (session.helperId !== userId && session.request.userId !== userId) {
            throw new common_1.ForbiddenException('You are not a participant in this session');
        }
        return this.prisma.message.findMany({
            where: { sessionId },
            orderBy: { createdAt: 'asc' },
        });
    }
    async getUserSessions(userId) {
        return this.prisma.session.findMany({
            where: {
                OR: [
                    { helperId: userId },
                    { request: { userId: userId } }
                ]
            },
            include: {
                request: true,
                helper: { select: { id: true, name: true } }
            },
            orderBy: { updatedAt: 'desc' }
        });
    }
};
exports.SessionService = SessionService;
exports.SessionService = SessionService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SessionService);
//# sourceMappingURL=session.service.js.map