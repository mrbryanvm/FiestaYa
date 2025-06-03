const admin = require('../config/firebase');
const pool = require('../config/db');

const verifyGoogleToken = async (req, res) => {
  const { token } = req.body;

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    const { uid, name, email, picture } = decoded;

    // Verificar si el usuario ya está registrado
    const result = await pool.query('SELECT * FROM usuarios WHERE uid = $1', [uid]);

    if (result.rows.length === 0) {
      // Registrar nuevo usuario
      await pool.query(
        'INSERT INTO usuarios (uid, nombre, correo, foto) VALUES ($1, $2, $3, $4)',
        [uid, name, email, picture]
      );
    }

    res.json({ uid, name, email, picture });

  } catch (error) {
    console.error('Error verificando token:', error);
    res.status(401).json({ error: 'Token inválido' });
  }
};

module.exports = { verifyGoogleToken };
