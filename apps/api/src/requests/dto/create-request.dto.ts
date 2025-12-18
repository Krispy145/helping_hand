import { ApiProperty } from '@nestjs/swagger';
import { RequestUrgency } from '@prisma/client';

export class CreateRequestDto {
  @ApiProperty({ example: 'Groceries Help' })
  title!: string;

  @ApiProperty({ example: 'I need help picking up groceries.' })
  description!: string;

  @ApiProperty({ example: 'Errands', required: false })
  category?: string;

  @ApiProperty({ enum: RequestUrgency, example: RequestUrgency.MEDIUM })
  urgency!: RequestUrgency;

  @ApiProperty({ example: 40.7128, required: false })
  lat?: number;

  @ApiProperty({ example: -74.006, required: false })
  lng?: number;
}
