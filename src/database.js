import { createPool } from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

const pool = createPool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'Datos2025',
    database: process.env.DB_NAME || 'Prueba01'
});

export default pool;
