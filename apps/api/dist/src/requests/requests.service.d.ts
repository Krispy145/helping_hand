import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { Request } from '@prisma/client';
export declare class RequestsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(userId: string, dto: CreateRequestDto): Promise<Request>;
    findAll(): Promise<Request[]>;
}
