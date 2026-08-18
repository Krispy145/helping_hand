import { BadRequestException, Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { RequestCreatedEvent } from './events/request-created.event';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { RequestStatus } from '@prisma/client';
import { toPublicRequest } from '../common/public-serializers';
import { approximateLocation } from '../common/geo-hash';

@Injectable()
export class RequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async create(userId: string, dto: CreateRequestDto) {
    if (
      dto.lat == null ||
      dto.lng == null ||
      !Number.isFinite(dto.lat) ||
      !Number.isFinite(dto.lng)
    ) {
      throw new BadRequestException(
        'A location is required to create a request',
      );
    }

    const approx = approximateLocation(dto.lat, dto.lng);
    const request = await this.prisma.request.create({
      data: {
        userId,
        title: dto.title,
        description: dto.description,
        category: dto.category,
        urgency: dto.urgency,
        lat: dto.lat,
        lng: dto.lng,
        geoHashApprox: approx.geoHashApprox,
        approxLat: approx.approxLat,
        approxLng: approx.approxLng,
        status: RequestStatus.PENDING_VETTING,
      },
    });

    this.eventEmitter.emit(
      'request.created',
      new RequestCreatedEvent(request.id, request.title, request.description),
    );

    return toPublicRequest(request);
  }

  async findAll() {
    const requests = await this.prisma.request.findMany({
      orderBy: { createdAt: 'desc' },
    });
    return requests.map((request) => toPublicRequest(request));
  }

  async findAllNearby(lat: number, lng: number, radiusInKm: number) {
    const nearby = await this.prisma.$queryRaw<Array<{ id: string }>>`
      SELECT id
      FROM "Request"
      WHERE status IN ('APPROVED', 'IN_PROGRESS')
        AND "approxLat" IS NOT NULL
        AND "approxLng" IS NOT NULL
        AND (
          6371 * acos(
            cos(radians(${lat})) * cos(radians("approxLat")) * cos(radians("approxLng") - radians(${lng}))
            + sin(radians(${lat})) * sin(radians("approxLat"))
          )
        ) < ${radiusInKm}
      ORDER BY (
        6371 * acos(
          cos(radians(${lat})) * cos(radians("approxLat")) * cos(radians("approxLng") - radians(${lng}))
          + sin(radians(${lat})) * sin(radians("approxLat"))
        )
      ) ASC
      LIMIT 200
    `;

    return this.hydratePublicRequests(nearby.map((row) => row.id));
  }

  async findAllInBounds(
    minLat: number,
    minLng: number,
    maxLat: number,
    maxLng: number,
  ) {
    const south = Math.min(minLat, maxLat);
    const north = Math.max(minLat, maxLat);
    const west = Math.min(minLng, maxLng);
    const east = Math.max(minLng, maxLng);

    const requests = await this.prisma.request.findMany({
      where: {
        status: { in: [RequestStatus.APPROVED, RequestStatus.IN_PROGRESS] },
        approxLat: { gte: south, lte: north },
        approxLng: { gte: west, lte: east },
      },
      orderBy: { createdAt: 'desc' },
      take: 200,
    });

    return requests.map((request) => toPublicRequest(request));
  }

  private async hydratePublicRequests(ids: string[]) {
    if (ids.length === 0) return [];

    const requests = await this.prisma.request.findMany({
      where: { id: { in: ids } },
    });
    const byId = new Map(requests.map((request) => [request.id, request]));

    return ids
      .map((id) => byId.get(id))
      .filter(
        (request): request is NonNullable<typeof request> => request != null,
      )
      .map((request) => toPublicRequest(request));
  }
}
