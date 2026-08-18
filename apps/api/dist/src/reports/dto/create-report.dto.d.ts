import { ReportType } from '@prisma/client';
export declare class CreateReportDto {
    type: ReportType;
    description: string;
    sessionId?: string;
    requestId?: string;
    targetUserId?: string;
    endSession?: boolean;
    evidenceUrls?: string[];
}
