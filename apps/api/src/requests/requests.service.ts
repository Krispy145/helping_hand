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

  async findAllNearby(lat: number, lng: number, radiusInKm: number): Promise<Request[]> {
    // Raw SQL for Haversine formula
    // Note: This assumes latitude/longitude columns are named 'lat' and 'lng' in the 'Request' table.
    // Prisma models map to database tables, usually pascal case model -> pascal case or lowercase table depending on config.
    // Default prisma naming: Model 'Request' -> Table 'Request' (or 'requests' if map set?)
    // Checking schema.prisma... it didn't specify @@map, so it's 'Request'.
    // However, raw queries return raw objects, may need casting.

    const result = await this.prisma.$queryRaw<Request[]>`
      SELECT *, 
      ( 6371 * acos( cos( radians(${lat}) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(${lng}) ) + sin( radians(${lat}) ) * sin( radians( lat ) ) ) ) AS distance 
      FROM "Request"
      WHERE status = 'APPROVED'
      AND ( 6371 * acos( cos( radians(${lat}) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(${lng}) ) + sin( radians(${lat}) ) * sin( radians( lat ) ) ) ) < ${radiusInKm}
      ORDER BY distance ASC
    `;

    // Manually fetch relations if needed, or just return the raw data.
    // Raw query doesn't include relations by default.
    // For MVP feed, we might want user info.
    // We can fetch user in a separate query or join.
    // Let's keep it simple: just list requests first.
    return result;
  }
}
