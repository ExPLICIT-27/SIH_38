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
exports.AuthController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const dto_1 = require("./dto");
const jwt_1 = require("@nestjs/jwt");
const prisma_service_1 = require("../prisma/prisma.service");
let AuthController = class AuthController {
    prisma;
    jwt;
    constructor(prisma, jwt) {
        this.prisma = prisma;
        this.jwt = jwt;
    }
    async requestOtp(body) {
        if (!body || typeof body.email !== 'string' || body.email.trim() === '') {
            throw new common_1.BadRequestException('email is required');
        }
        const email = body.email.toLowerCase();
        const code = Math.floor(100000 + Math.random() * 900000).toString();
        const expiresAt = new Date(Date.now() + 5 * 60 * 1000);
        await this.prisma.otpCode.create({ data: { email, code, expiresAt } });
        return { email, code, expiresInSec: 300 };
    }
    async login(body) {
        if (!body || typeof body.email !== 'string' || body.email.trim() === '') {
            throw new common_1.BadRequestException('email is required');
        }
        if (typeof body.code !== 'string' || body.code.trim() === '') {
            throw new common_1.BadRequestException('code is required');
        }
        const email = body.email.toLowerCase();
        const code = body.code.trim();
        const record = await this.prisma.otpCode.findFirst({
            where: { email, code, consumed: false, expiresAt: { gt: new Date() } },
            orderBy: { createdAt: 'desc' },
        });
        if (!record) {
            return { error: 'Invalid OTP' };
        }
        await this.prisma.otpCode.update({ where: { id: record.id }, data: { consumed: true } });
        const user = await this.prisma.user.upsert({
            where: { email },
            create: { email },
            update: {},
        });
        const token = await this.jwt.signAsync({ sub: user.id, email: user.email, role: user.role });
        return { token };
    }
};
exports.AuthController = AuthController;
__decorate([
    (0, common_1.Post)('request-otp'),
    (0, swagger_1.ApiBody)({ type: dto_1.RequestOtpDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.RequestOtpDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "requestOtp", null);
__decorate([
    (0, common_1.Post)('login'),
    (0, swagger_1.ApiBody)({ type: dto_1.LoginDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.LoginDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "login", null);
exports.AuthController = AuthController = __decorate([
    (0, swagger_1.ApiTags)('Auth'),
    (0, common_1.Controller)('v1/auth'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService, jwt_1.JwtService])
], AuthController);
//# sourceMappingURL=auth.controller.js.map