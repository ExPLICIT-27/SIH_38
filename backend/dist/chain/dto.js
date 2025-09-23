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
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnchorDto = exports.RetireDto = exports.MintDto = void 0;
const swagger_1 = require("@nestjs/swagger");
class MintDto {
    creditAddress;
    to;
    id;
    amount;
}
exports.MintDto = MintDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], MintDto.prototype, "creditAddress", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '0x...' }),
    __metadata("design:type", String)
], MintDto.prototype, "to", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '1' }),
    __metadata("design:type", String)
], MintDto.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '100' }),
    __metadata("design:type", String)
], MintDto.prototype, "amount", void 0);
class RetireDto {
    creditAddress;
    id;
    amount;
    reason;
}
exports.RetireDto = RetireDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], RetireDto.prototype, "creditAddress", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '1' }),
    __metadata("design:type", String)
], RetireDto.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '40' }),
    __metadata("design:type", String)
], RetireDto.prototype, "amount", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'demo' }),
    __metadata("design:type", String)
], RetireDto.prototype, "reason", void 0);
class AnchorDto {
    registryAddress;
    uploadId;
    sha256;
    cid;
}
exports.AnchorDto = AnchorDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], AnchorDto.prototype, "registryAddress", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], AnchorDto.prototype, "uploadId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'sha256 hex of uploaded file' }),
    __metadata("design:type", String)
], AnchorDto.prototype, "sha256", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ required: false }),
    __metadata("design:type", String)
], AnchorDto.prototype, "cid", void 0);
//# sourceMappingURL=dto.js.map