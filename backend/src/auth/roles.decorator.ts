import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';
export type Role = 'ADMIN' | 'ORG_ADMIN' | 'MEMBER' | 'VERIFIER';
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);
