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
    async checkOfferAvailability(requestId, helperId) {
        const request = await this.prisma.request.findUnique({
            where: { id: requestId },
            include: { session: true },
        });
        if (!request)
            throw new common_1.NotFoundException('Request not found');
        return this.offerAvailabilityFor(request, helperId);
    }
    async createSession(requestId, helperId) {
        try {
            const sessionId = await this.prisma.$transaction(async (tx) => {
                await tx.$queryRaw `SELECT id FROM "Request" WHERE id = ${requestId} FOR UPDATE`;
                const request = await tx.request.findUnique({
                    where: { id: requestId },
                    include: { session: true, user: true },
                });
                if (!request)
                    throw new common_1.NotFoundException('Request not found');
                const availability = this.offerAvailabilityFor(request, helperId);
                if (availability.sessionId) {
                    return availability.sessionId;
                }
                if (!availability.open) {
                    if (availability.busy) {
                        throw new common_1.ConflictException('This request is already busy');
                    }
                    if (availability.reason === 'own_request') {
                        throw new common_1.ForbiddenException('You cannot assist your own request');
                    }
                    throw new common_1.ForbiddenException('This request is not open for help');
                }
                const helper = await tx.user.findUnique({ where: { id: helperId } });
                if (!helper)
                    throw new common_1.NotFoundException('Helper not found');
                const created = await tx.session.create({
                    data: {
                        requestId,
                        helperId,
                        status: client_1.SessionStatus.ACTIVE,
                    },
                });
                await tx.message.create({
                    data: {
                        sessionId: created.id,
                        senderId: request.userId,
                        content: this.buildRequestIntro(request),
                    },
                });
                await tx.request.update({
                    where: { id: requestId },
                    data: { status: client_1.RequestStatus.IN_PROGRESS },
                });
                return created.id;
            });
            const request = await this.prisma.request.findUnique({ where: { id: requestId } });
            if (request) {
                await this.ensureRequestIntroMessage(sessionId, request);
            }
            return this.getSession(sessionId, helperId);
        }
        catch (error) {
            if (error instanceof client_1.Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
                throw new common_1.ConflictException('This request is already busy');
            }
            throw error;
        }
    }
    async getSession(sessionId, userId) {
        const session = await this.prisma.session.findUnique({
            where: { id: sessionId },
            include: {
                request: { include: { user: true } },
                helper: true,
            },
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        this.assertParticipant(session, userId);
        return {
            id: session.id,
            requestId: session.requestId,
            helperId: session.helperId,
            status: session.status,
            request: {
                title: session.request.title,
                description: session.request.description,
                category: session.request.category,
                urgency: session.request.urgency,
                status: session.request.status,
            },
            requester: {
                id: session.request.user.id,
                name: session.request.user.name,
            },
            helper: {
                id: session.helper.id,
                name: session.helper.name,
            },
        };
    }
    async saveMessage(sessionId, senderId, content) {
        const session = await this.prisma.session.findUnique({
            where: { id: sessionId },
            include: { request: true },
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        if (session.status !== client_1.SessionStatus.ACTIVE)
            throw new common_1.ForbiddenException('Session is not active');
        this.assertParticipant(session, senderId);
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
            include: { request: true },
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        this.assertParticipant(session, userId);
        await this.ensureRequestIntroMessage(sessionId, session.request);
        return this.prisma.message.findMany({
            where: { sessionId },
            orderBy: { createdAt: 'asc' },
        });
    }
    async cancelAssist(sessionId, userId) {
        const session = await this.prisma.session.findUnique({
            where: { id: sessionId },
            include: { request: true },
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        this.assertParticipant(session, userId);
        if (session.status !== client_1.SessionStatus.ACTIVE) {
            throw new common_1.ForbiddenException('This session is no longer active');
        }
        await this.prisma.$transaction(async (tx) => {
            await tx.message.deleteMany({ where: { sessionId } });
            await tx.session.delete({ where: { id: sessionId } });
            await tx.request.update({
                where: { id: session.requestId },
                data: { status: client_1.RequestStatus.APPROVED },
            });
        });
        return { status: 'CANCELLED', requestStatus: client_1.RequestStatus.APPROVED };
    }
    async completeAssist(sessionId, userId) {
        const session = await this.prisma.session.findUnique({
            where: { id: sessionId },
            include: { request: true },
        });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        this.assertParticipant(session, userId);
        if (session.status !== client_1.SessionStatus.ACTIVE) {
            throw new common_1.ForbiddenException('This session is no longer active');
        }
        await this.prisma.$transaction(async (tx) => {
            await tx.session.update({
                where: { id: sessionId },
                data: { status: client_1.SessionStatus.COMPLETED },
            });
            await tx.request.update({
                where: { id: session.requestId },
                data: { status: client_1.RequestStatus.COMPLETED },
            });
        });
        return this.getSession(sessionId, userId);
    }
    async getUserSessions(userId) {
        const sessions = await this.prisma.session.findMany({
            where: {
                status: client_1.SessionStatus.ACTIVE,
                OR: [{ helperId: userId }, { request: { userId: userId } }],
            },
            include: {
                request: { include: { user: true } },
                helper: true,
            },
            orderBy: { updatedAt: 'desc' },
        });
        return sessions.map((session) => ({
            id: session.id,
            requestId: session.requestId,
            helperId: session.helperId,
            status: session.status,
            request: {
                title: session.request.title,
                description: session.request.description,
                category: session.request.category,
                urgency: session.request.urgency,
                status: session.request.status,
            },
            requester: {
                id: session.request.user.id,
                name: session.request.user.name,
            },
            helper: {
                id: session.helper.id,
                name: session.helper.name,
            },
        }));
    }
    offerAvailabilityFor(request, helperId) {
        const activeSession = request.session?.status === client_1.SessionStatus.ACTIVE ? request.session : null;
        if (request.userId === helperId) {
            if (activeSession) {
                return {
                    open: false,
                    busy: true,
                    reason: 'own_request',
                    sessionId: activeSession.id,
                };
            }
            return { open: false, busy: false, reason: 'own_request' };
        }
        if (activeSession) {
            if (activeSession.helperId === helperId) {
                return {
                    open: false,
                    busy: true,
                    reason: 'already_helping',
                    sessionId: activeSession.id,
                };
            }
            return { open: false, busy: true, reason: 'busy' };
        }
        if (request.status === client_1.RequestStatus.IN_PROGRESS) {
            return { open: false, busy: true, reason: 'busy' };
        }
        if (request.status !== client_1.RequestStatus.APPROVED) {
            return { open: false, busy: false, reason: 'not_open' };
        }
        return { open: true, busy: false, reason: 'open' };
    }
    assertParticipant(session, userId) {
        if (session.helperId !== userId && session.request.userId !== userId) {
            throw new common_1.ForbiddenException('You are not a participant in this session');
        }
    }
    buildRequestIntro(request) {
        const lines = [request.title, '', request.description];
        const meta = [
            request.category ? `Category: ${request.category}` : null,
            `Urgency: ${request.urgency}`,
        ].filter(Boolean);
        if (meta.length > 0) {
            lines.push('', meta.join(' · '));
        }
        return lines.join('\n');
    }
    async ensureRequestIntroMessage(sessionId, request) {
        const existing = await this.prisma.message.count({ where: { sessionId } });
        if (existing > 0)
            return;
        await this.prisma.message.create({
            data: {
                sessionId,
                senderId: request.userId,
                content: this.buildRequestIntro(request),
            },
        });
    }
};
exports.SessionService = SessionService;
exports.SessionService = SessionService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SessionService);
//# sourceMappingURL=session.service.js.map