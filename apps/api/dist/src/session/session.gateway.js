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
exports.SessionGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const socket_io_1 = require("socket.io");
const session_service_1 = require("./session.service");
let SessionGateway = class SessionGateway {
    sessionService;
    server;
    constructor(sessionService) {
        this.sessionService = sessionService;
    }
    handleConnection(client) {
    }
    handleDisconnect(client) {
    }
    async handleJoinSession(data, client) {
        client.join(`session_${data.sessionId}`);
        return { event: 'joined', sessionId: data.sessionId };
    }
    async handleSendMessage(data, client) {
        const message = await this.sessionService.saveMessage(data.sessionId, data.senderId, data.content);
        this.server.to(`session_${data.sessionId}`).emit('new_message', message);
        return message;
    }
};
exports.SessionGateway = SessionGateway;
__decorate([
    (0, websockets_1.WebSocketServer)(),
    __metadata("design:type", socket_io_1.Server)
], SessionGateway.prototype, "server", void 0);
__decorate([
    (0, websockets_1.SubscribeMessage)('join_session'),
    __param(0, (0, websockets_1.MessageBody)()),
    __param(1, (0, websockets_1.ConnectedSocket)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, socket_io_1.Socket]),
    __metadata("design:returntype", Promise)
], SessionGateway.prototype, "handleJoinSession", null);
__decorate([
    (0, websockets_1.SubscribeMessage)('send_message'),
    __param(0, (0, websockets_1.MessageBody)()),
    __param(1, (0, websockets_1.ConnectedSocket)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, socket_io_1.Socket]),
    __metadata("design:returntype", Promise)
], SessionGateway.prototype, "handleSendMessage", null);
exports.SessionGateway = SessionGateway = __decorate([
    (0, websockets_1.WebSocketGateway)({
        namespace: 'chat',
        cors: {
            origin: '*',
        },
    }),
    __metadata("design:paramtypes", [session_service_1.SessionService])
], SessionGateway);
//# sourceMappingURL=session.gateway.js.map