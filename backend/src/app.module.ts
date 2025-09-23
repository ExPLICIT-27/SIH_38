import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { validateEnv } from './config/env.schema';
import { HealthController } from './health/health.controller';
import { PrismaService } from './prisma/prisma.service';
import { AuthModule } from './auth/auth.module';
import { AuthController } from './auth/auth.controller';
import { UploadsModule } from './uploads/uploads.module';
import { ChainModule } from './chain/chain.module';
import { OrgsController } from './orgs/orgs.controller';
import { ProjectsController } from './projects/projects.controller';
import { RegistryController } from './registry/registry.controller';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate: (config) => validateEnv(config),
    }),
    AuthModule,
    UploadsModule,
    ChainModule,
  ],
  controllers: [AppController, HealthController, AuthController, OrgsController, ProjectsController, RegistryController],
  providers: [AppService, PrismaService],
})
export class AppModule {}
