import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { Session, Message } from '@prisma/client';
export declare class SessionService {
    private prisma;
    constructor(prisma: PrismaService);
    createSession(requestId: string, helperId: string): Promise<Session>;
    saveMessage(sessionId: string, senderId: string, content: string): Promise<Message>;
    getMessages(sessionId: string, userId: string): Promise<Message[]>;
    getUserSessions(userId: string): Promise<Session[]>;
}
