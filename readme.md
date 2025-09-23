## Blue Carbon MRV Platform

End-to-end system for Monitoring, Reporting, and Verification (MRV) of blue carbon projects. Includes a NestJS backend, Solidity smart contracts, and supporting DevOps tooling.

### Key Components

- **Backend**: NestJS (TypeScript), Prisma ORM, Zod validation, Swagger docs
- **Database**: SQLite for dev (default). Postgres supported (via Prisma) if configured
- **Queue/Cache (optional)**: Redis
- **Storage**: IPFS for files/metadata
- **Blockchain**: EVM (Polygon Amoy for demo) with ERC-1155 credits and a registry
- **Contracts**: OpenZeppelin-based `BlueCarbonRegistry` and `BlueCarbonCredit1155`

### Quickstart

1. Backend (dev, SQLite)

```bash
cd backend
npm install
npx prisma migrate dev --name init
npx prisma generate
npm run start:dev
```

- Swagger: `http://localhost:3000/docs`
- Env (optional `.env` in `backend/`):
  - `PORT=3000`
  - `JWT_SECRET=devsecret`
  - `JWT_EXPIRES_IN=1h`
  - `DATABASE_URL="file:../prisma/dev.db"` (default SQLite in repo)

Example `.env` for Postgres (optional):

```
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mrv
JWT_SECRET=changeme
JWT_EXPIRES_IN=1h
PORT=3000
```

2. Smart contracts

```bash
cd contracts
npm install
npm run compile
npm test
```

3. Optional local services (Docker)

```bash
cd ops
docker compose up -d   # starts postgres, redis, hardhat node
```

- Backend defaults to SQLite; Postgres/Redis are optional for advanced flows.

If using Postgres:

```bash
cd backend
npx prisma migrate dev
```

### API Overview

- Auth: email/OTP with JWT; wallet linking (SIWE) optional
- Core modules: orgs, projects, uploads, verifications, registry, batches
- Real-time updates over WebSocket (upload/verification/chain events)
- Explore endpoints in Swagger (`/docs`) or use Postman collection: `postman/BlueCarbonMRV.postman_collection.json`

### Data & On-Chain Model (high-level)

- Off-chain DB tracks users, orgs, projects, data uploads, verifications, and batch records
- IPFS stores MRV artifacts (CIDs and hashes recorded)
- On-chain registry anchors MRV packages and controls mint/burn/retire for ERC-1155 credits

### Repository Structure

- `backend/` — NestJS API (`src/auth`, `src/orgs`, `src/projects`, `src/uploads`, `src/registry`)
- `backend/prisma/` — Prisma schema, migrations, generated client
- `contracts/` — Solidity contracts, Hardhat config and tests
- `ops/` — Docker Compose for local infra (postgres, redis, hardhat)
- `postman/` — Collection for demo flows

### Common Tasks

- Backend unit/E2E tests:

```bash
cd backend
npm run test
npm run test:e2e
```

- Run a local Hardhat node (alternative to Docker):

```bash
cd contracts
npx hardhat node
```

### Demo Flow (suggested)

1. NGO creates organization and project
2. Field/drone data captured → upload to API → CID + SHA-256 recorded
3. Verifier reviews → anchors MRV on-chain (transaction stored)
4. Registry mints ERC-1155 credits for approved vintage
5. Credits transferred or retired; public registry reflects status and proofs

### Notes

- Defaults are set for a fast demo experience; hardening and production settings (RBAC, secrets, observability) should be configured before deployment.
