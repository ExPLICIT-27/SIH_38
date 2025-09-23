import { Body, Controller, Post } from '@nestjs/common';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { ChainService } from './chain.service';
import { PrismaService } from '../prisma/prisma.service';
import { MintDto, RetireDto, AnchorDto } from './dto';

@ApiTags('Chain')
@Controller('v1/chain')
export class ChainController {
  constructor(private chain: ChainService, private prisma: PrismaService) {}

  @Post('deploy')
  async deploy(): Promise<{ creditAddress: string; registryAddress: string, saved: boolean }> {
    const dep = await this.chain.deployDemo();
    await this.prisma.setting.upsert({ where: { key: 'creditAddress' }, update: { value: dep.creditAddress }, create: { key: 'creditAddress', value: dep.creditAddress } });
    await this.prisma.setting.upsert({ where: { key: 'registryAddress' }, update: { value: dep.registryAddress }, create: { key: 'registryAddress', value: dep.registryAddress } });
    return { ...dep, saved: true };
  }

  @Post('mint')
  @ApiBody({ type: MintDto })
  async mint(@Body() body: MintDto) {
    const tx = await this.chain.mint(body.creditAddress, body.to, BigInt(body.id), BigInt(body.amount));
    return { tx };
  }

  @Post('retire')
  @ApiBody({ type: RetireDto })
  async retire(@Body() body: RetireDto) {
    const tx = await this.chain.retire(body.creditAddress, BigInt(body.id), BigInt(body.amount), body.reason);
    return { tx };
  }

  @Post('anchor')
  @ApiBody({ type: AnchorDto })
  async anchor(@Body() body: AnchorDto) {
    const tx = await this.chain.anchor(body.registryAddress, body.uploadId, body.sha256, body.cid ?? '');
    return { tx };
  }
}


