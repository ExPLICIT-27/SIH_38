import { Injectable, Logger } from '@nestjs/common';
import { readFile } from 'fs/promises';

@Injectable()
export class IpfsService {
  private readonly logger = new Logger(IpfsService.name);
  private readonly token = process.env.WEB3_STORAGE_TOKEN || '';

  async pinFile(filePath: string, fileName: string): Promise<string | null> {
    if (!this.token) {
      this.logger.warn('WEB3_STORAGE_TOKEN not set; skipping IPFS pin');
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
        body: form as any,
      });
      if (!res.ok) {
        const text = await res.text();
        this.logger.error(`IPFS upload failed: ${res.status} ${text}`);
        return null;
      }
      const json = (await res.json()) as { cid?: string };
      return json.cid ?? null;
    } catch (err) {
      this.logger.error('IPFS pin error', err as Error);
      return null;
    }
  }
}


