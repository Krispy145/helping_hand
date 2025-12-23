import { SessionService } from './session.service';
export declare class SessionController {
    private readonly sessionService;
    constructor(sessionService: SessionService);
    createSession(req: any, requestId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: import("@prisma/client").$Enums.SessionStatus;
        requestId: string;
        helperId: string;
    }>;
    getMySessions(req: any): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: import("@prisma/client").$Enums.SessionStatus;
        requestId: string;
        helperId: string;
    }[]>;
    getSessionMessages(req: any, sessionId: string): Promise<{
        id: string;
        createdAt: Date;
        content: string;
        sessionId: string;
        senderId: string;
        read: boolean;
    }[]>;
}
