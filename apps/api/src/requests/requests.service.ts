import { Injectable } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { Request, RequestStatus } from '@prisma/client';

@Injectable()
export class RequestsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(userId: string, dto: CreateRequestDto): Promise<Request> {
    return this.prisma.request.create({
      data: {
        userId,
        title: dto.title,
        description: dto.description,
        category: dto.category,
        urgency: dto.urgency,
        lat: dto.lat,
        lng: dto.lng,
        status: RequestStatus.PENDING_VETTING, // Default status
      },
      include: {
        user: true,
      },
    });
  }

  async findAll(): Promise<Request[]> {
    return this.prisma.request.findMany({
      include: { user: true },
      orderBy: { createdAt: 'desc' },
    });
  }
}
