// tests/app.test.js
import request from 'supertest';
import app from '../src/index.js'; // tu servidor Express
import pool from '../db'; // tu conexión a MySQL

// Se ejecuta antes de todos los tests
beforeAll(async () => {
  const conn = await pool.getConnection();

  // Crear tabla si no existe
  await conn.query(`
    CREATE TABLE IF NOT EXISTS list (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL
    )
  `);

  // Insertar datos de ejemplo
  await conn.query(`
    INSERT INTO list (name) VALUES ('Item1'), ('Item2')
  `);

  conn.release();
});

// Se ejecuta después de todos los tests
afterAll(async () => {
  const conn = await pool.getConnection();

  // Limpiar tabla al final
  await conn.query(`DROP TABLE IF EXISTS list`);

  conn.release();

  // Cerrar conexión de pool
  await pool.end();
});

describe('Pruebas del servidor CRUD', () => {
  test('GET / debe responder 200', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('<'); // Ajusta según tu respuesta HTML/JSON
  });

  test('GET /list debe responder 200', async () => {
    const response = await request(app).get('/list');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('Item1'); // Verifica que los datos estén
    expect(response.text).toContain('Item2');
  });
});



