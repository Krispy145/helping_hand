import { Controller, Get, Post, Body, UseGuards, Request, Query } from '@nestjs/common';
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
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a help request' })
  @ApiResponse({ status: 201, description: 'Request created successfully' })
  async create(@Request() req: any, @Body() createRequestDto: CreateRequestDto) {
    return this.requestsService.create(req.user.userId, createRequestDto);
  }

  @Get('nearby')
  @ApiBearerAuth()
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Find nearby requests' })
  @ApiResponse({ status: 200, description: 'List of nearby requests' })
  async findNearby(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius: string,
  ) {
    const latNum = parseFloat(lat);
    const lngNum = parseFloat(lng);
    const radiusNum = parseFloat(radius) || 10; // Default 10km bounds

    if (isNaN(latNum) || isNaN(lngNum)) {
       // Return empty or throw error?
       // For now throw simplistic error
       throw new Error('Invalid coordinates'); 
    }

    return this.requestsService.findAllNearby(latNum, lngNum, radiusNum);
  }

  @Get()
  @ApiOperation({ summary: 'List all requests (Debug)' })
  findAll() {
    return this.requestsService.findAll();
  }
}
