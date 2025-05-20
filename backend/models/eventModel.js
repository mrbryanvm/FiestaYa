const pool = require('../db'); // importa la conexión a PostgreSQL

// Función para crear un evento
const createEvent = async (eventData) => {
  const { user_id, title, description, date, time, location } = eventData;

  const result = await pool.query(
    `INSERT INTO events (user_id, title, description, date, time, location)
     VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
    [user_id, title, description, date, time, location]
  );

  return result.rows[0]; // Devuelve el evento recién creado
};

module.exports = { createEvent };
