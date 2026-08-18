import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { CreateReportDto } from './dto/create-report.dto';
export declare class ReportsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(reporterId: string, dto: CreateReportDto): Promise<{
        id: string;
        type: string;
        severity: string;
        description: string;
        status: string;
        session_id: string | null;
        request_id: string | null;
        target_user_id: string | null;
        session_ended: boolean;
        penalizes_reporter: boolean;
        created_at: Date;
    }>;
    findMine(reporterId: string): Promise<{
        id: string;
        type: string;
        severity: string;
        description: string;
        status: string;
        session_id: string | null;
        request_id: string | null;
        target_user_id: string | null;
        session_ended: boolean;
        penalizes_reporter: boolean;
        created_at: Date;
    }[]>;
    private resolveTargetUserId;
    private requestStatusAfterReport;
    private redactIncidentDetails;
}
