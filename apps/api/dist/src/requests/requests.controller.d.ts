import { RequestsService } from './requests.service';
import { CreateRequestDto } from './dto/create-request.dto';
export declare class RequestsController {
    private readonly requestsService;
    constructor(requestsService: RequestsService);
    create(req: any, createRequestDto: CreateRequestDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string;
        category: string | null;
        urgency: import("@prisma/client").$Enums.RequestUrgency;
        lat: number | null;
        lng: number | null;
        status: import("@prisma/client").$Enums.RequestStatus;
        userId: string;
    }>;
    findNearby(lat: string, lng: string, radius: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string;
        category: string | null;
        urgency: import("@prisma/client").$Enums.RequestUrgency;
        lat: number | null;
        lng: number | null;
        status: import("@prisma/client").$Enums.RequestStatus;
        userId: string;
    }[]>;
    findAll(): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        description: string;
        category: string | null;
        urgency: import("@prisma/client").$Enums.RequestUrgency;
        lat: number | null;
        lng: number | null;
        status: import("@prisma/client").$Enums.RequestStatus;
        userId: string;
    }[]>;
}
