export declare const ROLES_KEY = "roles";
export type Role = 'ADMIN' | 'ORG_ADMIN' | 'MEMBER' | 'VERIFIER';
export declare const Roles: (...roles: Role[]) => import("@nestjs/common").CustomDecorator<string>;
