import { PrismaService } from '../prisma/prisma.service';
import { CreateProjectDto } from './dto';
export declare class ProjectsController {
    private prisma;
    constructor(prisma: PrismaService);
    create(body: CreateProjectDto): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: import("generated/prisma").$Enums.ProjectStatus;
        orgId: string;
        areaHa: number;
    }>;
    list(): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: import("generated/prisma").$Enums.ProjectStatus;
        orgId: string;
        areaHa: number;
    }[]>;
    approve(id: string): Promise<{
        type: string;
        name: string;
        id: string;
        createdAt: Date;
        updatedAt: Date;
        status: import("generated/prisma").$Enums.ProjectStatus;
        orgId: string;
        areaHa: number;
    }>;
}
