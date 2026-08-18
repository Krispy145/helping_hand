import {
  Controller,
  Get,
  Param,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Role } from '@prisma/client';
import { Roles } from '../auth/roles.decorator';
import { RolesGuard } from '../auth/roles.guard';
import { PulseService } from './pulse.service';

@ApiTags('pulse')
@ApiBearerAuth()
@Controller('pulse')
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.ADMIN, Role.MODERATOR)
export class PulseController {
  constructor(private readonly pulse: PulseService) {}

  @Get('queue')
  @ApiOperation({ summary: 'List open vetting appeals for review' })
  listQueue() {
    return this.pulse.listQueue();
  }

  @Post('appeals/:id/uphold')
  @ApiOperation({ summary: 'Keep the original rejection' })
  uphold(
    @Param('id') id: string,
    @Request() req: { user: { userId: string } },
  ) {
    return this.pulse.uphold(id, req.user.userId);
  }

  @Post('appeals/:id/overturn')
  @ApiOperation({ summary: 'Approve a rejected request after appeal' })
  overturn(
    @Param('id') id: string,
    @Request() req: { user: { userId: string } },
  ) {
    return this.pulse.overturn(id, req.user.userId);
  }
}
