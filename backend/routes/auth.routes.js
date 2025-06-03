const express = require('express');
const router = express.Router();
const authCtrl = require('../controllers/auth.controller');
router.post('/registro', authCtrl.registrar);
router.post('/login', authCtrl.login);
module.exports = router;