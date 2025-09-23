import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy, SecretOrKeyProvider } from 'passport-jwt';
import jwksClient from 'jwks-rsa';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    const jwksUri =
      process.env.SUPABASE_JWKS_URL ||
      (process.env.SUPABASE_URL
        ? `${process.env.SUPABASE_URL}/auth/v1/.well-known/jwks.json`
        : undefined);

    if (jwksUri) {
      const client = jwksClient({
        jwksUri,
        cache: true,
        cacheMaxEntries: 5,
        cacheMaxAge: 10 * 60 * 1000,
        rateLimit: true,
        jwksRequestsPerMinute: 10,
      });

      const secretProvider: SecretOrKeyProvider = (
        request: any,
        rawJwtToken: string,
        done: (err: any, secret?: string) => void,
      ) => {
        try {
          const [headerB64] = rawJwtToken.split('.');
          const headerJson = Buffer.from(headerB64, 'base64').toString('utf8');
          const header = JSON.parse(headerJson) as { kid?: string };
          const kid = header.kid;
          if (!kid) return done(new Error('Missing kid in JWT header'));
          client.getSigningKey(kid, (err, key) => {
            if (err) return done(err);
            if (!key) return done(new Error('Signing key not found'));
            let signingKey: string;
            if (typeof (key as any).getPublicKey === 'function') {
              signingKey = (key as any).getPublicKey();
            } else if (
              'publicKey' in key &&
              typeof (key as any).publicKey === 'string'
            ) {
              signingKey = (key as any).publicKey;
            } else {
              return done(new Error('Unable to retrieve signing key'));
            }
            return done(null, signingKey);
          });
        } catch (e) {
          return done(e);
        }
      };

      super({
        jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
        ignoreExpiration: false,
        secretOrKeyProvider: secretProvider,
        algorithms: ['RS256'],
      });
    } else {
      super({
        jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
        ignoreExpiration: false,
        secretOrKey: process.env.JWT_SECRET || 'devsecret',
      });
    }
  }

  async validate(payload: any) {
    return payload;
  }
}
