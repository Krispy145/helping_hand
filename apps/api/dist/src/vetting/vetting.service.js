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
var VettingService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.VettingService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../infrastructure/persistence/prisma/prisma.service");
const client_1 = require("@prisma/client");
let VettingService = VettingService_1 = class VettingService {
    prisma;
    logger = new common_1.Logger(VettingService_1.name);
    restrictedKeywords = [
        'scam',
        'money',
        'bank transfer',
        'password',
        'credit card',
        'gift card',
        'crypto',
        'bitcoin',
    ];
    constructor(prisma) {
        this.prisma = prisma;
    }
    async vetRequest(requestId, textToVet) {
        this.logger.log(`Vetting request ${requestId}`);
        const normalizedText = textToVet.toLowerCase();
        const hasRestrictedContent = this.restrictedKeywords.some((keyword) => normalizedText.includes(keyword));
        const newStatus = hasRestrictedContent
            ? client_1.RequestStatus.REJECTED
            : client_1.RequestStatus.APPROVED;
        await this.prisma.request.update({
            where: { id: requestId },
            data: { status: newStatus },
        });
        if (hasRestrictedContent) {
            const request = await this.prisma.request.findUnique({
                where: { id: requestId },
                select: { userId: true },
            });
            if (request) {
                await this.prisma.safetyIncident.create({
                    data: {
                        userId: request.userId,
                        source: client_1.SafetyIncidentSource.REQUEST_VETTING,
                        reasonCode: 'RESTRICTED_CONTENT',
                        detailsRedacted: 'Keyword filter matched restricted content.',
                        requestId,
                    },
                });
            }
        }
        this.logger.log(`Request ${requestId} vetted. Status: ${newStatus} ${hasRestrictedContent ? '(Restricted content found)' : ''}`);
    }
};
exports.VettingService = VettingService;
exports.VettingService = VettingService = VettingService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], VettingService);
//# sourceMappingURL=vetting.service.js.map