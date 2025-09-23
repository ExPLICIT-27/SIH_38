"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UploadsModule = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const multer_1 = require("multer");
const uploads_controller_1 = require("./uploads.controller");
const prisma_service_1 = require("../prisma/prisma.service");
const ipfs_service_1 = require("../ipfs/ipfs.service");
const fs_1 = require("fs");
let UploadsModule = class UploadsModule {
};
exports.UploadsModule = UploadsModule;
exports.UploadsModule = UploadsModule = __decorate([
    (0, common_1.Module)({
        imports: [
            platform_express_1.MulterModule.register({
                storage: (0, multer_1.diskStorage)({
                    destination: (_req, _file, cb) => {
                        (0, fs_1.mkdirSync)('./uploads', { recursive: true });
                        cb(null, './uploads');
                    },
                    filename: (_req, file, cb) => {
                        cb(null, `${Date.now()}-${file.originalname}`);
                    },
                }),
                limits: { fileSize: 50 * 1024 * 1024 },
            }),
        ],
        controllers: [uploads_controller_1.UploadsController],
        providers: [prisma_service_1.PrismaService, ipfs_service_1.IpfsService],
    })
], UploadsModule);
//# sourceMappingURL=uploads.module.js.map