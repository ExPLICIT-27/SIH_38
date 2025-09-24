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
import { createClient } from '@supabase/supabase-js';

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
    const content = file.buffer ?? readFileSync((file as any).path ?? '');
    const sha256 = createHash('sha256').update(content).digest('hex');
    let metadata: any = undefined;
    if (metadataJson) {
      try {
        metadata = JSON.parse(metadataJson);
      } catch {
        throw new BadRequestException('metadata must be valid JSON');
      }
    }

    const projectId: string | undefined =
      metadata?.projectId ?? metadata?.project_id ?? undefined;

    // Upload to Supabase Storage
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
    let publicUrl: string | undefined;
    let storagePath = '';
    if (supabaseUrl && supabaseServiceRoleKey) {
      const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
        auth: { persistSession: false, autoRefreshToken: false },
      });
      const sanitizedName = file.originalname.replace(/[^a-zA-Z0-9_.-]/g, '_');
      const objectKey = `${Date.now()}-${sha256}-${sanitizedName}`;
      storagePath = objectKey;
      const { error } = await supabase.storage
        .from('data-uploads')
        .upload(objectKey, content, {
          contentType: file.mimetype,
          upsert: false,
        });
      if (error) {
        this.logger.error(`Supabase upload failed: ${error.message}`);
      } else {
        const { data } = supabase.storage
          .from('data-uploads')
          .getPublicUrl(objectKey);
        publicUrl = data.publicUrl;
      }
    } else {
      this.logger.warn(
        'SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY missing; skipping storage upload',
      );
    }

    // Try to pin to IPFS (optional)
    let cid: string | null = null;
    try {
      if ((file as any).path) {
        cid = await this.ipfs.pinFile((file as any).path, file.originalname);
      }
    } catch {
      this.logger.warn('IPFS pin skipped or failed');
    }
    this.logger.log(`IPFS pin result cid=${cid ?? 'null'}`);

    const record = await this.prisma.dataUpload.create({
      data: {
        fileName: file.originalname,
        storagePath: storagePath || (file as any).path || '',
        publicUrl: publicUrl,
        sha256,
        size: file.size,
        capturedAt: capturedAt
          ? new Date(Number(capturedAt) * 1000)
          : undefined,
        metadata,
        cid: cid ?? undefined,
        status: publicUrl ? 'PINNED' : 'PENDING',
        projectId: projectId,
      },
    });
    this.logger.log(`Upload saved id=${record.id} sha256=${sha256}`);
    return { id: record.id, sha256, path: storagePath, cid: record.cid };
  }

  @Get(':id')
  @ApiOkResponse({ description: 'Returns upload metadata' })
  async getOne(@Param('id') id: string) {
    const record = await this.prisma.dataUpload.findUnique({ where: { id } });
    if (!record) throw new NotFoundException('upload not found');
    // Compute verified flag: any approved verification
    const verified = await this.prisma.verification.findFirst({
      where: { uploadId: id, approved: true },
    });
    return { ...record, verified: !!verified } as any;
  }

  @Get('project/:projectId')
  @ApiOkResponse({ description: 'Returns uploads for a project' })
  async getByProject(@Param('projectId') projectId: string) {
    const items = await this.prisma.dataUpload.findMany({
      where: { projectId },
      orderBy: { createdAt: 'desc' },
    });
    const verifs = await this.prisma.verification.findMany({
      where: { uploadId: { in: items.map((i) => i.id) }, approved: true },
      select: { uploadId: true },
    });
    const approvedSet = new Set(verifs.map((v) => v.uploadId));
    return items.map((u) => ({ ...u, verified: approvedSet.has(u.id) }));
  }
}
