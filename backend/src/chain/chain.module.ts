import { Module } from '@nestjs/common';
import { ChainService } from './chain.service';
import { ChainController } from './chain.controller';
import { PrismaService } from '../prisma/prisma.service';

@Module({
  providers: [ChainService, PrismaService],
  controllers: [ChainController],
  exports: [ChainService],
})
export class ChainModule {}
