"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChainService = void 0;
const common_1 = require("@nestjs/common");
const ethers_1 = require("ethers");
const path_1 = __importDefault(require("path"));
const fs_1 = require("fs");
let ChainService = class ChainService {
    provider = new ethers_1.ethers.JsonRpcProvider(process.env.RPC_URL || 'http://127.0.0.1:8545');
    wallet = new ethers_1.ethers.Wallet(process.env.PRIVATE_KEY || '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80', this.provider);
    loadArtifact(name) {
        const candidates = [
            path_1.default.join(__dirname, '..', '..', '..', 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
            path_1.default.join(process.cwd(), '..', 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
            path_1.default.join(process.cwd(), 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
        ];
        const file = candidates.find((p) => (0, fs_1.existsSync)(p));
        if (!file) {
            throw new Error(`Artifact not found for ${name}. Tried: ${candidates.join(' | ')}`);
        }
        const artifact = JSON.parse((0, fs_1.readFileSync)(file, 'utf-8'));
        return artifact;
    }
    async deployDemo() {
        const credit = this.loadArtifact('BlueCarbonCredit1155');
        const registry = this.loadArtifact('BlueCarbonRegistry');
        const CreditFactory = new ethers_1.ethers.ContractFactory(credit.abi, credit.bytecode, this.wallet);
        const creditContract = await CreditFactory.deploy();
        await creditContract.waitForDeployment();
        const RegistryFactory = new ethers_1.ethers.ContractFactory(registry.abi, registry.bytecode, this.wallet);
        const registryContract = await RegistryFactory.deploy();
        await registryContract.waitForDeployment();
        return {
            creditAddress: await creditContract.getAddress(),
            registryAddress: await registryContract.getAddress(),
        };
    }
    async mint(creditAddress, to, id, amount) {
        const { abi } = this.loadArtifact('BlueCarbonCredit1155');
        const contract = new ethers_1.ethers.Contract(creditAddress, abi, this.wallet);
        const MINTER_ROLE = ethers_1.ethers.keccak256(ethers_1.ethers.toUtf8Bytes('MINTER_ROLE'));
        await contract.grantRole(MINTER_ROLE, this.wallet.address);
        const tx = await contract.mint(to, id, amount, '0x');
        const rec = await tx.wait();
        return rec?.hash ?? tx.hash;
    }
    async retire(creditAddress, id, amount, reason) {
        const { abi } = this.loadArtifact('BlueCarbonCredit1155');
        const contract = new ethers_1.ethers.Contract(creditAddress, abi, this.wallet);
        const tx = await contract.retire(id, amount, reason);
        const rec = await tx.wait();
        return rec?.hash ?? tx.hash;
    }
    async anchor(registryAddress, uploadId, sha256Hex, cid) {
        const { abi } = this.loadArtifact('BlueCarbonRegistry');
        const contract = new ethers_1.ethers.Contract(registryAddress, abi, this.wallet);
        const hex = sha256Hex?.startsWith('0x') ? sha256Hex : (`0x${sha256Hex}`);
        const tx = await contract.anchor(uploadId, hex, cid);
        const rec = await tx.wait();
        return rec?.hash ?? tx.hash;
    }
};
exports.ChainService = ChainService;
exports.ChainService = ChainService = __decorate([
    (0, common_1.Injectable)()
], ChainService);
//# sourceMappingURL=chain.service.js.map