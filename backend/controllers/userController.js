const admin = require('../config/firebase'); // Para autenticación Firebase
const db = require('../config/db'); // conexión a PostgreSQL

exports.registerUser = async (req, res) => {
  const { email, password, name } = req.body;
  try {
    // Crear usuario Firebase
    const userRecord = await admin.auth().createUser({ email, password, displayName: name });

    // Guardar usuario en BD (ejemplo)
    await db.query('INSERT INTO users (uid, email, name) VALUES ($1, $2, $3)', [userRecord.uid, email, name]);

    res.status(201).json({ message: 'Usuario registrado', uid: userRecord.uid });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.loginUser = async (req, res) => {
  // Login se maneja en frontend con FirebaseAuth directamente, backend puede verificar token si es necesario
  res.status(200).json({ message: 'Login manejado en frontend' });
};

exports.getProfile = async (req, res) => {
  // Ejemplo: obtener uid desde token (middleware)
  const uid = req.user.uid; // suponiendo middleware autenticación
  try {
    const result = await db.query('SELECT uid, email, name FROM users WHERE uid=$1', [uid]);
    res.status(200).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
