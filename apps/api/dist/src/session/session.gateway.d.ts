import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { SessionService } from './session.service';
export declare class SessionGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private readonly sessionService;
    server: Server;
    constructor(sessionService: SessionService);
    handleConnection(client: Socket): void;
    handleDisconnect(client: Socket): void;
    handleJoinSession(data: {
        sessionId: string;
    }, client: Socket): Promise<{
        event: string;
        sessionId: string;
    }>;
    handleSendMessage(data: {
        sessionId: string;
        content: string;
        senderId: string;
    }, client: Socket): Promise<{
        id: string;
        createdAt: Date;
        content: string;
        sessionId: string;
        senderId: string;
        read: boolean;
    }>;
}
