import { ChainService } from './chain.service';
import { PrismaService } from '../prisma/prisma.service';
import { MintDto, RetireDto, AnchorDto } from './dto';
export declare class ChainController {
    private chain;
    private prisma;
    constructor(chain: ChainService, prisma: PrismaService);
    deploy(): Promise<{
        creditAddress: string;
        registryAddress: string;
        saved: boolean;
    }>;
    mint(body: MintDto): Promise<{
        tx: string;
    }>;
    retire(body: RetireDto): Promise<{
        tx: string;
    }>;
    anchor(body: AnchorDto): Promise<{
        tx: string;
    }>;
}
