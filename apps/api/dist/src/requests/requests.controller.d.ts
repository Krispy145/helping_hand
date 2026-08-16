import { RequestsService } from './requests.service';
import { CreateRequestDto } from './dto/create-request.dto';
export declare class RequestsController {
    private readonly requestsService;
    constructor(requestsService: RequestsService);
    create(req: {
        user: {
            userId: string;
        };
    }, createRequestDto: CreateRequestDto): Promise<{
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
    findNearby(minLat: string, minLng: string, maxLat: string, maxLng: string, lat: string, lng: string, radius: string): Promise<{
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
}
