import {
  Body,
  Controller,
  Get,
  Headers,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import {
  ApiBearerAuth,
  ApiHeader,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import {
  VerificationStubCompleteDto,
  VerificationWebhookDto,
} from './dto/verification.dto';
import { VerificationService } from './verification.service';

@ApiTags('verification')
@Controller('verification')
export class VerificationController {
  constructor(private readonly verification: VerificationService) {}

  @Get('status')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Current identity verification status' })
  status(@Request() req: { user: { userId: string } }) {
    return this.verification.getStatus(req.user.userId);
  }

  @Post('start')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Start identity verification with the stub provider',
  })
  start(@Request() req: { user: { userId: string } }) {
    return this.verification.start(req.user.userId);
  }

  @Post('webhook')
  @ApiOperation({ summary: 'Provider webhook for verification results' })
  @ApiHeader({ name: 'x-webhook-secret', required: true })
  webhook(
    @Headers('x-webhook-secret') secret: string | undefined,
    @Body() dto: VerificationWebhookDto,
  ) {
    return this.verification.handleWebhook(secret, dto);
  }

  @Post('stub-complete')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Dev-only: complete the stub verification flow' })
  stubComplete(
    @Request() req: { user: { userId: string } },
    @Body() dto: VerificationStubCompleteDto,
  ) {
    return this.verification.stubComplete(req.user.userId, dto);
  }
}
