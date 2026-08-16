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
exports.RequestsController = void 0;
const common_1 = require("@nestjs/common");
const requests_service_1 = require("./requests.service");
const create_request_dto_1 = require("./dto/create-request.dto");
const swagger_1 = require("@nestjs/swagger");
const passport_1 = require("@nestjs/passport");
let RequestsController = class RequestsController {
    requestsService;
    constructor(requestsService) {
        this.requestsService = requestsService;
    }
    async create(req, createRequestDto) {
        return this.requestsService.create(req.user.userId, createRequestDto);
    }
    async findNearby(minLat, minLng, maxLat, maxLng, lat, lng, radius) {
        const south = parseFloat(minLat);
        const west = parseFloat(minLng);
        const north = parseFloat(maxLat);
        const east = parseFloat(maxLng);
        if ([south, west, north, east].every((value) => Number.isFinite(value))) {
            return this.requestsService.findAllInBounds(south, west, north, east);
        }
        const latNum = parseFloat(lat);
        const lngNum = parseFloat(lng);
        const radiusNum = parseFloat(radius) || 10;
        if (Number.isFinite(latNum) && Number.isFinite(lngNum)) {
            return this.requestsService.findAllNearby(latNum, lngNum, radiusNum);
        }
        throw new common_1.BadRequestException('Provide a bounding box or lat/lng');
    }
    findAll() {
        return this.requestsService.findAll();
    }
};
exports.RequestsController = RequestsController;
__decorate([
    (0, common_1.Post)(),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Create a help request' }),
    (0, swagger_1.ApiResponse)({ status: 201, description: 'Request created successfully' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, create_request_dto_1.CreateRequestDto]),
    __metadata("design:returntype", Promise)
], RequestsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('nearby'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    (0, swagger_1.ApiOperation)({ summary: 'Find nearby requests in a map bounding box' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'List of nearby requests' }),
    __param(0, (0, common_1.Query)('minLat')),
    __param(1, (0, common_1.Query)('minLng')),
    __param(2, (0, common_1.Query)('maxLat')),
    __param(3, (0, common_1.Query)('maxLng')),
    __param(4, (0, common_1.Query)('lat')),
    __param(5, (0, common_1.Query)('lng')),
    __param(6, (0, common_1.Query)('radius')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String, String, String, String]),
    __metadata("design:returntype", Promise)
], RequestsController.prototype, "findNearby", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'List all requests (Debug)' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], RequestsController.prototype, "findAll", null);
exports.RequestsController = RequestsController = __decorate([
    (0, swagger_1.ApiTags)('requests'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('requests'),
    __metadata("design:paramtypes", [requests_service_1.RequestsService])
], RequestsController);
//# sourceMappingURL=requests.controller.js.map