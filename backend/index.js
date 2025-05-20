const express = require('express');
const app = express();
const cors = require('cors');

// Middlewares
app.use(cors());
app.use(express.json());

// Importar rutas
const eventRoutes = require('./routes/eventRoutes');
app.use('/api/eventos', eventRoutes); // <- Asegúrate de que esto esté presente

// Iniciar servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});
