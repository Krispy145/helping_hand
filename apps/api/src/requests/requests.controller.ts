import { Controller, Post, Body, UseGuards, Request, Get } from '@nestjs/common';
import { RequestsService } from './requests.service';
import { CreateRequestDto } from './dto/create-request.dto';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';

@ApiTags('requests')
@ApiBearerAuth()
@Controller('requests')
export class RequestsController {
  constructor(private readonly requestsService: RequestsService) {}

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Create a help request' })
  @ApiResponse({ status: 201, description: 'Request created successfully' })
  async create(@Request() req: any, @Body() createDto: CreateRequestDto) {
    return this.requestsService.create(req.user.userId, createDto);
  }

  @Get()
  @ApiOperation({ summary: 'List all requests (Debug)' })
  async findAll() {
    return this.requestsService.findAll();
  }
}
