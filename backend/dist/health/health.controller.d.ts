import { PrismaService } from '../prisma/prisma.service';
export declare class HealthController {
    private readonly prisma;
    constructor(prisma: PrismaService);
    liveness(): {
        status: string;
    };
    readiness(): Promise<{
        status: string;
    }>;
}
