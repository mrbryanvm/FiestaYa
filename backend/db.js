// db.js
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',         // Cambia esto si tu usuario de PostgreSQL es otro
  host: 'localhost',
  database: 'FiestaYa',     // Asegúrate de que esta base de datos exista
  password: 'Gianinna1',// Reemplaza con tu contraseña real
  port: 5432,
});

module.exports = pool;
