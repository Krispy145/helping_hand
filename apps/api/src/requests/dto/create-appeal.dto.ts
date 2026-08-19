import { ApiPropertyOptional } from '@nestjs/swagger';

export class CreateAppealDto {
  @ApiPropertyOptional({
    example: 'I believe this was blocked by mistake.',
  })
  reason?: string;
}
