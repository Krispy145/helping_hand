import { EventEmitter2 } from '@nestjs/event-emitter';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
export declare class RequestsService {
    private readonly prisma;
    private readonly eventEmitter;
    constructor(prisma: PrismaService, eventEmitter: EventEmitter2);
    create(userId: string, dto: CreateRequestDto): Promise<{
        id: string;
        title: string;
        description: string;
        category: string | null | undefined;
        status: string;
        urgency: string;
        lat: number | null | undefined;
        lng: number | null | undefined;
        created_at: Date;
        updated_at: Date;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: string;
            created_at: Date;
            updated_at: Date;
        } | undefined;
    }>;
    findAll(): Promise<{
        id: string;
        title: string;
        description: string;
        category: string | null | undefined;
        status: string;
        urgency: string;
        lat: number | null | undefined;
        lng: number | null | undefined;
        created_at: Date;
        updated_at: Date;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: string;
            created_at: Date;
            updated_at: Date;
        } | undefined;
    }[]>;
    findAllNearby(lat: number, lng: number, radiusInKm: number): Promise<{
        id: string;
        title: string;
        description: string;
        category: string | null | undefined;
        status: string;
        urgency: string;
        lat: number | null | undefined;
        lng: number | null | undefined;
        created_at: Date;
        updated_at: Date;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: string;
            created_at: Date;
            updated_at: Date;
        } | undefined;
    }[]>;
    findAllInBounds(minLat: number, minLng: number, maxLat: number, maxLng: number): Promise<{
        id: string;
        title: string;
        description: string;
        category: string | null | undefined;
        status: string;
        urgency: string;
        lat: number | null | undefined;
        lng: number | null | undefined;
        created_at: Date;
        updated_at: Date;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: string;
            created_at: Date;
            updated_at: Date;
        } | undefined;
    }[]>;
    private hydratePublicRequests;
}
