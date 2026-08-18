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
exports.ReportsService = void 0;
const common_1 = require("@nestjs/common");
const client_1 = require("@prisma/client");
const prisma_service_1 = require("../infrastructure/persistence/prisma/prisma.service");
const public_serializers_1 = require("../common/public-serializers");
const VICTIM_REPORT_TYPES = [client_1.ReportType.SCAM, client_1.ReportType.THEFT];
const HIGH_SEVERITY_TYPES = [
    client_1.ReportType.SCAM,
    client_1.ReportType.THEFT,
    client_1.ReportType.UNSAFE_SITUATION,
];
let ReportsService = class ReportsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(reporterId, dto) {
        const description = dto.description?.trim() ?? '';
        if (description.length < 10) {
            throw new common_1.BadRequestException('Please describe what happened in a bit more detail.');
        }
        if (!dto.sessionId && !dto.requestId && !dto.targetUserId) {
            throw new common_1.BadRequestException('A report must include a session, request, or person.');
        }
        const session = dto.sessionId
            ? await this.prisma.session.findUnique({
                where: { id: dto.sessionId },
                include: { request: true, helper: true },
            })
            : null;
        if (dto.sessionId && !session) {
            throw new common_1.NotFoundException('Session not found');
        }
        if (session &&
            session.helperId !== reporterId &&
            session.request.userId !== reporterId) {
            throw new common_1.ForbiddenException('You can only report a chat you are part of');
        }
        const requestId = dto.requestId ?? session?.requestId;
        const request = requestId
            ? await this.prisma.request.findUnique({ where: { id: requestId } })
            : null;
        if (requestId && !request) {
            throw new common_1.NotFoundException('Request not found');
        }
        const targetUserId = this.resolveTargetUserId(reporterId, dto, session, request);
        if (targetUserId === reporterId) {
            throw new common_1.ForbiddenException('You cannot report yourself');
        }
        const endSession = dto.endSession !== false && session?.status === client_1.SessionStatus.ACTIVE;
        const severity = HIGH_SEVERITY_TYPES.includes(dto.type)
            ? client_1.ReportSeverity.HIGH
            : client_1.ReportSeverity.MEDIUM;
        try {
            const report = await this.prisma.$transaction(async (tx) => {
                const created = await tx.report.create({
                    data: {
                        reporterId,
                        targetUserId,
                        sessionId: session?.id,
                        requestId: request?.id,
                        type: dto.type,
                        severity,
                        description,
                        evidenceUrls: dto.evidenceUrls ?? [],
                        sessionEnded: endSession,
                    },
                });
                if (targetUserId) {
                    await tx.safetyIncident.create({
                        data: {
                            userId: targetUserId,
                            source: client_1.SafetyIncidentSource.REPORT_PATTERN,
                            reasonCode: dto.type,
                            detailsRedacted: this.redactIncidentDetails(dto.type),
                            reportId: created.id,
                            requestId: request?.id,
                        },
                    });
                }
                if (endSession && session) {
                    await tx.session.update({
                        where: { id: session.id },
                        data: { status: client_1.SessionStatus.DISPUTED },
                    });
                    await tx.request.update({
                        where: { id: session.requestId },
                        data: {
                            status: this.requestStatusAfterReport(dto.type),
                        },
                    });
                }
                return created;
            });
            return (0, public_serializers_1.toPublicReport)(report);
        }
        catch (error) {
            if (error instanceof client_1.Prisma.PrismaClientKnownRequestError &&
                error.code === 'P2002') {
                throw new common_1.ConflictException('You have already reported this.');
            }
            throw error;
        }
    }
    async findMine(reporterId) {
        const reports = await this.prisma.report.findMany({
            where: { reporterId },
            orderBy: { createdAt: 'desc' },
            take: 50,
        });
        return reports.map((report) => (0, public_serializers_1.toPublicReport)(report));
    }
    resolveTargetUserId(reporterId, dto, session, request) {
        if (dto.targetUserId)
            return dto.targetUserId;
        if (session) {
            return session.helperId === reporterId
                ? session.request.userId
                : session.helperId;
        }
        if (request && request.userId !== reporterId) {
            return request.userId;
        }
        return undefined;
    }
    requestStatusAfterReport(type) {
        if (type === client_1.ReportType.HELPER_MISCONDUCT) {
            return client_1.RequestStatus.APPROVED;
        }
        return client_1.RequestStatus.CANCELLED;
    }
    redactIncidentDetails(type) {
        if (VICTIM_REPORT_TYPES.includes(type)) {
            return 'Victim harm report against another user. Reporter is not penalized.';
        }
        return 'User report filed against this account.';
    }
};
exports.ReportsService = ReportsService;
exports.ReportsService = ReportsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ReportsService);
//# sourceMappingURL=reports.service.js.map