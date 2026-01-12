import request from 'supertest';
import app from '../server';

describe('Health API Tests', () => {
  it('GET /health returns 200 with correct schema', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({
      status: 'healthy',
      service: 'health-api',
      version: '1.0.0'
    });
  });

  it('GET / returns service info', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Health API Service');
  });

  it('GET /nonexistent returns 404', async () => {
    const res = await request(app).get('/nonexistent');
    expect(res.status).toBe(404);
    expect(res.body.error).toBe('Not Found');
  });
});