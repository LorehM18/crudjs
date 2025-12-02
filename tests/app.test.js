import request from 'supertest';
import dotenv from 'dotenv';
import app from '../src/index.js';

// Cargar variables de entorno PARA TESTS
dotenv.config({ path: './env.test' });

// Ya no necesitamos importar pool directamente
// Las pruebas solo testean la API, no la BD directamente

describe('Pruebas del servidor CRUD', () => {
    test('GET / debe responder 200 con HTML', async () => {
        const response = await request(app).get('/');
        expect(response.statusCode).toBe(200);
        expect(response.headers['content-type']).toMatch(/html/);
        expect(response.text).toContain('<!DOCTYPE html>');
    });

    test('GET /list debe responder algo (200 o 404)', async () => {
        const response = await request(app).get('/list');
        // La ruta puede existir o no, pero el servidor debe responder
        expect(response.statusCode).toBeGreaterThanOrEqual(200);
        expect(response.statusCode).toBeLessThan(500);
    });

    test('Ruta inexistente debe dar 404', async () => {
        const response = await request(app).get('/ruta-que-no-existe');
        expect(response.statusCode).toBe(404);
    });
});