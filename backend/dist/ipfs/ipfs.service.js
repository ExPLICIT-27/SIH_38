"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var IpfsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.IpfsService = void 0;
const common_1 = require("@nestjs/common");
const promises_1 = require("fs/promises");
let IpfsService = IpfsService_1 = class IpfsService {
    logger = new common_1.Logger(IpfsService_1.name);
    token = process.env.WEB3_STORAGE_TOKEN || '';
    async pinFile(filePath, fileName) {
        if (!this.token) {
            this.logger.warn('WEB3_STORAGE_TOKEN not set; skipping IPFS pin');
            return null;
        }
        try {
            const buffer = await (0, promises_1.readFile)(filePath);
            const file = new File([new Uint8Array(buffer)], fileName);
            const form = new FormData();
            form.append('file', file);
            const res = await fetch('https://api.web3.storage/upload', {
                method: 'POST',
                headers: { Authorization: `Bearer ${this.token}` },
                body: form,
            });
            if (!res.ok) {
                const text = await res.text();
                this.logger.error(`IPFS upload failed: ${res.status} ${text}`);
                return null;
            }
            const json = (await res.json());
            return json.cid ?? null;
        }
        catch (err) {
            this.logger.error('IPFS pin error', err);
            return null;
        }
    }
};
exports.IpfsService = IpfsService;
exports.IpfsService = IpfsService = IpfsService_1 = __decorate([
    (0, common_1.Injectable)()
], IpfsService);
//# sourceMappingURL=ipfs.service.js.map