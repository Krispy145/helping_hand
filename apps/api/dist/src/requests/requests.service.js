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
exports.RequestsService = void 0;
const common_1 = require("@nestjs/common");
const event_emitter_1 = require("@nestjs/event-emitter");
const request_created_event_1 = require("./events/request-created.event");
const prisma_service_1 = require("../infrastructure/persistence/prisma/prisma.service");
const client_1 = require("@prisma/client");
let RequestsService = class RequestsService {
    prisma;
    eventEmitter;
    constructor(prisma, eventEmitter) {
        this.prisma = prisma;
        this.eventEmitter = eventEmitter;
    }
    async create(userId, dto) {
        const request = await this.prisma.request.create({
            data: {
                userId,
                title: dto.title,
                description: dto.description,
                category: dto.category,
                urgency: dto.urgency,
                lat: dto.lat,
                lng: dto.lng,
                status: client_1.RequestStatus.PENDING_VETTING,
            },
            include: {
                user: true,
            },
        });
        this.eventEmitter.emit('request.created', new request_created_event_1.RequestCreatedEvent(request.id, request.title, request.description));
        return request;
    }
    async findAll() {
        return this.prisma.request.findMany({
            include: { user: true },
            orderBy: { createdAt: 'desc' },
        });
    }
};
exports.RequestsService = RequestsService;
exports.RequestsService = RequestsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        event_emitter_1.EventEmitter2])
], RequestsService);
//# sourceMappingURL=requests.service.js.map