import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'test', 'production'])
    .default('development'),
  PORT: z
    .string()
    .transform((v) => (v ? Number(v) : 3000))
    .pipe(z.number().int().min(0).max(65535))
    .default('3000' as unknown as number),
  JWT_SECRET: z.string().default('devsecret'),
  JWT_EXPIRES_IN: z.string().default('1h'),
  SUPABASE_URL: z.string().url().optional(),
  SUPABASE_JWKS_URL: z.string().url().optional(),
  SUPABASE_SERVICE_ROLE_KEY: z.string().optional(),
  IPFS_API_URL: z.string().url().default('http://127.0.0.1:5001').optional(),
  WEB3_STORAGE_TOKEN: z.string().optional(),
});

export type AppEnv = z.infer<typeof envSchema> & { PORT: number };

export function validateEnv(config: Record<string, unknown>): AppEnv {
  const parsed = envSchema.safeParse(config);
  if (!parsed.success) {
    const formatted = parsed.error.format();
    throw new Error(
      `Invalid environment variables: ${JSON.stringify(formatted)}`,
    );
  }
  const env = parsed.data as AppEnv;
  // Ensure numeric PORT
  if (typeof env.PORT !== 'number') {
    env.PORT = Number(env.PORT);
  }
  return env;
}
