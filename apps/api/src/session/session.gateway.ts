import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { SessionService } from './session.service';
import { UseGuards } from '@nestjs/common';
// import { WsAuthGuard } from '../auth/ws-auth.guard'; // Start simple, assume client sends token payload or valid room join

@WebSocketGateway({
  namespace: 'chat',
  cors: {
    origin: '*',
  },
})
export class SessionGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private readonly sessionService: SessionService) {}

  handleConnection(client: Socket) {
    // console.log('Client connected:', client.id);
    // In a real app, verify token in handshake query here.
  }

  handleDisconnect(client: Socket) {
    // console.log('Client disconnected:', client.id);
  }

  @SubscribeMessage('join_session')
  async handleJoinSession(
    @MessageBody() data: { sessionId: string },
    @ConnectedSocket() client: Socket,
  ) {
    // Check if user is allowed to join this session (via Service)
    // For MVP, just joining the room.
    client.join(`session_${data.sessionId}`);
    return { event: 'joined', sessionId: data.sessionId };
  }

  @SubscribeMessage('send_message')
  async handleSendMessage(
    @MessageBody() data: { sessionId: string; content: string; senderId: string },
    @ConnectedSocket() client: Socket,
  ) {
    // Save to DB
    const message = await this.sessionService.saveMessage(data.sessionId, data.senderId, data.content);

    // Broadcast to Room
    this.server.to(`session_${data.sessionId}`).emit('new_message', message);

    return message;
  }
}
