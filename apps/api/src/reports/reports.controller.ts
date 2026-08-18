import {
  Body,
  Controller,
  Get,
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
import { CreateReportDto } from './dto/create-report.dto';
import { ReportsService } from './reports.service';

@ApiTags('reports')
@ApiBearerAuth()
@Controller('reports')
@UseGuards(AuthGuard('jwt'))
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Post()
  @ApiOperation({ summary: 'File a safety report' })
  @ApiResponse({ status: 201, description: 'Report received' })
  create(
    @Request() req: { user: { userId: string } },
    @Body() dto: CreateReportDto,
  ) {
    return this.reportsService.create(req.user.userId, dto);
  }

  @Get('mine')
  @ApiOperation({ summary: 'List reports filed by the current user' })
  findMine(@Request() req: { user: { userId: string } }) {
    return this.reportsService.findMine(req.user.userId);
  }
}
