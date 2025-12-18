import { RequestUrgency } from '@prisma/client';
export declare class CreateRequestDto {
    title: string;
    description: string;
    category?: string;
    urgency: RequestUrgency;
    lat?: number;
    lng?: number;
}
