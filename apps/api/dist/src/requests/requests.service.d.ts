import { EventEmitter2 } from '@nestjs/event-emitter';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { Request } from '@prisma/client';
export declare class RequestsService {
    private readonly prisma;
    private readonly eventEmitter;
    constructor(prisma: PrismaService, eventEmitter: EventEmitter2);
    create(userId: string, dto: CreateRequestDto): Promise<Request>;
    findAll(): Promise<Request[]>;
    findAllNearby(lat: number, lng: number, radiusInKm: number): Promise<Request[]>;
}
