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
exports.OrgsController = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const swagger_1 = require("@nestjs/swagger");
const dto_1 = require("./dto");
let OrgsController = class OrgsController {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(body) {
        const org = await this.prisma.organization.create({ data: { name: body.name, type: body.type, mode: body.mode ?? 'SELLER', walletAddress: body.walletAddress } });
        return org;
    }
    async list() {
        return this.prisma.organization.findMany({ orderBy: { createdAt: 'desc' } });
    }
    async setWallet(id, body) {
        return this.prisma.organization.update({ where: { id }, data: { walletAddress: body.walletAddress } });
    }
};
exports.OrgsController = OrgsController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiBody)({ type: dto_1.CreateOrgDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateOrgDto]),
    __metadata("design:returntype", Promise)
], OrgsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], OrgsController.prototype, "list", null);
__decorate([
    (0, common_1.Post)(':id/wallet'),
    (0, swagger_1.ApiBody)({ type: dto_1.SetWalletDto }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.SetWalletDto]),
    __metadata("design:returntype", Promise)
], OrgsController.prototype, "setWallet", null);
exports.OrgsController = OrgsController = __decorate([
    (0, swagger_1.ApiTags)('Organizations'),
    (0, common_1.Controller)('v1/orgs'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], OrgsController);
//# sourceMappingURL=orgs.controller.js.map