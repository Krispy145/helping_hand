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
  EligibilityCheckDto,
  VerificationStubCompleteDto,
} from './dto/verification.dto';
import { VerificationService } from './verification.service';

@ApiTags('verification')
@Controller('verification')
export class VerificationController {
  constructor(private readonly verification: VerificationService) {}

  @Get('status')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Current age verification status' })
  status(@Request() req: { user: { userId: string } }) {
    return this.verification.getStatus(req.user.userId);
  }

  @Post('eligibility')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      'Check whether a date of birth meets the minimum age. The date is not stored.',
  })
  eligibility(
    @Body()
    body: EligibilityCheckDto & { date_of_birth?: string },
  ) {
    return this.verification.checkEligibility({
      dateOfBirth: body.dateOfBirth ?? body.date_of_birth ?? '',
    });
  }

  @Post('start')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Create an age-verification session (facial estimation first)',
  })
  start(@Request() req: { user: { userId: string } }) {
    return this.verification.start(req.user.userId);
  }

  @Post('document')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Continue with government ID / document verification',
  })
  document(@Request() req: { user: { userId: string } }) {
    return this.verification.startDocument(req.user.userId);
  }

  @Post('refresh')
  @UseGuards(AuthGuard('jwt'))
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Fetch the latest provider result for the current user session',
  })
  refresh(@Request() req: { user: { userId: string } }) {
    return this.verification.refresh(req.user.userId);
  }

  @Post('webhook')
  @ApiOperation({ summary: 'Provider webhook for verification results' })
  @ApiHeader({ name: 'x-webhook-secret', required: false })
  webhook(
    @Headers('x-webhook-secret') secret: string | undefined,
    @Body() body: Record<string, unknown>,
  ) {
    return this.verification.handleWebhook(secret, body);
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
