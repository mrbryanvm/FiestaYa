const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Ruta para registro o login con Firebase token
router.post('/login', authController.login);

// Ruta para logout si quieres (opcional)
router.post('/logout', authController.logout);

module.exports = router;
