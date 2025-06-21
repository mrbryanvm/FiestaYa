const express = require('express');
const cors = require ('cors');
const pool = require('./db');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor escuchando en http://0.0.0.0:${PORT}`);
});

app.get('/departamentos', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT iddepartamento, nombredep
      FROM progra.departamento;
    `);
    console.log(`Departamentos encontrados: ${result.rowCount}`);
    console.table(result.rows);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener departamentos:', error);
    res.status(500).json({ error: 'Error al obtener departamentos' });
  }
});

app.get('/categorias', async (req, res) => {
  const { idProveedor } = req.query;

  if (!idProveedor) {
    return res.status(400).json({ error: 'El parámetro idProveedor es requerido' });
  }

  try {
    const result = await pool.query(`
      SELECT idpreferenciaserv, categoria
      FROM progra.preferenciaserv
      WHERE proveedor_idproveedor = $1 `
    , [idProveedor]);

    console.log(`🔍 Categorías encontradas para proveedor ${idProveedor}: ${result.rowCount}`);
    console.table(result.rows);

    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener categorías:', error);
    res.status(500).json({ error: 'Error al obtener categorías' });
  }
});

app.get('/productosPropios', async (req, res) => {
  const { idProveedor } = req.query;

  if (!idProveedor) {
    return res.status(400).json({ error: 'El parámetro idProveedor es requerido' });
  }

  try {
    const result = await pool.query(`
      SELECT 
        p.idproducto,
        p.nombre,
        p.descripcion,
        p.precio,
        p.disponible,
        p.preferenciaserv_idpreferenciaserv,
        p.preferenciaserv_proveedor_idproveedor,
        p.catalogo_proveedor_usuario_idusuario,
        ps.categoria AS categoria,
        p.catalogo_idcatalogo,
        p.imagen
      FROM progra.producto p
      JOIN progra.preferenciaserv ps
        ON p.preferenciaserv_idpreferenciaserv = ps.idpreferenciaserv
        AND p.preferenciaserv_proveedor_idproveedor = ps.proveedor_idproveedor
        AND p.preferenciaserv_proveedor_usuario_idusuario = ps.proveedor_usuario_idusuario
      WHERE p.catalogo_proveedor_idproveedor = $1
    `, [idProveedor]);

    console.log(`📦 Productos encontrados para proveedor ${idProveedor}: ${result.rowCount}`);
    console.table(result.rows);
    console.log(JSON.stringify(result.rows, null, 2));
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener productos:', error);
    res.status(500).json({ error: 'Error al obtener productos' });
  }
});

app.get('/productos', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        p.idproducto,
        p.nombre,
        p.descripcion,
        p.precio,
        p.disponible,
        p.preferenciaserv_idpreferenciaserv,
        p.preferenciaserv_proveedor_idproveedor,
        p.catalogo_proveedor_usuario_idusuario,
        ps.categoria AS categoria,
        p.catalogo_idcatalogo,
        p.imagen
      FROM progra.producto p
      JOIN progra.preferenciaserv ps
        ON p.preferenciaserv_idpreferenciaserv = ps.idpreferenciaserv
        AND p.preferenciaserv_proveedor_idproveedor = ps.proveedor_idproveedor
        AND p.preferenciaserv_proveedor_usuario_idusuario = ps.proveedor_usuario_idusuario
    `);

    console.log(`📦 Productos encontrados para proveedor: ${result.rowCount}`);
    console.table(result.rows);
    console.log(JSON.stringify(result.rows, null, 2));
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener productos:', error);
    res.status(500).json({ error: 'Error al obtener productos' });
  }
});

app.get('/perfilProv', async (req, res) => {
  const { idUsuario } = req.query;

  if (!idUsuario) {
    return res.status(400).json({ error: 'El parámetro idUsuario es requerido' });
  }

  try {
    const result = await pool.query(`
      SELECT 
        u.idusuario,
        u.nomusuario,
        u.contrasena,
        u.correoelectronico,
        u.perfil,
        d.nombredep AS departamento,
        pr.nombrenegocio,
        pr.propietario,
        pr.telefono,
        pr.ubicacion
      FROM progra.usuario u
      JOIN progra.proveedor pr 
        ON u.idusuario = pr.usuario_idusuario
      JOIN progra.departamento d
        ON u.departamento_iddepartamento = d.iddepartamento
      WHERE u.idusuario = $1;
    `, [idUsuario]);

    console.log(`🔍 Datos del usuario ${idUsuario}: ${result.rowCount}`);
    console.table(result.rows);

    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener Datos del proveedor', error);
    res.status(500).json({ error: 'Error al obtener Datos' });
  }
});

