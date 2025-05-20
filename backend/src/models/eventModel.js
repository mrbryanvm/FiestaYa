// src/models/eventModel.js
const db = require('../db'); // Importa la conexión a la base de datos

const Event = {
  // Método para crear un nuevo evento en la base de datos
  create: async (eventData) => {
    const query = `
      INSERT INTO events (title, description, location, date, time, user_id)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;
    const values = [
      eventData.title,
      eventData.description,
      eventData.location,
      eventData.date,
      eventData.time,
      eventData.user_id,
    ];

    const result = await db.query(query, values);  // Ejecuta la consulta en la base de datos
    return result.rows[0];  // Devuelve el evento creado
  },

  // Método para obtener todos los eventos
  getAll: async () => {
    const query = 'SELECT * FROM events';
    const result = await db.query(query);
    return result.rows;  // Devuelve todos los eventos
  }
};

module.exports = Event;
