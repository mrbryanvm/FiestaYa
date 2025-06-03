require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Conexión a PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'FiestaYa',
  password: process.env.DB_PASSWORD,
  port: 5432,
});

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('API FiestaYa funcionando correctamente!');
});
// Ruta para obtener todos los departamentos
app.get('/departamentos', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM progra.departamento');
    res.json(resultado.rows);
  } catch (error) {
    console.error('Error al obtener departamentos:', error);
    res.status(500).json({ error: 'Error al obtener los departamentos' });
  }
});
// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});
