import { PrismaService } from '../prisma/prisma.service';
import { IpfsService } from '../ipfs/ipfs.service';
export declare class UploadsController {
    private prisma;
    private ipfs;
    constructor(prisma: PrismaService, ipfs: IpfsService);
    upload(file: Express.Multer.File, capturedAt?: string, metadataJson?: string): Promise<{
        id: string;
        sha256: string;
        path: string;
        cid: string | null;
    }>;
    getOne(id: string): Promise<{
        id: string;
        createdAt: Date;
        capturedAt: Date | null;
        metadata: import("generated/prisma/runtime/library").JsonValue | null;
        sha256: string;
        fileName: string;
        storagePath: string;
        size: number;
        cid: string | null;
        status: import("generated/prisma").$Enums.UploadStatus;
        userId: string | null;
    }>;
}
