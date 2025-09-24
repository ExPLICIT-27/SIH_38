import { Injectable, Logger } from '@nestjs/common';
import { readFile } from 'fs/promises';

@Injectable()
export class IpfsService {
  private readonly logger = new Logger(IpfsService.name);
  private readonly token = process.env.WEB3_STORAGE_TOKEN || '';
  private readonly apiUrl =
    process.env.IPFS_API_URL?.replace(/\/$/, '') || 'http://127.0.0.1:5001';

  async pinFile(filePath: string, fileName: string): Promise<string | null> {
    // 1) Try local Kubo HTTP API first
    try {
      const form = new FormData();
      const buffer = await readFile(filePath);
      const blob = new Blob([new Uint8Array(buffer)]);
      form.append('file', blob, fileName);

      const url = `${this.apiUrl}/api/v0/add?pin=true&cid-version=1`;
      const res = await fetch(url, { method: 'POST', body: form });
      if (!res.ok) {
        const errText = await res.text();
        throw new Error(`Kubo add failed: ${res.status} ${errText}`);
      }
      const bodyText = await res.text();
      // Kubo returns NDJSON, pick the last non-empty JSON line
      const lines = bodyText
        .split('\n')
        .map((l) => l.trim())
        .filter((l) => l.length > 0);
      if (lines.length > 0) {
        const last = JSON.parse(lines[lines.length - 1]) as {
          Name?: string;
          Hash?: string; // CID string
          Size?: string;
        };
        if (last?.Hash) {
          return last.Hash;
        }
      }
      this.logger.warn('Kubo add response missing CID');
    } catch (err) {
      this.logger.warn(`Kubo IPFS add failed: ${(err as Error).message}`);
    }

    // 2) Fallback to Web3.Storage if token present
    if (!this.token) {
      this.logger.warn(
        'WEB3_STORAGE_TOKEN not set; skipping Web3.Storage fallback',
      );
      return null;
    }
    try {
      const buffer = await readFile(filePath);
      const file = new File([new Uint8Array(buffer)], fileName);
      const form = new FormData();
      form.append('file', file);
      const res = await fetch('https://api.web3.storage/upload', {
        method: 'POST',
        headers: { Authorization: `Bearer ${this.token}` },
        body: form,
      });
      if (!res.ok) {
        const text = await res.text();
        this.logger.error(`Web3.Storage upload failed: ${res.status} ${text}`);
        return null;
      }
      const json = (await res.json()) as { cid?: string };
      return json.cid ?? null;
    } catch (err) {
      this.logger.error('Web3.Storage pin error', err as Error);
      return null;
    }
  }
}
