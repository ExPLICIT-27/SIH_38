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
