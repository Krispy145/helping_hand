import { CreateReportDto } from './dto/create-report.dto';
import { ReportsService } from './reports.service';
export declare class ReportsController {
    private readonly reportsService;
    constructor(reportsService: ReportsService);
    create(req: {
        user: {
            userId: string;
        };
    }, dto: CreateReportDto): Promise<{
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
    findMine(req: {
        user: {
            userId: string;
        };
    }): Promise<{
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
}
