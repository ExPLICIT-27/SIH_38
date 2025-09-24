import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { UploadsController } from './uploads.controller';
import type { Request } from 'express';
import type { Express } from 'express';
import { PrismaService } from '../prisma/prisma.service';
import { IpfsService } from '../ipfs/ipfs.service';
import { mkdirSync } from 'fs';

@Module({
  imports: [
    MulterModule.register({
      storage: memoryStorage(),
      limits: { fileSize: 50 * 1024 * 1024 },
    }),
  ],
  controllers: [UploadsController],
  providers: [PrismaService, IpfsService],
})
export class UploadsModule {}
