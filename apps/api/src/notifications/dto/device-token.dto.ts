import { ApiProperty } from '@nestjs/swagger';

export class RegisterDeviceDto {
  @ApiProperty({ example: 'fcm-device-token' })
  token!: string;

  @ApiProperty({ example: 'android', required: false })
  platform?: string;
}

export class UnregisterDeviceDto {
  @ApiProperty({ example: 'fcm-device-token' })
  token!: string;
}
