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
exports.CreateRequestDto = void 0;
const swagger_1 = require("@nestjs/swagger");
const client_1 = require("@prisma/client");
class CreateRequestDto {
    title;
    description;
    category;
    urgency;
    lat;
    lng;
}
exports.CreateRequestDto = CreateRequestDto;
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'Groceries Help' }),
    __metadata("design:type", String)
], CreateRequestDto.prototype, "title", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'I need help picking up groceries.' }),
    __metadata("design:type", String)
], CreateRequestDto.prototype, "description", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'Errands', required: false }),
    __metadata("design:type", String)
], CreateRequestDto.prototype, "category", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ enum: client_1.RequestUrgency, example: client_1.RequestUrgency.MEDIUM }),
    __metadata("design:type", String)
], CreateRequestDto.prototype, "urgency", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 40.7128, required: false }),
    __metadata("design:type", Number)
], CreateRequestDto.prototype, "lat", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: -74.006, required: false }),
    __metadata("design:type", Number)
], CreateRequestDto.prototype, "lng", void 0);
//# sourceMappingURL=create-request.dto.js.map