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
exports.VettingListener = void 0;
const common_1 = require("@nestjs/common");
const event_emitter_1 = require("@nestjs/event-emitter");
const request_created_event_1 = require("../requests/events/request-created.event");
const vetting_service_1 = require("./vetting.service");
let VettingListener = class VettingListener {
    vettingService;
    constructor(vettingService) {
        this.vettingService = vettingService;
    }
    async handleRequestCreatedEvent(event) {
        const textToVet = `${event.title} ${event.description}`;
        await this.vettingService.vetRequest(event.requestId, textToVet);
    }
};
exports.VettingListener = VettingListener;
__decorate([
    (0, event_emitter_1.OnEvent)('request.created'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [request_created_event_1.RequestCreatedEvent]),
    __metadata("design:returntype", Promise)
], VettingListener.prototype, "handleRequestCreatedEvent", null);
exports.VettingListener = VettingListener = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [vetting_service_1.VettingService])
], VettingListener);
//# sourceMappingURL=vetting.listener.js.map