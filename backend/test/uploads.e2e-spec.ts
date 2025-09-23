/* eslint-env jest */
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';
import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';

describe('Uploads (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('POST /v1/uploads should accept a file', async () => {
    const tmpPath = join(__dirname, 'tmp.txt');
    writeFileSync(tmpPath, 'hello');
    const res = await request(app.getHttpServer())
      .post('/v1/uploads')
      .attach('file', tmpPath)
      .field('capturedAt', `${Math.floor(Date.now() / 1000)}`)
      .expect(201);
    expect(res.body.id).toBeDefined();
    expect(res.body.sha256).toBeDefined();
  });
});


