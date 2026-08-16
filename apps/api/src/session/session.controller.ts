import { Controller, Get, Post, Body, Param, Query, UseGuards, Request, BadRequestException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { SessionService } from './session.service';

@Controller('sessions')
@UseGuards(AuthGuard('jwt'))
export class SessionController {
  constructor(private readonly sessionService: SessionService) {}

  @Post()
  async createSession(@Request() req: { user: { userId: string } }, @Body('requestId') requestId: string) {
    if (!requestId) throw new BadRequestException('requestId is required');
    return this.sessionService.createSession(requestId, req.user.userId);
  }

  @Get()
  async getMySessions(@Request() req: { user: { userId: string } }) {
    return this.sessionService.getUserSessions(req.user.userId);
  }

  @Get('availability')
  async checkAvailability(
    @Request() req: { user: { userId: string } },
    @Query('requestId') requestId: string,
  ) {
    if (!requestId) throw new BadRequestException('requestId is required');
    return this.sessionService.checkOfferAvailability(requestId, req.user.userId);
  }

  @Post(':id/cancel')
  async cancelAssist(@Request() req: { user: { userId: string } }, @Param('id') sessionId: string) {
    return this.sessionService.cancelAssist(sessionId, req.user.userId);
  }

  @Post(':id/complete')
  async completeAssist(@Request() req: { user: { userId: string } }, @Param('id') sessionId: string) {
    return this.sessionService.completeAssist(sessionId, req.user.userId);
  }

  @Get(':id/messages')
  async getSessionMessages(@Request() req: { user: { userId: string } }, @Param('id') sessionId: string) {
    return this.sessionService.getMessages(sessionId, req.user.userId);
  }

  @Get(':id')
  async getSession(@Request() req: { user: { userId: string } }, @Param('id') sessionId: string) {
    return this.sessionService.getSession(sessionId, req.user.userId);
  }
}
