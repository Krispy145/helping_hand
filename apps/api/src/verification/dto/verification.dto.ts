import { ApiProperty } from '@nestjs/swagger';

export class VerificationStubCompleteDto {
  @ApiProperty({
    enum: ['verified', 'underage', 'failed', 'document'],
    example: 'verified',
  })
  outcome!: 'verified' | 'underage' | 'failed' | 'document';
}

export class EligibilityCheckDto {
  @ApiProperty({
    example: '1990-05-12',
    description: 'ISO-8601 date (YYYY-MM-DD). Not persisted.',
  })
  dateOfBirth!: string;
}
