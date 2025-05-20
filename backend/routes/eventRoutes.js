const express = require('express');
const router = express.Router();
const { createEventHandler } = require('../controllers/eventController');// <-- Importar el controlador

// Ruta GET
router.get('/', (req, res) => {
  res.json([
    { id: 1, nombre: 'Concierto de Rock', fecha: '2025-06-01' },
    { id: 2, nombre: 'Feria Gastronómica', fecha: '2025-06-10' }
  ]);
});

// ✅ Ruta POST para recibir eventos desde Flutter
router.post('/', createEventHandler);

module.exports = router;


