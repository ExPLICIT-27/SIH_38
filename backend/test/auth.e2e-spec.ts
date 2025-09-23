/* eslint-env jest */
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';

describe('Auth (e2e)', () => {
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

  it('OTP login flow returns a JWT', async () => {
    const email = `user${Date.now()}@example.com`;
    const otpRes = await request(app.getHttpServer())
      .post('/v1/auth/request-otp')
      .send({ email })
      .expect(201);
    const { code } = otpRes.body;

    const loginRes = await request(app.getHttpServer())
      .post('/v1/auth/login')
      .send({ email, code })
      .expect(201);
    expect(loginRes.body.token).toBeDefined();
  });
});


