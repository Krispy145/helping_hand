import { Injectable } from '@nestjs/common';
import { IUserRepository } from '../../../domain/repositories/user.repository.interface';
import { User, UserRole } from '../../../domain/entities/user.entity';
import { PrismaService } from '../prisma/prisma.service';
import { User as PrismaUser, Role } from '@prisma/client';

@Injectable()
export class PrismaUserRepository implements IUserRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(user: User): Promise<User> {
    const prismaUser = await this.prisma.user.create({
      data: {
        id: user.id || undefined,
        email: user.email,
        password: user.password!, // Assume password is provided on creation
        name: user.name,
        role: user.role as Role,
      },
    });
    return this.toDomain(prismaUser);
  }

  async findAll(): Promise<User[]> {
    const users = await this.prisma.user.findMany();
    return users.map((user) => this.toDomain(user));
  }

  async findById(id: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) return null;
    return this.toDomain(user);
  }

  async findByEmail(email: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user) return null;
    return this.toDomain(user);
  }

  async update(id: string, user: Partial<User>): Promise<User> {
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: {
        email: user.email,
        name: user.name,
        role: user.role ? (user.role as Role) : undefined,
      },
    });
    return this.toDomain(updatedUser);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.user.delete({ where: { id } });
  }

  private toDomain(prismaUser: PrismaUser): User {
    return new User({
      id: prismaUser.id,
      email: prismaUser.email,
      password: prismaUser.password,
      name: prismaUser.name,
      role: prismaUser.role as UserRole,
      createdAt: prismaUser.createdAt,
      updatedAt: prismaUser.updatedAt,
    });
  }
}
