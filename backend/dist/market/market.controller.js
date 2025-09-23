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
exports.MarketController = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const swagger_1 = require("@nestjs/swagger");
const chain_service_1 = require("../chain/chain.service");
let MarketController = class MarketController {
    prisma;
    chain;
    constructor(prisma, chain) {
        this.prisma = prisma;
        this.chain = chain;
    }
    async list(body) {
        const listing = await this.prisma.listing.create({
            data: {
                creditAddress: body.creditAddress,
                tokenId: body.tokenId,
                pricePerUnit: body.pricePerUnit,
                remaining: body.amount,
            },
        });
        return listing;
    }
    async listings() {
        return this.prisma.listing.findMany({ orderBy: { createdAt: 'desc' } });
    }
    async buy(id, body) {
        const listing = await this.prisma.listing.findUnique({ where: { id } });
        if (!listing || listing.status !== 'ACTIVE')
            return { error: 'Listing not active' };
        if (listing.remaining < body.amount)
            return { error: 'Insufficient amount' };
        const order = await this.prisma.order.create({
            data: {
                listingId: listing.id,
                buyerWallet: body.buyerWallet,
                amount: body.amount,
                txHash: 'demo',
            },
        });
        const remaining = listing.remaining - body.amount;
        await this.prisma.listing.update({ where: { id }, data: { remaining, status: remaining === 0 ? 'SOLD_OUT' : 'ACTIVE' } });
        return order;
    }
};
exports.MarketController = MarketController;
__decorate([
    (0, common_1.Post)('list'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], MarketController.prototype, "list", null);
__decorate([
    (0, common_1.Get)('listings'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], MarketController.prototype, "listings", null);
__decorate([
    (0, common_1.Post)('buy/:id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], MarketController.prototype, "buy", null);
exports.MarketController = MarketController = __decorate([
    (0, swagger_1.ApiTags)('Market'),
    (0, common_1.Controller)('v1/market'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService, chain_service_1.ChainService])
], MarketController);
//# sourceMappingURL=market.controller.js.map