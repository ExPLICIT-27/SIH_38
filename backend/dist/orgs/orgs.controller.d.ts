import { PrismaService } from '../prisma/prisma.service';
import { CreateOrgDto, SetWalletDto } from './dto';
export declare class OrgsController {
    private prisma;
    constructor(prisma: PrismaService);
    create(body: CreateOrgDto): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        mode: import("generated/prisma").$Enums.Mode;
        walletAddress: string | null;
    }>;
    list(): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        mode: import("generated/prisma").$Enums.Mode;
        walletAddress: string | null;
    }[]>;
    setWallet(id: string, body: SetWalletDto): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        mode: import("generated/prisma").$Enums.Mode;
        walletAddress: string | null;
    }>;
}
