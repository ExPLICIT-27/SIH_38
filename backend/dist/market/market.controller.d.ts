import { PrismaService } from '../prisma/prisma.service';
import { ChainService } from '../chain/chain.service';
export declare class MarketController {
    private prisma;
    private chain;
    constructor(prisma: PrismaService, chain: ChainService);
    list(body: {
        creditAddress: string;
        tokenId: number;
        pricePerUnit: number;
        amount: number;
    }): Promise<{
        id: string;
        createdAt: Date;
        status: import("generated/prisma").$Enums.ListingStatus;
        creditAddress: string;
        tokenId: number;
        pricePerUnit: number;
        remaining: number;
    }>;
    listings(): Promise<{
        id: string;
        createdAt: Date;
        status: import("generated/prisma").$Enums.ListingStatus;
        creditAddress: string;
        tokenId: number;
        pricePerUnit: number;
        remaining: number;
    }[]>;
    buy(id: string, body: {
        buyerWallet: string;
        amount: number;
        creditAddress: string;
        tokenId: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        amount: number;
        buyerWallet: string;
        txHash: string;
        listingId: string;
    } | {
        error: string;
    }>;
}
