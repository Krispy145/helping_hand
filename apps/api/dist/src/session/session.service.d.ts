import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { Message } from '@prisma/client';
export declare class SessionService {
    private prisma;
    constructor(prisma: PrismaService);
    checkOfferAvailability(requestId: string, helperId: string): Promise<{
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
    createSession(requestId: string, helperId: string): Promise<{
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
    getSession(sessionId: string, userId: string): Promise<{
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
    saveMessage(sessionId: string, senderId: string, content: string): Promise<Message>;
    getMessages(sessionId: string, userId: string): Promise<Message[]>;
    cancelAssist(sessionId: string, userId: string): Promise<{
        status: string;
        requestStatus: "APPROVED";
    }>;
    completeAssist(sessionId: string, userId: string): Promise<{
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
    getUserSessions(userId: string): Promise<{
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
    private offerAvailabilityFor;
    private assertParticipant;
    private buildRequestIntro;
    private ensureRequestIntroMessage;
}
