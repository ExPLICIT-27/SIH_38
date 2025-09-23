"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const env_schema_1 = require("./config/env.schema");
const health_controller_1 = require("./health/health.controller");
const prisma_service_1 = require("./prisma/prisma.service");
const auth_module_1 = require("./auth/auth.module");
const auth_controller_1 = require("./auth/auth.controller");
const uploads_module_1 = require("./uploads/uploads.module");
const chain_module_1 = require("./chain/chain.module");
const orgs_controller_1 = require("./orgs/orgs.controller");
const projects_controller_1 = require("./projects/projects.controller");
const registry_controller_1 = require("./registry/registry.controller");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({
                isGlobal: true,
                validate: (config) => (0, env_schema_1.validateEnv)(config),
            }),
            auth_module_1.AuthModule,
            uploads_module_1.UploadsModule,
            chain_module_1.ChainModule,
        ],
        controllers: [app_controller_1.AppController, health_controller_1.HealthController, auth_controller_1.AuthController, orgs_controller_1.OrgsController, projects_controller_1.ProjectsController, registry_controller_1.RegistryController],
        providers: [app_service_1.AppService, prisma_service_1.PrismaService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map