import { Body, Controller, Post, BadRequestException } from '@nestjs/common';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { RequestOtpDto, LoginDto } from './dto';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Auth')
@Controller('v1/auth')
export class AuthController {
  constructor(private prisma: PrismaService, private jwt: JwtService) {}

  @Post('request-otp')
  @ApiBody({ type: RequestOtpDto })
  async requestOtp(@Body() body: RequestOtpDto) {
    if (!body || typeof body.email !== 'string' || body.email.trim() === '') {
      throw new BadRequestException('email is required');
    }
    const email = body.email.toLowerCase();
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);
    await this.prisma.otpCode.create({ data: { email, code, expiresAt } });
    // For demo, return the code directly
    return { email, code, expiresInSec: 300 };
  }

  @Post('login')
  @ApiBody({ type: LoginDto })
  async login(@Body() body: LoginDto) {
    if (!body || typeof body.email !== 'string' || body.email.trim() === '') {
      throw new BadRequestException('email is required');
    }
    if (typeof body.code !== 'string' || body.code.trim() === '') {
      throw new BadRequestException('code is required');
    }
    const email = body.email.toLowerCase();
    const code = body.code.trim();
    const record = await this.prisma.otpCode.findFirst({
      where: { email, code, consumed: false, expiresAt: { gt: new Date() } },
      orderBy: { createdAt: 'desc' },
    });
    if (!record) {
      return { error: 'Invalid OTP' };
    }
    await this.prisma.otpCode.update({ where: { id: record.id }, data: { consumed: true } });
    const user = await this.prisma.user.upsert({
      where: { email },
      create: { email },
      update: {},
    });
    const token = await this.jwt.signAsync({ sub: user.id, email: user.email, role: user.role });
    return { token };
  }
}
