"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VettingModule = void 0;
const common_1 = require("@nestjs/common");
const vetting_service_1 = require("./vetting.service");
const vetting_listener_1 = require("./vetting.listener");
const prisma_service_1 = require("../infrastructure/persistence/prisma/prisma.service");
let VettingModule = class VettingModule {
};
exports.VettingModule = VettingModule;
exports.VettingModule = VettingModule = __decorate([
    (0, common_1.Module)({
        providers: [vetting_service_1.VettingService, vetting_listener_1.VettingListener, prisma_service_1.PrismaService],
    })
], VettingModule);
//# sourceMappingURL=vetting.module.js.map