app.get('/perfilOrg', async (req, res) => {
  const { idUsuario } = req.query;

  if (!idUsuario) {
    return res.status(400).json({ error: 'El parámetro idUsuario es requerido' });
  }

  try {
    const result = await pool.query(`
      SELECT 
        u.idusuario,
        u.nomusuario,
        u.contrasena,
        u.correoelectronico,
        u.perfil,
        d.nombredep AS departamento,
        o.nombrecompleto,
        o.telefonoorg
      FROM progra.usuario u
      JOIN progra.organizador o 
        ON u.idusuario = o.usuario_idusuario
      JOIN progra.departamento d
        ON u.departamento_iddepartamento = d.iddepartamento
      WHERE u.idusuario = $1;
    `, [idUsuario]);

    console.log(`🔍 Datos del usuario ${idUsuario}: ${result.rowCount}`);
    console.table(result.rows);

    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener Datos del proveedor', error);
    res.status(500).json({ error: 'Error al obtener Datos' });
  }
});

app.get('/eventos', async (req, res) => {
  const { idUsuario } = req.query;
  if (!idUsuario) {
    return res.status(400).json({ error: 'El parámetro idUsuario es requerido' });
  }

  try {
    const resultado = await pool.query(`
      SELECT 
        e.idevento,
        e.nombreevento,
        e.fechaevento,
        e.ubicacion,
        e.numeroasistentes,
        e.departamento_iddepartamento,
        d.nombredep,
        e.descripcion,
        e.organizador_idorganizador,
        e.organizador_usuario_idusuario
      FROM progra.evento e
      JOIN progra.departamento d ON e.departamento_iddepartamento = d.iddepartamento
      WHERE e.organizador_usuario_idusuario = $1;
    `,[idUsuario]);
    console.log(`🔍 Eventos del usuario ${idUsuario}: ${resultado.rowCount}`);
    console.table(resultado.rows);

    res.json(resultado.rows);
  } catch (error) {
    console.error('❌ Error al obtener eventos:', error);
    res.status(500).json({ error: 'Error al obtener eventos' });
  }
});

app.get('/autenticacion', async (req, res) => {
  const { nomusuario, correoelectronico, contrasena } = req.query;

  if (!nomusuario && !correoelectronico && !contrasena) {
    return res.status(400).json({
      error: 'Se requiere al menos uno de los parámetros: nomusuario, correoelectronico o contrasena'
    });
  }

  try {
    const result = await pool.query(`
      SELECT idusuario
      FROM progra.usuario
      WHERE (nomusuario = $1
        OR correoelectronico = $2)
        AND contrasena = $3;
    `, [nomusuario || '', correoelectronico || '', contrasena || '']);

    console.log(`🔍 Resultado autenticación: ${result.rowCount} coincidencias`);
    console.table(result.rows);

    if(result.rowCount === 0){
      return res.status(401).json({error: 'Credenciales incorrectas'});
    }

    const idusuario = result.rows[0]?.idusuario;

    const organizadorResult = await pool.query(`
      SELECT idorganizador, nombrecompleto
      FROM progra.organizador
      WHERE usuario_idusuario = $1
    `, [idusuario]);

    if (organizadorResult.rowCount > 0){
      return res.status(200).json({
        idusuario: idusuario,
        tipoUsuario:'organizador',
        idorganizador: organizadorResult.rows[0].idorganizador,
        nombre: organizadorResult.rows[0].nombrecompleto
      });
    }

    const proveedorResult = await pool.query(`
      SELECT idproveedor, nombrenegocio
      FROM progra.proveedor
      WHERE usuario_idusuario = $1
    `, [idusuario]);
    console.log('Proveedor encontrado:', proveedorResult.rows[0]);


    if (proveedorResult.rowCount > 0){
      return res.status(200).json({
        idusuario: idusuario,
        tipoUsuario: 'proveedor',
        idproveedor: proveedorResult.rows[0].idproveedor,
        empresa: proveedorResult.rows[0].nombrenegocio
      });
    }
    console.log('Resultado proveedor:', proveedorResult.rows);


    return res.status(403).json ({
      error: 'El usuario no esta registrado con ningún rol'
    })

  } catch (error) {
    console.error('❌ Error en autenticación', error);
    res.status(500).json({ error: 'Error al autenticar usuario' });
  }
});

