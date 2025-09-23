import { Body, Controller, Get, Param, Post, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { SettingsDto, VerifyDto } from './dto';

@ApiTags('Registry')
@Controller('v1/registry')
export class RegistryController {
  private readonly logger = new Logger(RegistryController.name);
  constructor(private prisma: PrismaService) {}

  @Post('settings')
  @ApiBody({ type: SettingsDto })
  async setSettings(@Body() body: SettingsDto) {
    this.logger.log(
      `Save registry settings credit=${body.creditAddress} registry=${body.registryAddress}`,
    );
    await this.prisma.setting.upsert({
      where: { key: 'creditAddress' },
      update: { value: body.creditAddress },
      create: { key: 'creditAddress', value: body.creditAddress },
    });
    await this.prisma.setting.upsert({
      where: { key: 'registryAddress' },
      update: { value: body.registryAddress },
      create: { key: 'registryAddress', value: body.registryAddress },
    });
    return { ok: true };
  }

  @Get('settings')
  async getSettings() {
    this.logger.log('Load registry settings');
    const credit = await this.prisma.setting.findUnique({
      where: { key: 'creditAddress' },
    });
    const registry = await this.prisma.setting.findUnique({
      where: { key: 'registryAddress' },
    });
    return {
      creditAddress: credit?.value ?? null,
      registryAddress: registry?.value ?? null,
    };
  }

  @Post('verify')
  @ApiBody({ type: VerifyDto })
  async verify(@Body() body: VerifyDto) {
    this.logger.log(
      `Create verification uploadId=${body.uploadId} approved=${body.approved}`,
    );
    const v = await this.prisma.verification.create({
      data: {
        uploadId: body.uploadId,
        approved: body.approved,
        notes: body.notes,
        anchoredTx: body.anchoredTx,
      },
    });
    return v;
  }

  @Get('uploads/:id')
  async getUpload(@Param('id') id: string) {
    this.logger.log(`Fetch upload id=${id}`);
    return this.prisma.dataUpload.findUnique({ where: { id } });
  }
}
