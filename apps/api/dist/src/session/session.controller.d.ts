import { SessionService } from './session.service';
export declare class SessionController {
    private readonly sessionService;
    constructor(sessionService: SessionService);
    createSession(req: {
        user: {
            userId: string;
        };
    }, requestId: string): Promise<{
        id: string;
        requestId: string;
        helperId: string;
        status: import("@prisma/client").$Enums.SessionStatus;
        request: {
            title: string;
            description: string;
            category: string | null;
            urgency: import("@prisma/client").$Enums.RequestUrgency;
            status: import("@prisma/client").$Enums.RequestStatus;
        };
        requester: {
            id: string;
            name: string | null;
        };
        helper: {
            id: string;
            name: string | null;
        };
    }>;
    getMySessions(req: {
        user: {
            userId: string;
        };
    }): Promise<{
        id: string;
        requestId: string;
        helperId: string;
        status: import("@prisma/client").$Enums.SessionStatus;
        request: {
            title: string;
            description: string;
            category: string | null;
            urgency: import("@prisma/client").$Enums.RequestUrgency;
            status: import("@prisma/client").$Enums.RequestStatus;
        };
        requester: {
            id: string;
            name: string | null;
        };
        helper: {
            id: string;
            name: string | null;
        };
    }[]>;
    checkAvailability(req: {
        user: {
            userId: string;
        };
    }, requestId: string): Promise<{
        open: boolean;
        busy: boolean;
        reason: "own_request";
        sessionId: string;
    } | {
        open: boolean;
        busy: boolean;
        reason: "own_request";
        sessionId?: undefined;
    } | {
        open: boolean;
        busy: boolean;
        reason: "already_helping";
        sessionId: string;
    } | {
        open: boolean;
        busy: boolean;
        reason: "busy";
        sessionId?: undefined;
    } | {
        open: boolean;
        busy: boolean;
        reason: "not_open";
        sessionId?: undefined;
    } | {
        open: boolean;
        busy: boolean;
        reason: "open";
        sessionId?: undefined;
    }>;
    cancelAssist(req: {
        user: {
            userId: string;
        };
    }, sessionId: string): Promise<{
        status: string;
        requestStatus: "APPROVED";
    }>;
    completeAssist(req: {
        user: {
            userId: string;
        };
    }, sessionId: string): Promise<{
        id: string;
        requestId: string;
        helperId: string;
        status: import("@prisma/client").$Enums.SessionStatus;
        request: {
            title: string;
            description: string;
            category: string | null;
            urgency: import("@prisma/client").$Enums.RequestUrgency;
            status: import("@prisma/client").$Enums.RequestStatus;
        };
        requester: {
            id: string;
            name: string | null;
        };
        helper: {
            id: string;
            name: string | null;
        };
    }>;
    getSessionMessages(req: {
        user: {
            userId: string;
        };
    }, sessionId: string): Promise<{
        id: string;
        createdAt: Date;
        content: string;
        sessionId: string;
        senderId: string;
        read: boolean;
    }[]>;
    getSession(req: {
        user: {
            userId: string;
        };
    }, sessionId: string): Promise<{
        id: string;
        requestId: string;
        helperId: string;
        status: import("@prisma/client").$Enums.SessionStatus;
        request: {
            title: string;
            description: string;
            category: string | null;
            urgency: import("@prisma/client").$Enums.RequestUrgency;
            status: import("@prisma/client").$Enums.RequestStatus;
        };
        requester: {
            id: string;
            name: string | null;
        };
        helper: {
            id: string;
            name: string | null;
        };
    }>;
}
