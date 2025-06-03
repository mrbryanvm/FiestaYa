const authModel = require('../models/auth.model');
exports.registrar = async (req, res) => {
  try {
    const user = await authModel.crearUsuario(req.body);
    res.status(201).json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
exports.login = async (req, res) => {
  try {
    const { correoElectronico, contrasena } = req.body;
    const user = await authModel.loginUsuario(correoElectronico, contrasena);
    if (user) res.status(200).json(user);
    else res.status(401).json({ mensaje: "Credenciales incorrectas" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};