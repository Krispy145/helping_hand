import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { SessionService } from './session.service';

@Controller('sessions')
@UseGuards(AuthGuard('jwt'))
export class SessionController {
  constructor(private readonly sessionService: SessionService) {}

  @Post()
  async createSession(@Request() req: any, @Body('requestId') requestId: string) {
    // In MVP, only Helpers trigger this. 
    // Ideally check if user is NOT the requestor.
    return this.sessionService.createSession(requestId, req.user.id);
  }

  @Get()
  async getMySessions(@Request() req: any) {
    return this.sessionService.getUserSessions(req.user.id);
  }

  @Get(':id/messages')
  async getSessionMessages(@Request() req: any, @Param('id') sessionId: string) {
    return this.sessionService.getMessages(sessionId, req.user.id);
  }
}
