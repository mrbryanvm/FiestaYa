const { Client } = require('pg'); // Importamos el cliente de PostgreSQL

// Crear el cliente de PostgreSQL
const client = new Client({
  user: 'postgres', // Nombre del usuario de la base de datos
  host: 'localhost', // Host de la base de datos
  database: 'events_db', // Nombre de la base de datos
  password: 'Gianinna1', // Contraseña de la base de datos
  port: 5432, // Puerto por defecto de PostgreSQL
});

// Conectar al cliente de la base de datos
client.connect()
  .then(() => console.log('Conexión exitosa a la base de datos'))
  .catch(err => console.error('Error al conectar a la base de datos', err));

module.exports = client; // Exportamos el cliente para usarlo en otras partes de la app
