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
exports.PrismaUserRepository = void 0;
const common_1 = require("@nestjs/common");
const user_entity_1 = require("../../../domain/entities/user.entity");
const prisma_service_1 = require("../prisma/prisma.service");
let PrismaUserRepository = class PrismaUserRepository {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(user) {
        const prismaUser = await this.prisma.user.create({
            data: {
                id: user.id || undefined,
                email: user.email,
                password: user.password,
                name: user.name,
                role: user.role,
            },
        });
        return this.toDomain(prismaUser);
    }
    async findAll() {
        const users = await this.prisma.user.findMany();
        return users.map((user) => this.toDomain(user));
    }
    async findById(id) {
        const user = await this.prisma.user.findUnique({ where: { id } });
        if (!user)
            return null;
        return this.toDomain(user);
    }
    async findByEmail(email) {
        const user = await this.prisma.user.findUnique({ where: { email } });
        if (!user)
            return null;
        return this.toDomain(user);
    }
    async update(id, user) {
        const updatedUser = await this.prisma.user.update({
            where: { id },
            data: {
                email: user.email,
                name: user.name,
                role: user.role ? user.role : undefined,
            },
        });
        return this.toDomain(updatedUser);
    }
    async delete(id) {
        await this.prisma.user.delete({ where: { id } });
    }
    toDomain(prismaUser) {
        return new user_entity_1.User({
            id: prismaUser.id,
            email: prismaUser.email,
            password: prismaUser.password,
            name: prismaUser.name,
            role: prismaUser.role,
            createdAt: prismaUser.createdAt,
            updatedAt: prismaUser.updatedAt,
        });
    }
};
exports.PrismaUserRepository = PrismaUserRepository;
exports.PrismaUserRepository = PrismaUserRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], PrismaUserRepository);
//# sourceMappingURL=prisma-user.repository.js.map