import { PrismaService } from '../prisma/prisma.service';
import { SettingsDto, VerifyDto } from './dto';
export declare class RegistryController {
    private prisma;
    constructor(prisma: PrismaService);
    setSettings(body: SettingsDto): Promise<{
        ok: boolean;
    }>;
    getSettings(): Promise<{
        creditAddress: string | number | boolean | import("generated/prisma/runtime/library").JsonObject | import("generated/prisma/runtime/library").JsonArray | null;
        registryAddress: string | number | boolean | import("generated/prisma/runtime/library").JsonObject | import("generated/prisma/runtime/library").JsonArray | null;
    }>;
    verify(body: VerifyDto): Promise<{
        id: string;
        createdAt: Date;
        uploadId: string;
        approved: boolean;
        notes: string | null;
        anchoredTx: string | null;
    }>;
    getUpload(id: string): Promise<{
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
    } | null>;
}
