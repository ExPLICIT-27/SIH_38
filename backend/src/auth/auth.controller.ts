import { Body, Controller, Post, BadRequestException } from '@nestjs/common';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { RequestOtpDto, LoginDto } from './dto';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Auth')
@Controller('v1/auth')
export class AuthController {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
  ) {}

  @Post('request-otp')
  @ApiBody({ type: RequestOtpDto })
  async requestOtp() {
    return { message: 'Use Supabase Auth signInWithOtp on client' };
  }

  @Post('login')
  @ApiBody({ type: LoginDto })
  async login() {
    return { error: 'Deprecated: Use Supabase Auth verifyOtp on client' };
  }
}
