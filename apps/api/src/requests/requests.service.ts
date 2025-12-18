import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { RequestCreatedEvent } from './events/request-created.event';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { Request, RequestStatus } from '@prisma/client';

@Injectable()
export class RequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async create(userId: string, dto: CreateRequestDto): Promise<Request> {
    const request = await this.prisma.request.create({
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

    // Emit event for asynchronous vetting
    this.eventEmitter.emit(
      'request.created',
      new RequestCreatedEvent(request.id, request.title, request.description),
    );

    return request;
  }

  async findAll(): Promise<Request[]> {
    return this.prisma.request.findMany({
      include: { user: true },
      orderBy: { createdAt: 'desc' },
    });
  }
}
