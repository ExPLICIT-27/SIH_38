import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
  Body,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { createHash } from 'crypto';
import { readFileSync } from 'fs';
import { PrismaService } from '../prisma/prisma.service';
import { ApiBody, ApiConsumes, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { IpfsService } from '../ipfs/ipfs.service';
import { Param, Get, NotFoundException } from '@nestjs/common';

@ApiTags('Uploads')
@Controller('v1/uploads')
export class UploadsController {
  private readonly logger = new Logger(UploadsController.name);
  constructor(
    private prisma: PrismaService,
    private ipfs: IpfsService,
  ) {}

  @Post()
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
        capturedAt: { type: 'integer', example: Math.floor(Date.now() / 1000) },
        metadata: { type: 'object', additionalProperties: true },
      },
      required: ['file'],
    },
  })
  @UseInterceptors(FileInterceptor('file'))
  async upload(
    @UploadedFile() file: Express.Multer.File,
    @Body('capturedAt') capturedAt?: string,
    @Body('metadata') metadataJson?: string,
  ) {
    if (!file) throw new BadRequestException('file is required');
    this.logger.log(`Uploading file ${file.originalname} (${file.size} bytes)`);
    const content = file.buffer ?? readFileSync(file.path);
    const sha256 = createHash('sha256').update(content).digest('hex');
    let metadata: any = undefined;
    if (metadataJson) {
      try {
        metadata = JSON.parse(metadataJson);
      } catch {
        throw new BadRequestException('metadata must be valid JSON');
      }
    }
    // Try to pin to IPFS (optional)
    const cid = await this.ipfs.pinFile(file.path, file.originalname);
    this.logger.log(`IPFS pin result cid=${cid ?? 'null'}`);
    const record = await this.prisma.dataUpload.create({
      data: {
        fileName: file.originalname,
        storagePath: file.path,
        sha256,
        size: file.size,
        capturedAt: capturedAt
          ? new Date(Number(capturedAt) * 1000)
          : undefined,
        metadata,
        cid: cid ?? undefined,
        status: cid ? 'PINNED' : 'PENDING',
      },
    });
    this.logger.log(`Upload saved id=${record.id} sha256=${sha256}`);
    return { id: record.id, sha256, path: file.path, cid: record.cid };
  }

  @Get(':id')
  @ApiOkResponse({ description: 'Returns upload metadata' })
  async getOne(@Param('id') id: string) {
    const record = await this.prisma.dataUpload.findUnique({ where: { id } });
    if (!record) throw new NotFoundException('upload not found');
    return record;
  }
}
