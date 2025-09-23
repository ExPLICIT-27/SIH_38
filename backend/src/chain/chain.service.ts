import { Injectable } from '@nestjs/common';
import { ethers } from 'ethers';
import path from 'path';
import { readFileSync, existsSync } from 'fs';

interface Deployed {
  creditAddress: string;
  registryAddress: string;
}

@Injectable()
export class ChainService {
  private provider = new ethers.JsonRpcProvider(process.env.RPC_URL || 'http://127.0.0.1:8545');
  private wallet = new ethers.Wallet(process.env.PRIVATE_KEY || '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80', this.provider);

  private loadArtifact(name: string) {
    const candidates = [
      path.join(__dirname, '..', '..', '..', 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
      path.join(process.cwd(), '..', 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
      path.join(process.cwd(), 'contracts', 'artifacts', 'contracts', `${name}.sol`, `${name}.json`),
    ];
    const file = candidates.find((p) => existsSync(p));
    if (!file) {
      throw new Error(`Artifact not found for ${name}. Tried: ${candidates.join(' | ')}`);
    }
    const artifact = JSON.parse(readFileSync(file, 'utf-8'));
    return artifact as { abi: any[]; bytecode: string };
  }

  async deployDemo(): Promise<Deployed> {
    const credit = this.loadArtifact('BlueCarbonCredit1155');
    const registry = this.loadArtifact('BlueCarbonRegistry');

    const CreditFactory = new ethers.ContractFactory(credit.abi, credit.bytecode, this.wallet);
    const creditContract = await CreditFactory.deploy();
    await creditContract.waitForDeployment();

    const RegistryFactory = new ethers.ContractFactory(registry.abi, registry.bytecode, this.wallet);
    const registryContract = await RegistryFactory.deploy();
    await registryContract.waitForDeployment();

    return {
      creditAddress: await creditContract.getAddress(),
      registryAddress: await registryContract.getAddress(),
    };
  }

  async mint(creditAddress: string, to: string, id: bigint, amount: bigint): Promise<string> {
    const { abi } = this.loadArtifact('BlueCarbonCredit1155');
    const contract = new ethers.Contract(creditAddress, abi, this.wallet);
    const MINTER_ROLE = ethers.keccak256(ethers.toUtf8Bytes('MINTER_ROLE'));
    await contract.grantRole(MINTER_ROLE, this.wallet.address);
    const tx = await contract.mint(to, id, amount, '0x');
    const rec = await tx.wait();
    return rec?.hash ?? tx.hash;
  }

  async retire(creditAddress: string, id: bigint, amount: bigint, reason: string): Promise<string> {
    const { abi } = this.loadArtifact('BlueCarbonCredit1155');
    const contract = new ethers.Contract(creditAddress, abi, this.wallet);
    const tx = await contract.retire(id, amount, reason);
    const rec = await tx.wait();
    return rec?.hash ?? tx.hash;
  }

  async anchor(registryAddress: string, uploadId: string, sha256Hex: string, cid: string): Promise<string> {
    const { abi } = this.loadArtifact('BlueCarbonRegistry');
    const contract = new ethers.Contract(registryAddress, abi, this.wallet);
    const hex = sha256Hex?.startsWith('0x') ? sha256Hex : (`0x${sha256Hex}`);
    const tx = await contract.anchor(uploadId, hex as unknown as `0x${string}`, cid);
    const rec = await tx.wait();
    return rec?.hash ?? tx.hash;
  }
}
