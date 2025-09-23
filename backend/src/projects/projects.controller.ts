import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { CreateProjectDto } from './dto';

@ApiTags('Projects')
@Controller('v1/projects')
export class ProjectsController {
  constructor(private prisma: PrismaService) {}

  @Post()
  @ApiBody({ type: CreateProjectDto })
  async create(@Body() body: CreateProjectDto) {
    const p = await this.prisma.project.create({ data: { orgId: body.orgId, name: body.name, type: body.type, areaHa: body.areaHa ?? 0 } });
    return p;
  }

  @Get()
  async list() {
    return this.prisma.project.findMany({ orderBy: { createdAt: 'desc' } });
  }

  @Post(':id/approve')
  async approve(@Param('id') id: string) {
    return this.prisma.project.update({ where: { id }, data: { status: 'APPROVED' } });
  }
}
