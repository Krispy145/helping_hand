import { ApiProperty } from '@nestjs/swagger';
import { ReportType } from '@prisma/client';

export class CreateReportDto {
  @ApiProperty({ enum: ReportType, example: ReportType.HELPER_MISCONDUCT })
  type!: ReportType;

  @ApiProperty({
    example: 'They asked me to send money outside the app.',
  })
  description!: string;

  @ApiProperty({ required: false })
  sessionId?: string;

  @ApiProperty({ required: false })
  requestId?: string;

  @ApiProperty({ required: false })
  targetUserId?: string;

  @ApiProperty({
    required: false,
    default: true,
    description:
      'End the session immediately when reporting from an active chat.',
  })
  endSession?: boolean;

  @ApiProperty({ required: false, type: [String] })
  evidenceUrls?: string[];
}
