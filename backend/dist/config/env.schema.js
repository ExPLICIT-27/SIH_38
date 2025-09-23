"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateEnv = validateEnv;
const zod_1 = require("zod");
const envSchema = zod_1.z.object({
    NODE_ENV: zod_1.z
        .enum(['development', 'test', 'production'])
        .default('development'),
    PORT: zod_1.z
        .string()
        .transform((v) => (v ? Number(v) : 3000))
        .pipe(zod_1.z.number().int().min(0).max(65535))
        .default('3000'),
    JWT_SECRET: zod_1.z.string().default('devsecret'),
    JWT_EXPIRES_IN: zod_1.z.string().default('1h'),
});
function validateEnv(config) {
    const parsed = envSchema.safeParse(config);
    if (!parsed.success) {
        const formatted = parsed.error.format();
        throw new Error(`Invalid environment variables: ${JSON.stringify(formatted)}`);
    }
    const env = parsed.data;
    if (typeof env.PORT !== 'number') {
        env.PORT = Number(env.PORT);
    }
    return env;
}
//# sourceMappingURL=env.schema.js.map