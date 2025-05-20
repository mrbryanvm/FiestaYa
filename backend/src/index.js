const express = require('express');
const app = express();
const eventRoutes = require('./routes/eventRoutes'); // Asegúrate de que la ruta esté correcta

app.use(express.json()); // Middleware para poder trabajar con JSON en las solicitudes
app.use('/api/events', eventRoutes); // Asegura que las rutas de los eventos estén registradas en /api/events

app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
