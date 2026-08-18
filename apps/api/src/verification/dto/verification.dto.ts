import { ApiProperty } from '@nestjs/swagger';

export class VerificationWebhookDto {
  @ApiProperty({ example: 'ref-123' })
  referenceId!: string;

  @ApiProperty({ example: true })
  approved!: boolean;

  @ApiProperty({
    example: true,
    description:
      'Provider-confirmed adult. Helping Hand does not store date of birth.',
  })
  isAdult!: boolean;
}

export class VerificationStubCompleteDto {
  @ApiProperty({
    enum: ['verified', 'underage', 'failed'],
    example: 'verified',
  })
  outcome!: 'verified' | 'underage' | 'failed';
}
