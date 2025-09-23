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
exports.RegistryController = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const swagger_1 = require("@nestjs/swagger");
const dto_1 = require("./dto");
let RegistryController = class RegistryController {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async setSettings(body) {
        await this.prisma.setting.upsert({ where: { key: 'creditAddress' }, update: { value: body.creditAddress }, create: { key: 'creditAddress', value: body.creditAddress } });
        await this.prisma.setting.upsert({ where: { key: 'registryAddress' }, update: { value: body.registryAddress }, create: { key: 'registryAddress', value: body.registryAddress } });
        return { ok: true };
    }
    async getSettings() {
        const credit = await this.prisma.setting.findUnique({ where: { key: 'creditAddress' } });
        const registry = await this.prisma.setting.findUnique({ where: { key: 'registryAddress' } });
        return { creditAddress: credit?.value ?? null, registryAddress: registry?.value ?? null };
    }
    async verify(body) {
        const v = await this.prisma.verification.create({ data: { uploadId: body.uploadId, approved: body.approved, notes: body.notes, anchoredTx: body.anchoredTx } });
        return v;
    }
    async getUpload(id) {
        return this.prisma.dataUpload.findUnique({ where: { id } });
    }
};
exports.RegistryController = RegistryController;
__decorate([
    (0, common_1.Post)('settings'),
    (0, swagger_1.ApiBody)({ type: dto_1.SettingsDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.SettingsDto]),
    __metadata("design:returntype", Promise)
], RegistryController.prototype, "setSettings", null);
__decorate([
    (0, common_1.Get)('settings'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], RegistryController.prototype, "getSettings", null);
__decorate([
    (0, common_1.Post)('verify'),
    (0, swagger_1.ApiBody)({ type: dto_1.VerifyDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.VerifyDto]),
    __metadata("design:returntype", Promise)
], RegistryController.prototype, "verify", null);
__decorate([
    (0, common_1.Get)('uploads/:id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], RegistryController.prototype, "getUpload", null);
exports.RegistryController = RegistryController = __decorate([
    (0, swagger_1.ApiTags)('Registry'),
    (0, common_1.Controller)('v1/registry'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], RegistryController);
//# sourceMappingURL=registry.controller.js.map