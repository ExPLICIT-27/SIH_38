import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { CreateOrgDto, SetWalletDto } from './dto';

@ApiTags('Organizations')
@Controller('v1/orgs')
export class OrgsController {
  constructor(private prisma: PrismaService) {}

  @Post()
  @ApiBody({ type: CreateOrgDto })
  async create(@Body() body: CreateOrgDto) {
    const org = await this.prisma.organization.create({ data: { name: body.name, type: body.type, mode: (body.mode as any) ?? 'SELLER', walletAddress: body.walletAddress } });
    return org;
  }

  @Get()
  async list() {
    return this.prisma.organization.findMany({ orderBy: { createdAt: 'desc' } });
  }

  @Post(':id/wallet')
  @ApiBody({ type: SetWalletDto })
  async setWallet(@Param('id') id: string, @Body() body: SetWalletDto) {
    return this.prisma.organization.update({ where: { id }, data: { walletAddress: body.walletAddress } });
  }
}
