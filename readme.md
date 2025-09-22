#test commit
High-level architecture
Backend API and Worker (Node.js/NestJS + TypeScript, Dockerized)
PostgreSQL (primary system of record for users, projects, uploads, audits)
Redis (queues for data processing, IPFS pinning, chain transactions)
IPFS/Filecoin for data + metadata storage (via web3.storage or Pinata)
EVM blockchain (Polygon Amoy testnet for demo; Polygon PoS mainnet-ready)
Smart contracts (OpenZeppelin-based ERC-1155 credits + registry/roles)
Optional: EAS (Ethereum Attestation Service) for verifiable MRV attestations
Auth: Email/OTP plus wallet linking; optional gasless meta-txs via ERC-4337 (Biconomy/Stackup)
Observability: Sentry, Prometheus/Grafana (containerized)
CI/CD: GitHub Actions
Flutter app integrates via REST + WebSocket, optional WalletConnect/Web3Auth
Tech stack
Backend: NestJS (TS), Prisma ORM, Zod validation, BullMQ, Ethers.js, OpenAPI
DB: PostgreSQL 15+, pg_partman (if needed), TimescaleDB extension optional for time series
Storage: IPFS (web3.storage/Pinata), S3-compatible (MinIO) for derived assets/caching
Blockchain: Solidity, Hardhat + OpenZeppelin, Slither, Echidna, Foundry (fast tests)
Indexing: Backend listens to contract events; optional The Graph
Auth: Keycloak (self-host) or Firebase Auth (faster demo); SIWE for wallet linking
DevOps: Docker Compose for local, Terraform (optional), Nginx reverse proxy
Security: JWT (short-lived), rotating secrets, role-based access control
Flutter: REST client (OpenAPI-generated), web_socket_channel, web3dart or WalletConnect, file_picker, camera, geolocator, dio
Core data model (DB)
users: id, email/phone, auth_provider, wallet_address (nullable), role
organizations: id, type (NGO/community/panchayat), KYC_status, admin_user_id
org_members: user_id, org_id, role
projects: id, org_id, name, type (mangrove/seagrass/saltmarsh), polygon_geojson, start_date, status
parcels: id, project_id, geojson, area_ha, baseline_year
device_registrations: id, org_id, device_serial, public_key, metadata
data_uploads: id, project_id, parcel_id, uploader_user_id, cid, sha256, upload_type (app/drone), captured_at, gps_bbox, metadata_json, signature, status
verifications: id, project_id, data_upload_id, verifier_user_id, method (field/desk), result (pass/fail), notes, evidence_cid, onchain_anchor_tx
carbon_batches: id, project_id, vintage_year, methodology_code, emission_reduction_tco2e, token_id, minted_tx, retired_amount
audit_logs: id, actor_user_id, action, entity, entity_id, diff_json, created_at
token_transfers: id, token_id, from, to, amount, tx_hash, block_number
settings: key, value_json
Smart contracts
Roles: DEFAULT_ADMIN_ROLE (NCCR multi-sig), VERIFIER_ROLE (NCCR-appointed), ISSUER_ROLE (registry), ORG_ROLE (optional tagging)
Contracts:
BlueCarbonRegistry: registers orgs, projects, MRV data anchors, associates CIDs/merkle roots, lifecycle states; only VERIFIER_ROLE can approve MRV packages.
BlueCarbonCredit1155: ERC-1155 token representing tCO2e batches by tokenId (per vintage/project/methodology). Only BlueCarbonRegistry can mint/burn. Includes retire() which burns and emits BatchRetired.
Token decimals: 2 (centi-ton) or 3 (kg-based), decide and be consistent.
Minimal ERC-1155 interface sketch:
EIP-712 typed data (field data attestation) for client-side signing:
End-to-end workflows
Onboarding (NGO/community/panchayat)
1) Admin creates organization and invites users.
2) KYC docs uploaded to IPFS; hash stored off-chain; status set by NCCR.
3) Optional: register org wallet on-chain in BlueCarbonRegistry.
Project creation
Org submits project with polygon, baseline year, methodology; NCCR approves.
Field/drone data capture
Flutter app captures images/video, GPS, timestamps, device public key; creates tar.gz.
App computes SHA-256; signs EIP-712 with wallet/device key (optional).
Upload to API → backend pins to IPFS, stores CID + hash + signature.
Verification and anchoring
Verifier reviews data; runs calculator; attaches notes and evidence CID.
On approval, backend calls BlueCarbonRegistry.anchorMRV(projectId, cid, sha256, meta) with VERIFIER_ROLE.
Event emitted and saved to DB.
Tokenization
Backend computes emission_reduction_tco2e per methodology; mints ERC-1155 via MINTER_ROLE to org/beneficiary; sets tokenURI to batch metadata CID.
Transfer/retire
Wallet-to-wallet transfer (standard ERC-1155) or gasless meta-tx.
Retirement uses retire(id, amount, reason), records event; backend indexes.
Registry view
Public endpoints display on-chain anchored hashes, CIDs, verifier, and credit status.
APIs (REST, versioned)
Auth
POST /v1/auth/signup, /v1/auth/login
GET /v1/auth/nonce → POST /v1/auth/siwe (wallet linking)
Organizations/Users
POST /v1/orgs, GET /v1/orgs/:id, POST /v1/orgs/:id/invite
POST /v1/admin/orgs/:id/kyc (NCCR only)
Projects
POST /v1/projects, GET /v1/projects, GET /v1/projects/:id
POST /v1/projects/:id/approve (NCCR)
Data uploads
POST /v1/uploads (multipart: file + JSON) → {cid, sha256}
GET /v1/uploads/:id
Verification
POST /v1/verifications (NCCR verifier): {uploadId, result, notes, evidenceCid}
POST /v1/verifications/:id/anchor (calls chain, stores tx)
Tokenization
POST /v1/batches/mint (NCCR/Registry): {projectId, vintage, tco2e, metadataCid}
GET /v1/batches, GET /v1/batches/:tokenId
POST /v1/batches/:tokenId/retire (wallet or meta-tx path)
Registry public
GET /v1/registry/projects/:id (on-chain + off-chain view)
GET /v1/registry/batches/:tokenId
Realtime
WS /v1/ws topics: upload.status, verification.status, chain.tx, batch.minted, batch.retired
Example upload request:
OpenAPI stub to generate Flutter client:
Carbon calculation (methodology module)
Start with a transparent, auditable baseline:
Mangroves: tCO2e = area_ha × biomass_growth_rate × carbon_fraction × permanence_factor − leakage
Configurable defaults from peer-reviewed sources; document constants.
Per-parcel, per-vintage results stored in carbon_batches with JSON inputs.
Implement as a pluggable service in backend:
calculators/mangrove.ts, calculators/seagrass.ts
Allow overrides by verifier; recompute and diff logged to audit_logs.
Testing strategy (continuous and demo-friendly)
Contracts
Unit tests: Hardhat + Foundry (forge test) for mint/retire/roles/anchoring flows
Static analysis: Slither; fuzz/property tests: Echidna
Gas and coverage reports; deploy to Polygon Amoy via CI; verify on Polygonscan
Backend
Unit tests: Jest + supertest for controllers/services
Integration: Spin ephemeral Postgres via Testcontainers; run migrations; seed data
E2E: Local Hardhat node + backend + Redis + IPFS in Docker Compose; run Postman/Newman collection
Contract event simulation: publish events in Hardhat to verify indexer
Data
Upload checks: hash consistency, EXIF timestamp/GPS sanity
Signature verification (EIP-712) for device/wallet on backend
Security
Zod schema validation at edges, file type scanning for uploads, rate limits
RBAC tests: only NCCR can approve/anchor/mint
Monitoring
Health endpoints /healthz, /readyz; Sentry error injection tests
Automation
GitHub Actions: lint+typecheck, contract tests, backend tests, Docker build, testnet deploy on main
DevOps and environments
Docker Compose services: api, worker, postgres, redis, ipfs (local), keycloak (optional), hardhat
Envs: LOCAL (compose), STAGING (Amoy), PROD (Polygon PoS)
Secrets via .env + GitHub Encrypted Secrets
Migrations with Prisma; seed script creates demo orgs/users/projects
Minimal docker-compose.yml sketch:
Flutter integration notes
Auth:
Start with email/OTP (Firebase Auth is fastest for demo). Backend validates Firebase tokens.
Wallet linking (optional): WalletConnect/Web3Auth; store address in users.wallet_address.
Uploads:
Use camera and image_picker to capture; zip with archive; compute SHA-256 (dart crypto); send multipart/form-data to /v1/uploads.
Display upload progress; on success, subscribe to WS upload.status.
Verification UX (verifier app or admin tool):
Show MRV package, allow approve/reject, trigger /v1/verifications/:id/anchor.
Token UX:
Read credits via REST and directly from chain using web3dart.
Retirement: either call contract with wallet or call backend meta-tx endpoint; show Polygonscan link.
Codegen:
Generate API client from OpenAPI using openapi-generator-cli with Dart.
Offline support:
Queue uploads when offline; sync later.
Repository structure
contracts/ (Hardhat + tests)
backend/
src/ (Nest modules: auth, orgs, projects, uploads, verifications, batches, registry, events)
src/calculators/ (methodology modules)
src/queues/ (pinToIpfs, anchorOnChain, mintBatch)
prisma/schema.prisma
ops/ (docker-compose.yml, k8s/ optional)
clients/flutter/ (generated API client and example screens)
postman/ (collection for demo)
Demo script (judge-friendly)
1) Log in as NGO on Flutter → create project.
2) Capture field/drone data → upload; see CID and immutable hash.
3) Switch to NCCR verifier → review package → approve → anchor MRV on chain (show tx link).
4) Mint credits for approved vintage (show ERC-1155 token and on-chain metadata).
5) Transfer credits to buyer or retire with reason → public registry shows retired status and proof.
6) Public page shows project → MRV proofs (IPFS CIDs + hashes) → credit lifecycle.
Security and compliance quick wins
PII kept off-chain; only hashes/CIDs on-chain; comply with DPDP Act.
Multi-sig for NCCR admin (Safe on Polygon).
Role-based checks in both backend and contracts; least privilege keys.
Signed MRV packages and verifier attestations; tamper-evident.
Milestone plan (5–7 day hackathon)
Day 1: Repos, Docker, DB schema, auth, contracts scaffold, OpenAPI
Day 2: Uploads → IPFS, signature verification, WS, seed demo data
Day 3: Verification flow, on-chain anchoring, indexer
Day 4: Calculator + minting, ERC-1155 integration, retire
Day 5: Polishing, CI, Postman demo, Flutter client integration
Buffer: Admin tools, dashboards, docs, demo script rehearsal
Regular testing at each step
After each module is built:
Run unit tests (npm run test), contracts (forge test), integration tests via Docker Compose.
Run Newman on postman/collection.json to validate API flows.
Deploy to Amoy and run an E2E script that: creates org → project → upload → verify → anchor → mint → retire; store outputs for demo.