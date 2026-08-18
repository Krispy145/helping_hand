import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { PulseService } from './pulse.service';

@ApiTags('pulse')
@Controller('public/pulse')
export class PublicPulseController {
  constructor(private readonly pulse: PulseService) {}

  @Get('summary')
  @ApiOperation({
    summary: 'Anonymous Humanity Pulse totals (no identities)',
  })
  summary() {
    return this.pulse.summary();
  }
}
