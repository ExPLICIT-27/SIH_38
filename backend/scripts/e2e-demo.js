const base = process.env.BASE_URL || 'http://localhost:3000';

async function http(method, path, body, headers = {}) {
  const opts = { method, headers: { ...headers } };
  if (body && !(body instanceof FormData)) {
    opts.headers['Content-Type'] = 'application/json';
    opts.body = JSON.stringify(body);
  } else if (body instanceof FormData) {
    opts.body = body;
  }
  const res = await fetch(base + path, opts);
  const text = await res.text();
  let data;
  try { data = JSON.parse(text); } catch { data = text; }
  if (!res.ok) throw new Error(`${method} ${path} -> ${res.status}: ${text}`);
  return data;
}

async function main() {
  console.log('Health live:', await http('GET', '/health/live'));

  // Auth (optional)
  const email = `user${Date.now()}@example.com`;
  const otp = await http('POST', '/v1/auth/request-otp', { email });
  const login = await http('POST', '/v1/auth/login', { email, code: otp.code });
  console.log('Auth token len:', login.token?.length);

  // Org and Project
  const org = await http('POST', '/v1/orgs', { name: 'Demo Panchayat', type: 'panchayat', mode: 'SELLER' });
  console.log('Org:', org.id);
  const project = await http('POST', '/v1/projects', { orgId: org.id, name: 'Mangrove Plot A', type: 'mangrove', areaHa: 1.5 });
  await http('POST', `/v1/projects/${project.id}/approve`);

  // Upload
  const form = new FormData();
  const file = new File([new TextEncoder().encode('hello world')], 'tmp.txt');
  form.append('file', file);
  form.append('capturedAt', String(Math.floor(Date.now()/1000)));
  form.append('metadata', JSON.stringify({ gps: '0,0', projectId: project.id }));
  const up = await http('POST', '/v1/uploads', form);
  console.log('Upload:', up.id, up.sha256);

  // Deploy contracts
  const dep = await http('POST', '/v1/chain/deploy');
  console.log('Deployed:', dep);
  await http('POST', '/v1/registry/settings', { creditAddress: dep.creditAddress, registryAddress: dep.registryAddress });

  // Anchor
  const anc = await http('POST', '/v1/chain/anchor', { registryAddress: dep.registryAddress, uploadId: up.id, sha256: up.sha256, cid: up.cid || '' });
  console.log('Anchored tx:', anc.tx);
  await http('POST', '/v1/registry/verify', { uploadId: up.id, approved: true, notes: 'ok', anchoredTx: anc.tx });

  // Mint and retire
  const to = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266';
  const mint = await http('POST', '/v1/chain/mint', { creditAddress: dep.creditAddress, to, id: '1', amount: '100' });
  console.log('Mint tx:', mint.tx);
  const retire = await http('POST', '/v1/chain/retire', { creditAddress: dep.creditAddress, id: '1', amount: '40', reason: 'demo' });
  console.log('Retire tx:', retire.tx);

  // Read upload
  const up2 = await http('GET', `/v1/uploads/${up.id}`);
  console.log('Upload fetched status:', up2.status, 'cid:', up2.cid);

  console.log('\nSUCCESS: end-to-end demo completed.');
}

main().catch((err) => { console.error('E2E failed:', err.message); process.exit(1); });
