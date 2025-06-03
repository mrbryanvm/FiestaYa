const db = require('../config/db');
async function crearUsuario(data) {
  const { nomUsuario, contrasena, correoElectronico, departamentoId } = data;
  const result = await db.query(
    `INSERT INTO progra.Usuario(nomUsuario, contrasena, correoElectronico, Departamento_idDepartamento)
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [nomUsuario, contrasena, correoElectronico, departamentoId]
  );
  return result.rows[0];
}
async function loginUsuario(correo, contrasena) {
  const result = await db.query(
    `SELECT * FROM progra.Usuario WHERE correoElectronico = $1 AND contrasena = $2`,
    [correo, contrasena]
  );
  return result.rows[0];
}
module.exports = { crearUsuario, loginUsuario };