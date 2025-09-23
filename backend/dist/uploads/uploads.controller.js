"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UploadsController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const crypto_1 = require("crypto");
const fs_1 = require("fs");
const prisma_service_1 = require("../prisma/prisma.service");
const swagger_1 = require("@nestjs/swagger");
const ipfs_service_1 = require("../ipfs/ipfs.service");
const common_2 = require("@nestjs/common");
let UploadsController = class UploadsController {
    prisma;
    ipfs;
    constructor(prisma, ipfs) {
        this.prisma = prisma;
        this.ipfs = ipfs;
    }
    async upload(file, capturedAt, metadataJson) {
        if (!file)
            throw new common_1.BadRequestException('file is required');
        const content = file.buffer ?? (0, fs_1.readFileSync)(file.path);
        const sha256 = (0, crypto_1.createHash)('sha256').update(content).digest('hex');
        let metadata = undefined;
        if (metadataJson) {
            try {
                metadata = JSON.parse(metadataJson);
            }
            catch {
                throw new common_1.BadRequestException('metadata must be valid JSON');
            }
        }
        const cid = await this.ipfs.pinFile(file.path, file.originalname);
        const record = await this.prisma.dataUpload.create({
            data: {
                fileName: file.originalname,
                storagePath: file.path,
                sha256,
                size: file.size,
                capturedAt: capturedAt ? new Date(Number(capturedAt) * 1000) : undefined,
                metadata,
                cid: cid ?? undefined,
                status: cid ? 'PINNED' : 'PENDING',
            },
        });
        return { id: record.id, sha256, path: file.path, cid: record.cid };
    }
    async getOne(id) {
        const record = await this.prisma.dataUpload.findUnique({ where: { id } });
        if (!record)
            throw new common_2.NotFoundException('upload not found');
        return record;
    }
};
exports.UploadsController = UploadsController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, swagger_1.ApiBody)({
        schema: {
            type: 'object',
            properties: {
                file: { type: 'string', format: 'binary' },
                capturedAt: { type: 'integer', example: Math.floor(Date.now() / 1000) },
                metadata: { type: 'object', additionalProperties: true },
            },
            required: ['file'],
        },
    }),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file')),
    __param(0, (0, common_1.UploadedFile)()),
    __param(1, (0, common_1.Body)('capturedAt')),
    __param(2, (0, common_1.Body)('metadata')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", Promise)
], UploadsController.prototype, "upload", null);
__decorate([
    (0, common_2.Get)(':id'),
    (0, swagger_1.ApiOkResponse)({ description: 'Returns upload metadata' }),
    __param(0, (0, common_2.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UploadsController.prototype, "getOne", null);
exports.UploadsController = UploadsController = __decorate([
    (0, swagger_1.ApiTags)('Uploads'),
    (0, common_1.Controller)('v1/uploads'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService, ipfs_service_1.IpfsService])
], UploadsController);
//# sourceMappingURL=uploads.controller.js.map