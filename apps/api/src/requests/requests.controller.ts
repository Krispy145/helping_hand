import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
  Query,
  BadRequestException,
} from '@nestjs/common';
import { RequestsService } from './requests.service';
import { CreateRequestDto } from './dto/create-request.dto';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
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
  async create(
    @Request() req: { user: { userId: string } },
    @Body() createRequestDto: CreateRequestDto,
  ) {
    return this.requestsService.create(req.user.userId, createRequestDto);
  }

  @Get('nearby')
  @ApiBearerAuth()
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Find nearby requests in a map bounding box' })
  @ApiResponse({ status: 200, description: 'List of nearby requests' })
  async findNearby(
    @Query('minLat') minLat: string,
    @Query('minLng') minLng: string,
    @Query('maxLat') maxLat: string,
    @Query('maxLng') maxLng: string,
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius: string,
  ) {
    const south = parseFloat(minLat);
    const west = parseFloat(minLng);
    const north = parseFloat(maxLat);
    const east = parseFloat(maxLng);

    if ([south, west, north, east].every((value) => Number.isFinite(value))) {
      return this.requestsService.findAllInBounds(south, west, north, east);
    }

    const latNum = parseFloat(lat);
    const lngNum = parseFloat(lng);
    const radiusNum = parseFloat(radius) || 10;

    if (Number.isFinite(latNum) && Number.isFinite(lngNum)) {
      return this.requestsService.findAllNearby(latNum, lngNum, radiusNum);
    }

    throw new BadRequestException('Provide a bounding box or lat/lng');
  }

  @Get()
  @ApiOperation({ summary: 'List all requests (Debug)' })
  findAll() {
    return this.requestsService.findAll();
  }
}
