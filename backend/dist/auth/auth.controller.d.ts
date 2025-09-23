import { RequestOtpDto, LoginDto } from './dto';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
export declare class AuthController {
    private prisma;
    private jwt;
    constructor(prisma: PrismaService, jwt: JwtService);
    requestOtp(body: RequestOtpDto): Promise<{
        email: string;
        code: string;
        expiresInSec: number;
    }>;
    login(body: LoginDto): Promise<{
        error: string;
        token?: undefined;
    } | {
        token: string;
        error?: undefined;
    }>;
}
