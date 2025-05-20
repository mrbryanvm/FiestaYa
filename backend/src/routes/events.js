const express = require('express');
const router = express.Router();
const { createEvent } = require('../controllers/eventController');

// Ruta para crear un evento
router.post('/create', createEvent);

module.exports = router;
