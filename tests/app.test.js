import request from 'supertest';
import app from '../src/index.js';

describe('Pruebas del servidor CRUD', () => {
  test('GET / debe responder 200', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
  });

  test('GET /list debe responder 200', async () => {
    const response = await request(app).get('/list');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('<');
  });
});



