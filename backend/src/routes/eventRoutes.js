const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');

// Ruta para crear un evento
router.post('/', eventController.createEvent);

module.exports = router;