app.get('/redesSociales', async (req, res) => {
  const { idusuario } = req.query;

  if (!idusuario) {
    return res.status(400).json({ error: 'El parámetro idusuario es obligatorio.' });
  }

  try {
    const result = await pool.query(`
      SELECT idredsocial, nombrered, enlace, descripcion
      FROM progra.redsocial
      WHERE proveedor_usuario_idusuario = $1
    `, [idusuario]);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener redes sociales:', error);
    res.status(500).json({ error: 'Error al obtener redes sociales.' });
  }
});

app.get('/contratos', async (req, res) => {
  const { idUsuario } = req.query;

  if (!idUsuario) {
    return res.status(400).json({ error: 'El parámetro idProveedor es requerido' });
  }

  try {
    const result = await pool.query(
      `
      SELECT estado, fechacontrato, detalles,
        organizador_idorganizador1,
        organizador_usuario_idusuario,
        proveedor_idproveedor1,
        proveedor_usuario_idusuario,
        producto_idproducto,
        producto_catalogo_idcatalogo,
        evento_idevento
      FROM progra.contrato
      WHERE proveedor_usuario_idusuario = $1 OR organizador_usuario_idusuario = $1;
    `, [idUsuario]);

    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error al obtener contratos:', error);
    res.status(500).json({ error: 'Error al obtener contratos' });
  }
});

app.get('/mensajes', async (req, res) => {
  const { idUsuario } = req.query;

  if (!idUsuario) {
    return res.status(400).json({ error: 'El parámetro idProveedor es requerido' });
  }

  try {
    const resultado = await pool.query(`
      SELECT idmensaje, remitente, contenido, fechahora
      FROM progra.mensaje
      WHERE destinatario = $1
      ORDER BY fechahora DESC
    `, [idUsuario]);

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error('Error al obtener mensajes:', error);
    res.status(500).json({ error: 'Error al obtener los mensajes' });
  }
});


