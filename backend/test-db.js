const pool = require('./db');

pool.connect()
  .then(client => {
    console.log('✅ Conectado a la base de datos correctamente');
    client.release(); // muy importante
  })
  .catch(err => {
    console.error('❌ Error al conectar a la base de datos:', err);
  });
