import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
export declare class VettingService {
    private readonly prisma;
    private readonly logger;
    private readonly restrictedKeywords;
    constructor(prisma: PrismaService);
    vetRequest(requestId: string, textToVet: string): Promise<void>;
}
