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
exports.ChainController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const chain_service_1 = require("./chain.service");
const prisma_service_1 = require("../prisma/prisma.service");
const dto_1 = require("./dto");
let ChainController = class ChainController {
    chain;
    prisma;
    constructor(chain, prisma) {
        this.chain = chain;
        this.prisma = prisma;
    }
    async deploy() {
        const dep = await this.chain.deployDemo();
        await this.prisma.setting.upsert({ where: { key: 'creditAddress' }, update: { value: dep.creditAddress }, create: { key: 'creditAddress', value: dep.creditAddress } });
        await this.prisma.setting.upsert({ where: { key: 'registryAddress' }, update: { value: dep.registryAddress }, create: { key: 'registryAddress', value: dep.registryAddress } });
        return { ...dep, saved: true };
    }
    async mint(body) {
        const tx = await this.chain.mint(body.creditAddress, body.to, BigInt(body.id), BigInt(body.amount));
        return { tx };
    }
    async retire(body) {
        const tx = await this.chain.retire(body.creditAddress, BigInt(body.id), BigInt(body.amount), body.reason);
        return { tx };
    }
    async anchor(body) {
        const tx = await this.chain.anchor(body.registryAddress, body.uploadId, body.sha256, body.cid ?? '');
        return { tx };
    }
};
exports.ChainController = ChainController;
__decorate([
    (0, common_1.Post)('deploy'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ChainController.prototype, "deploy", null);
__decorate([
    (0, common_1.Post)('mint'),
    (0, swagger_1.ApiBody)({ type: dto_1.MintDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.MintDto]),
    __metadata("design:returntype", Promise)
], ChainController.prototype, "mint", null);
__decorate([
    (0, common_1.Post)('retire'),
    (0, swagger_1.ApiBody)({ type: dto_1.RetireDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.RetireDto]),
    __metadata("design:returntype", Promise)
], ChainController.prototype, "retire", null);
__decorate([
    (0, common_1.Post)('anchor'),
    (0, swagger_1.ApiBody)({ type: dto_1.AnchorDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.AnchorDto]),
    __metadata("design:returntype", Promise)
], ChainController.prototype, "anchor", null);
exports.ChainController = ChainController = __decorate([
    (0, swagger_1.ApiTags)('Chain'),
    (0, common_1.Controller)('v1/chain'),
    __metadata("design:paramtypes", [chain_service_1.ChainService, prisma_service_1.PrismaService])
], ChainController);
//# sourceMappingURL=chain.controller.js.map