app.post('/registrar-organizador', async (req, res) => {
  const {
    nomusuario,
    contrasena,
    correoelectronico,
    departamento_iddepartamento,
    nombrecompleto,
    telefonoorg,
    fechanacimiento
  } = req.body;

  console.log('📥 Datos recibidos en /registrar-organizador:');
  console.table(req.body);

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    const insertUsuarioQuery = `
      INSERT INTO progra.usuario(nomusuario, contrasena, correoelectronico, departamento_iddepartamento)
      VALUES ($1, $2, $3, $4)
      RETURNING idusuario;
    `;
    const usuarioResult = await client.query(insertUsuarioQuery, [
      nomusuario,
      contrasena,
      correoelectronico,
      departamento_iddepartamento
    ]);

    const usuarioId = usuarioResult.rows[0].idusuario;
    console.log(`✅ Usuario registrado con ID: ${usuarioId}`);

    const insertOrganizadorQuery = `
      INSERT INTO progra.organizador(
	      nombrecompleto, telefonoorg, fechanacimiento, usuario_idusuario)
      VALUES ($1, $2, $3, $4)
      RETURNING idorganizador;
    `;
    const organizadorResult = await client.query(insertOrganizadorQuery, [
      nombrecompleto,
      telefonoorg,
      fechanacimiento,
      usuarioId
    ]);
    const organizadorId = organizadorResult.rows[0].idorganizador;
    console.log(`✅ Organizador "${nombrecompleto}" registrado para usuario ID ${usuarioId} con ID: ${organizadorId}`);

    await client.query('COMMIT');
    console.log('✅ Transacción completada correctamente');

    res.status(201).json({ 
      message: 'organizador registrado con éxito',
      idusuario: usuarioId,
      idorganizador: organizadorId 
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error al registrar organizador:', error);
    res.status(500).json({ error: 'Error al registrar organizador' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.post('/registrar-proveedor', async (req, res) => {
  const {
    nomusuario,
    contrasena,
    correoelectronico,
    departamento_iddepartamento,
    nombrenegocio,
    propietario,
    telefono,
    ubicacion
  } = req.body;

  console.log('📥 Datos recibidos en /registrar-proveedor:');
  console.table(req.body);

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    const insertUsuarioQuery = `
      INSERT INTO progra.usuario(nomusuario, contrasena, correoelectronico, departamento_iddepartamento)
      VALUES ($1, $2, $3, $4)
      RETURNING idusuario;
    `;
    const usuarioResult = await client.query(insertUsuarioQuery, [
      nomusuario,
      contrasena,
      correoelectronico,
      departamento_iddepartamento
    ]);

    const usuarioId = usuarioResult.rows[0].idusuario;
    console.log(`✅ Usuario registrado con ID: ${usuarioId}`);

    const insertProveedorQuery = `
      INSERT INTO progra.proveedor(nombrenegocio, propietario, telefono, ubicacion, usuario_idusuario)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING idproveedor;
    `;
    const proveedorResult = await client.query(insertProveedorQuery, [
      nombrenegocio,
      propietario,
      telefono,
      ubicacion,
      usuarioId
    ]);
    const proveedorId = proveedorResult.rows[0].idproveedor;
    console.log(`✅ Proveedor "${nombrenegocio}" registrado para usuario ID ${usuarioId} con ID: ${proveedorId}`);

    await client.query('COMMIT');
    console.log('✅ Transacción completada correctamente');

    res.status(201).json({ 
      message: 'Proveedor registrado con éxito',
      idusuario: usuarioId,
      idproveedor: proveedorId 
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error al registrar proveedor:', error);
    res.status(500).json({ error: 'Error al registrar proveedor' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.post('/registrar-preferencias', async (req, res) => {
  const { categorias, idproveedor, idusuario } = req.body;

  console.log('📥 Preferencias recibidas:');
  console.log('Categorías:', categorias);
  console.log('Proveedor ID:', idproveedor, 'Usuario ID:', idusuario);

  if (!categorias || !Array.isArray(categorias)) {
    return res.status(400).json({ error: 'categorias debe ser un array' });
  }

  if (!idproveedor || !idusuario) {
    return res.status(400).json({ error: 'Faltan idproveedor o idusuario' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    for (const categoria of categorias) {
      await client.query(`
        INSERT INTO progra.preferenciaserv(categoria, proveedor_idproveedor, proveedor_usuario_idusuario)
        VALUES ($1, $2, $3)
      `, [categoria, idproveedor, idusuario]);
      console.log(`✅ Preferencia "${categoria}" registrada`);
    }

    await client.query('COMMIT');
    res.status(201).json({ message: 'Preferencias registradas con éxito' });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error al registrar preferencias:', error);
    res.status(500).json({ error: 'Error al registrar preferencias' });
  } finally {
    client.release();
  }
});

app.post('/crear-catalogo-producto', async (req, res) => {
  const {
    empresa,
    proveedor_idproveedor,
    proveedor_usuario_idusuario,
    nombre_producto,
    descripcion,
    precio,
    idpreferenciaserv,
    imagen
  } = req.body;

  console.log('📥 Datos recibidos en /crear-catalogo-producto:');
  console.table(req.body);

  if (!empresa || !proveedor_idproveedor || !proveedor_usuario_idusuario || !nombre_producto || !precio || !idpreferenciaserv) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    const insertCatalogoQuery = `
      INSERT INTO progra.catalogo(empresa, "fechacreación", proveedor_idproveedor, proveedor_usuario_idusuario)
      VALUES ($1, CURRENT_TIMESTAMP, $2, $3)
      RETURNING idcatalogo;
    `;

    const catalogoResult = await client.query(insertCatalogoQuery, [
      empresa,
      proveedor_idproveedor,
      proveedor_usuario_idusuario
    ]);

    const idcatalogo = catalogoResult.rows[0].idcatalogo;
    console.log(`✅ Catálogo creado con ID: ${idcatalogo}`);

    const insertProductoQuery = `
      INSERT INTO progra.producto(
        nombre, descripcion, precio,
        preferenciaserv_idpreferenciaserv,
        preferenciaserv_proveedor_idproveedor,
        preferenciaserv_proveedor_usuario_idusuario,
        catalogo_idcatalogo,
        catalogo_proveedor_idproveedor,
        catalogo_proveedor_usuario_idusuario,
        imagen
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    `;

    await client.query(insertProductoQuery, [
      nombre_producto,
      descripcion,
      precio,
      idpreferenciaserv,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      idcatalogo,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      imagen
    ]);

    await client.query('COMMIT');
    console.log('✅ Catálogo y producto insertados correctamente');

    res.status(201).json({
      message: 'Catálogo y producto creados con éxito',
      idcatalogo: idcatalogo
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error en creación conjunta:', error);
    res.status(500).json({ error: 'Error al crear catálogo y producto' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.post('/agregar_producto', async (req, res) => {
  const {
    proveedor_idproveedor,
    proveedor_usuario_idusuario,
    nombre_producto,
    descripcion,
    precio,
    idpreferenciaserv,
    imagen,
    idcatalogo
  } = req.body;

  console.log('📥 Datos recibidos en /añadir_producto:');
  console.table(req.body);

  if (
    !proveedor_idproveedor || !proveedor_usuario_idusuario ||
    !nombre_producto || !precio || !idpreferenciaserv || !idcatalogo
  ) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    const insertProductoQuery = `
      INSERT INTO progra.producto(
        nombre, descripcion, precio,
        preferenciaserv_idpreferenciaserv,
        preferenciaserv_proveedor_idproveedor,
        preferenciaserv_proveedor_usuario_idusuario,
        catalogo_idcatalogo,
        catalogo_proveedor_idproveedor,
        catalogo_proveedor_usuario_idusuario,
        imagen
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    `;

    await client.query(insertProductoQuery, [
      nombre_producto,
      descripcion,
      precio,
      idpreferenciaserv,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      idcatalogo,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      imagen
    ]);

    await client.query('COMMIT');
    console.log('✅ Producto agregado correctamente');

    res.status(201).json({
      message: 'Producto agregado con éxito',
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error en creación de producto:', error);
    res.status(500).json({ error: error.message || 'Error al añadir producto' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.post('/registrarRedSocial', async (req, res) => {
  const { nombrered, enlace, descripcion, idproveedor, idusuario } = req.body;

  if (!nombrered || !enlace || !idproveedor || !idusuario) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }

  try {
    const result = await pool.query(`
      INSERT INTO progra.redsocial (
        nombrered,
        enlace,
        descripcion,
        proveedor_idproveedor,
        proveedor_usuario_idusuario
      ) VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `, [nombrered, enlace, descripcion, idproveedor, idusuario]);

    console.log('✅ Red social registrada:', result.rows[0]);
    res.status(201).json({ mensaje: 'Red social registrada correctamente', redSocial: result.rows[0] });
  } catch (error) {
    console.error('❌ Error al registrar red social:', error);
    res.status(500).json({ error: 'Error al registrar red social' });
  }
});

app.post('/registrarContrato', async (req, res) => {
  const {
    estado,
    detalles,
    organizador_idorganizador,
    organizador_usuario_idusuario,
    proveedor_idproveedor,
    proveedor_usuario_idusuario,
    producto_idproducto,
    producto_catalogo_idcatalogo,
    evento_idevento
  } = req.body;

  if (
    !estado || !detalles ||
    !organizador_idorganizador || !organizador_usuario_idusuario ||
    !proveedor_idproveedor || !proveedor_usuario_idusuario ||
    !producto_idproducto || !producto_catalogo_idcatalogo ||
    !evento_idevento
  ) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }

  try {
    const existeContrato = await pool.query(`
      SELECT 1 FROM progra.contrato
      WHERE
        organizador_idorganizador1 = $1 AND
        organizador_usuario_idusuario = $2 AND
        proveedor_idproveedor1 = $3 AND
        proveedor_usuario_idusuario = $4 AND
        producto_idproducto = $5 AND
        producto_catalogo_idcatalogo = $6 AND
        evento_idevento = $7
      LIMIT 1;
    `, [
      organizador_idorganizador,
      organizador_usuario_idusuario,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      producto_idproducto,
      producto_catalogo_idcatalogo,
      evento_idevento
    ]);

    if (existeContrato.rowCount > 0) {
      return res.status(409).json({ 
        error: 'Ya existe un contrato de este producto para el evento seleccionado'
      });
    }

    const result = await pool.query(`
      INSERT INTO progra.contrato (
        estado, fechacontrato, detalles,
        organizador_idorganizador1, organizador_usuario_idusuario,
        proveedor_idproveedor1, proveedor_usuario_idusuario,
        producto_idproducto, producto_catalogo_idcatalogo,
        producto_catalogo_proveedor_idproveedor, producto_catalogo_proveedor_usuario_idusuario,
        evento_idevento, evento_organizador_idorganizador, evento_organizador_usuario_idusuario
      ) VALUES ($1, CURRENT_TIMESTAMP, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
      RETURNING *;
    `, [
      estado,
      detalles,
      organizador_idorganizador,
      organizador_usuario_idusuario,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      producto_idproducto,
      producto_catalogo_idcatalogo,
      proveedor_idproveedor,
      proveedor_usuario_idusuario,
      evento_idevento,
      organizador_idorganizador,
      organizador_usuario_idusuario
    ]);

    console.log('✅ Contrato registrado:', result.rows[0]);
    res.status(201).json({ mensaje: 'Contrato registrado correctamente', contrato: result.rows[0] });

  } catch (error) {
    console.error('❌ Error al registrar contrato:', error);
    res.status(500).json({ error: 'Error al registrar contrato.' });
  }

});

app.post('/enviar-mensaje', async (req, res) => {
  const { remitente, destinatario, contenido } = req.body;

  
  console.log('🛠️ Datos recibidos:', req.body);
  console.log('remitente tipo:', typeof remitente);
  console.log('destinatario tipo:', typeof destinatario);

  if (remitente == null || destinatario == null || !contenido) {
    return res.status(400).json({ error: 'Faltan datos obligatorios.' });
  }


  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    const mensajeResult = await client.query(`
      INSERT INTO progra.mensaje(remitente, destinatario, contenido, fechahora)
      VALUES ($1, $2, $3, CURRENT_TIMESTAMP)
      RETURNING idmensaje
    `, [remitente, destinatario, contenido]);

    const mensaje = mensajeResult.rows[0];

    await client.query(`
      INSERT INTO progra.notificacion(usuario_idusuario, mensaje_idmensaje)
      VALUES ($1, $2)
    `,  [destinatario, mensaje.idmensaje]);

    await client.query('COMMIT');
    res.status(201).json({ mensaje: 'Mensaje y notificación registrados correctamente.' });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error en transacción:', error);
    res.status(500).json({ error: 'Error al registrar mensaje y notificación.' });
  } finally {
    client.release();
  }
});

app.post('/crearEvento', async (req, res) => {
  const {
    nombreevento,
    fechaevento,
    ubicacion,
    numeroasistentes,
    departamento_iddepartamento,
    descripcion,
    organizador_idorganizador,
    organizador_usuario_idusuario
  } = req.body;

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query(`
      INSERT INTO progra.evento (
        nombreevento, fechaevento, ubicacion, numeroasistentes,
        departamento_iddepartamento, descripcion,
        organizador_idorganizador, organizador_usuario_idusuario
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    `, [
      nombreevento,
      fechaevento,
      ubicacion,
      numeroasistentes,
      departamento_iddepartamento,
      descripcion,
      organizador_idorganizador,
      organizador_usuario_idusuario
    ]);
    await client.query('COMMIT');
    res.status(200).json({ mensaje: 'Evento creado exitosamente' });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error al crear el evento:', error);
    res.status(500).json({ error: 'Error al crear el evento' });
  } finally {
    client.release();
  }
});



app.put('/actualizarEstadoContrato', async (req, res) => {
  const {
    estado,
    organizador_idorganizador1,
    organizador_usuario_idusuario,
    proveedor_idproveedor1,
    proveedor_usuario_idusuario,
    producto_idproducto,
    producto_catalogo_idcatalogo,
    evento_idevento
  } = req.body;

  if (
    !estado ||
    !organizador_idorganizador1 ||
    !organizador_usuario_idusuario ||
    !proveedor_idproveedor1 ||
    !proveedor_usuario_idusuario ||
    !producto_idproducto ||
    !producto_catalogo_idcatalogo ||
    !evento_idevento
  ) {
    return res.status(400).json({ error: 'Faltan campos requeridos' });
  }

  try {
    const result = await pool.query(
      `
      UPDATE progra.contrato
      SET estado = $1, fechacontrato = NOW()
      WHERE 
        organizador_idorganizador1 = $2 AND
        organizador_usuario_idusuario = $3 AND
        proveedor_idproveedor1 = $4 AND
        proveedor_usuario_idusuario = $5 AND
        producto_idproducto = $6 AND
        producto_catalogo_idcatalogo = $7 AND
        evento_idevento = $8
      RETURNING *;
      `,
      [
        estado,
        organizador_idorganizador1,
        organizador_usuario_idusuario,
        proveedor_idproveedor1,
        proveedor_usuario_idusuario,
        producto_idproducto,
        producto_catalogo_idcatalogo,
        evento_idevento
      ]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ mensaje: 'No se encontró ningún contrato para actualizar.' });
    }

    res.status(200).json({ mensaje: 'Contrato actualizado correctamente', contrato: result.rows });
  } catch (error) {
    console.error('❌ Error al actualizar contrato:', error);
    res.status(500).json({ error: 'Error del servidor al actualizar el contrato' });
  }
});


app.put('/actualizarPerfilProv', async (req, res) => {
  const {
    idusuario,
    nomusuario,
    correoelectronico,
    perfil,
    nombrenegocio,
    propietario,
    telefono,
    ubicacion
  } = req.body;

  console.log('📤 Datos recibidos para actualización:');
  console.table(req.body);

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    await client.query(`
      UPDATE progra.usuario
      SET nomusuario = $1,
          correoelectronico = $2,
          perfil = $3
      WHERE idusuario = $4
    `, [
      nomusuario,
      correoelectronico,
      perfil,
      idusuario
    ]);

    await client.query(`
      UPDATE progra.proveedor
      SET nombrenegocio = $1,
          propietario = $2,
          telefono = $3,
          ubicacion = $4
      WHERE usuario_idusuario = $5
    `, [
      nombrenegocio,
      propietario,
      telefono,
      ubicacion,
      idusuario
    ]);

    await client.query('COMMIT');
    console.log(`✅ Perfil del usuario ${idusuario} actualizado correctamente`);
    res.status(200).json({ mensaje: 'Perfil actualizado con éxito' });

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error al actualizar el perfil del proveedor:', error);
    res.status(500).json({ error: 'Error al actualizar el perfil' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.put('/actualizarPerfilOrg', async (req, res) => {
  const {
    idusuario,
    nomusuario,
    correoelectronico,
    nombrecompleto,
    telefonoorg,
  } = req.body;

  console.log('📤 Datos recibidos para actualizar organizador:');
  console.table(req.body);

  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('🔄 Transacción iniciada');

    await client.query(`
      UPDATE progra.usuario
      SET nomusuario = $1,
          correoelectronico = $2
      WHERE idusuario = $3
    `, [
      nomusuario,
      correoelectronico,
      idusuario
    ]);

    // Actualiza tabla organizador
    await client.query(`
      UPDATE progra.organizador
      SET nombrecompleto = $1,
          telefonoorg = $2
      WHERE usuario_idusuario = $3
    `, [
      nombrecompleto,
      telefonoorg,
      idusuario
    ]);

    await client.query('COMMIT');
    console.log(`✅ Perfil del organizador (usuario ID ${idusuario}) actualizado correctamente`);
    res.status(200).json({ mensaje: 'Perfil del organizador actualizado con éxito' });

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Error al actualizar el perfil del organizador:', error);
    res.status(500).json({ error: 'Error al actualizar el perfil del organizador' });
  } finally {
    client.release();
    console.log('🔚 Conexión liberada');
  }
});

app.put('/actualizarDisponibilidad', async (req, res) => {
  const {
    idproducto,
    disponible
  } = req.body;

  try {
    const result = await pool.query(`
      UPDATE progra.producto
      SET disponible = $1
      WHERE idproducto = $2
    `, [
      disponible,
      idproducto
    ]);

    res.status(200).json({ mensaje: '✅ Disponibilidad actualizada correctamente' });
  } catch (error) {
    console.error('❌ Error al actualizar disponibilidad:', error);
    res.status(500).json({ error: 'Error al actualizar disponibilidad' });
  }
});

app.delete('/eliminarProducto/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query(`
      DELETE FROM progra.producto
      WHERE idproducto = $1
    `, [id]);

    res.status(200).json({ mensaje: '🗑️ Producto eliminado correctamente' });
  } catch (error) {
    console.error('❌ Error al eliminar producto:', error);
    res.status(500).json({ error: 'Error al eliminar producto' });
  }
});

app.delete('/eliminarEvento/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const resultado = await pool.query(`
      DELETE FROM progra.evento
      WHERE idevento = $1
    `, [id]);

    if (resultado.rowCount === 0) {
      return res.status(404).json({ error: 'Evento no encontrado' });
    }

    console.log(`🗑️ Evento con ID ${id} eliminado`);
    res.status(200).json({ mensaje: 'Evento eliminado correctamente' });
  } catch (error) {
    console.error('❌ Error al eliminar el evento:', error);
    res.status(500).json({ error: 'Error al eliminar el evento' });
  }
});

