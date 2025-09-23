import { Body, Controller, Get, Param, Post, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { CreateOrgDto, SetWalletDto } from './dto';

@ApiTags('Organizations')
@Controller('v1/orgs')
export class OrgsController {
  private readonly logger = new Logger(OrgsController.name);
  constructor(private prisma: PrismaService) {}

  @Post()
  @ApiBody({ type: CreateOrgDto })
  async create(@Body() body: CreateOrgDto) {
    this.logger.log(
      `Creating org name=${body.name} type=${body.type} mode=${body.mode ?? 'SELLER'}`,
    );
    const org = await this.prisma.organization.create({
      data: {
        name: body.name,
        type: body.type,
        mode: (body.mode as any) ?? 'SELLER',
        walletAddress: body.walletAddress,
      },
    });
    return org;
  }

  @Get()
  async list() {
    this.logger.log('Listing organizations');
    return this.prisma.organization.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  @Post(':id/wallet')
  @ApiBody({ type: SetWalletDto })
  async setWallet(@Param('id') id: string, @Body() body: SetWalletDto) {
    this.logger.log(`Set wallet for org id=${id}`);
    return this.prisma.organization.update({
      where: { id },
      data: { walletAddress: body.walletAddress },
    });
  }
}
