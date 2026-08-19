import {
  Body,
  Controller,
  Delete,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RegisterDeviceDto, UnregisterDeviceDto } from './dto/device-token.dto';
import { NotificationsService } from './notifications.service';

@ApiTags('notifications')
@ApiBearerAuth()
@Controller('notifications')
@UseGuards(AuthGuard('jwt'))
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Post('devices')
  @ApiOperation({ summary: 'Register this device for session alerts' })
  @ApiResponse({ status: 201, description: 'Device token stored' })
  register(
    @Request() req: { user: { userId: string } },
    @Body() dto: RegisterDeviceDto,
  ) {
    return this.notifications.registerDevice(
      req.user.userId,
      dto.token,
      dto.platform,
    );
  }

  @Delete('devices')
  @ApiOperation({ summary: 'Remove this device from session alerts' })
  unregister(@Body() dto: UnregisterDeviceDto) {
    return this.notifications.unregisterDevice(dto.token);
  }
}
