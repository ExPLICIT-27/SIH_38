import { Body, Controller, Get, Param, Post, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { CreateProjectDto } from './dto';

@ApiTags('Projects')
@Controller('v1/projects')
export class ProjectsController {
  private readonly logger = new Logger(ProjectsController.name);
  constructor(private prisma: PrismaService) {}

  @Post()
  @ApiBody({ type: CreateProjectDto })
  async create(@Body() body: CreateProjectDto) {
    this.logger.log(`Creating project name=${body.name} orgId=${body.orgId}`);
    const p = await this.prisma.project.create({
      data: {
        orgId: body.orgId,
        name: body.name,
        type: body.type,
        areaHa: body.areaHa ?? 0,
      },
    });
    return p;
  }

  @Get()
  async list() {
    this.logger.log('Listing projects');
    return this.prisma.project.findMany({ orderBy: { createdAt: 'desc' } });
  }

  @Post(':id/approve')
  async approve(@Param('id') id: string) {
    this.logger.log(`Approve project id=${id}`);
    return this.prisma.project.update({
      where: { id },
      data: { status: 'APPROVED' },
    });
  }
}
