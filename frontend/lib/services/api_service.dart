import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/categoria.dart';
import '../modelos/contrato.dart';
import '../modelos/departamento.dart';
import '../modelos/evento.dart';
import '../modelos/mesajes.dart';
import '../modelos/perfil_organizador.dart';
import '../modelos/perfil_proveedor.dart';
import '../modelos/producto.dart';

class ApiService {
  static Future<List<Departamento>> obtenerDepartamentos() async {
    final url = Uri.parse('http://192.168.116.213:3000/departamentos');
    final response = await http.get(url);

    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Departamento.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener departamentos');
    }
  }

  static Future<List<Categoria>> obtenerCategoriasPorProveedor(
    int idProveedor,
  ) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/categorias?idProveedor=$idProveedor',
    );

    final response = await http.get(url);

    print('Obteniendo categorías para proveedor $idProveedor');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Categoria.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener categorías');
    }
  }

  static Future<List<Producto>> obtenerProductos(int idProveedor) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/productosPropios?idProveedor=$idProveedor',
    );

    final response = await http.get(url);
    print('🔻 Respuesta bruta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  static Future<List<Producto>> obtenerProd() async {
    final url = Uri.parse('http://192.168.116.213:3000/productos');

    final response = await http.get(url);
    print('🔻 Respuesta bruta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  static Future<PerfilProveedor> obtenerPerfilProveedor(int idUsuario) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/perfilProv?idUsuario=$idUsuario',
    );

    final response = await http.get(url);

    print('Obteniendo perfil de proveedor $idUsuario');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return PerfilProveedor.fromJson(data[0]);
      } else {
        throw Exception('Perfil no encontrado');
      }
    } else {
      throw Exception('Error al obtener el perfil del proveedor');
    }
  }

  static Future<PerfilOrganizador> obtenerPerfilOrganizador(
    int idUsuario,
  ) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/perfilOrg?idUsuario=$idUsuario',
    );

    final response = await http.get(url);

    print('Obteniendo perfil del organizador $idUsuario');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return PerfilOrganizador.fromJson(data[0]);
      } else {
        throw Exception('Perfil no encontrado');
      }
    } else {
      throw Exception('Error al obtener el perfil del organizador');
    }
  }

  static Future<Map<String, dynamic>> autenticarUsuario({
    String? nomusuario,
    String? correoelectronico,
    String? contrasena,
  }) async {
    final queryParams = {
      if (nomusuario != null) 'nomusuario': nomusuario,
      if (correoelectronico != null) 'correoelectronico': correoelectronico,
      if (contrasena != null) 'contrasena': contrasena,
    };

    final uri = Uri.http('192.168.116.213:3000', '/autenticacion', queryParams);

    final response = await http.get(uri);

    print('🛂 Autenticando usuario...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al autenticar usuario');
    }
  }

  static Future<Map<String, dynamic>> registrarOrganizador(
    Map<String, dynamic> datos,
  ) async {
    final url = Uri.parse('http://192.168.116.213:3000/registrar-organizador');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('📤 Enviando datos del organizador: $datos');
    print('📡 Estado: ${response.statusCode}');
    print('📨 Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'idusuario': data['idusuario'],
        'idorganizador': data['idorganizador'],
      };
    } else {
      throw Exception('Error al registrar organizador');
    }
  }

  static Future<Map<String, dynamic>> registrarProveedor(
    Map<String, dynamic> datos,
  ) async {
    final url = Uri.parse('http://192.168.116.213:3000/registrar-proveedor');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('Enviando datos: $datos');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'idusuario': data['idusuario'],
        'idproveedor': data['idproveedor'],
      };
    } else {
      throw Exception('Error al registrar proveedor');
    }
  }

  static Future<Map<String, dynamic>> registrarContrato(
    Map<String, dynamic> datos,
  ) async {
    final url = Uri.parse('http://192.168.116.213:3000/registrarContrato');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('Enviando datos del contrato: $datos');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al registrar contrato');
    }
  }

  static Future<bool> registrarPreferencias({
    required List<String> categorias,
    required int idProveedor,
    required int idUsuario,
  }) async {
    final url = Uri.parse('http://192.168.116.213:3000/registrar-preferencias');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'categorias': categorias,
        'idproveedor': idProveedor,
        'idusuario': idUsuario,
      }),
    );

    print('Enviando preferencias: $categorias');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al registrar preferencias');
    } else {
      return true;
    }
  }

  static Future<bool> registrarRedSocial({
    required String nombreRed,
    required String enlace,
    String? descripcion,
    required int idproveedor,
    required int idusuario,
  }) async {
    final url = Uri.parse('http://192.168.116.213:3000/registrarRedSocial');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombrered': nombreRed,
        'enlace': enlace,
        'descripcion': descripcion ?? '',
        'idproveedor': idproveedor,
        'idusuario': idusuario,
      }),
    );

    print('Enviando red social: $nombreRed - $enlace');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al registrar red social');
    } else {
      return true;
    }
  }

  static Future<int> crearCatalogoYProducto(Map<String, dynamic> datos) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/crear-catalogo-producto',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('Enviando datos: $datos');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['idcatalogo'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['error'] ?? 'Error desconocido al crear catálogo y producto',
      );
    }
  }

  static Future<void> agregarProducto(Map<String, dynamic> datos) async {
    final url = Uri.parse('http://192.168.116.213:3000:3000/agregar-producto');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('Enviando datos: $datos');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      print('✅ Producto agregado con éxito');
      return;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al agregar producto');
    }
  }

  static Future<void> actualizarPerfilProveedor(PerfilProveedor perfil) async {
    final url = Uri.parse('http://192.168.116.213:3000/actualizarPerfilProv');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(perfil.toJson()),
    );

    print('Actualizando perfil...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el perfil');
    }
  }

  static Future<void> actualizarPerfilOrganizador(
    PerfilOrganizador perfil,
  ) async {
    final url = Uri.parse('http://192.168.116.213:3000/actualizarPerfilOrg');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(perfil.toJson()),
    );

    print('Actualizando perfil del organizador...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el perfil del organizador');
    }
  }

  static Future<void> actualizarDisponibilidad(
    int idProducto,
    bool estado,
  ) async {
    final queryParams = {'idProducto': idProducto, 'disponible': estado};

    final url = Uri.parse(
      'http://192.168.116.213:3000/actualizarDisponibilidad',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(queryParams),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el producto');
    }
  }

  static Future<void> eliminarProducto(int idProducto) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/eliminarProducto/$idProducto',
    );

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto');
    }
  }

  static Future<void> eliminarEvento(int idEvento) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/eliminarEvento/$idEvento',
    );

    final response = await http.delete(url);

    print('🗑️ Eliminando evento ID: $idEvento');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento');
    }
  }

  static Future<void> crearEvento(Map<String, dynamic> datosEvento) async {
    final url = Uri.parse('http://192.168.116.213:3000/crearEvento');

    final respuesta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datosEvento),
    );
    if (respuesta.statusCode != 200) {
      throw Exception('Error al crear el evento: ${respuesta.body}');
    }
  }

  static Future<List<Evento>> obtenerEventos(int idUsuario) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/eventos?idUsuario=$idUsuario',
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = json.decode(respuesta.body);
      return datos.map((e) => Evento.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener eventos: ${respuesta.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerRedesSociales(
    int idUsuario,
  ) async {
    final uri = Uri.http('192.168.116.213:3000', '/redesSociales', {
      'idusuario': idUsuario.toString(),
    });

    final response = await http.get(uri);

    print('🔍 Obteniendo redes sociales...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al obtener redes sociales');
    }
  }

  static Future<List<ContratoModel>> obtenerContratosPorUsuario(
    int idUsuario,
  ) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/contratos?idUsuario=$idUsuario',
    );

    final response = await http.get(url);

    print('📦 Consultando contratos para el usuario $idUsuario');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(response.body);
      return datos.map((e) => ContratoModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener contratos del usuario');
    }
  }

  static Future<bool> enviarMensaje({
    required int remitente,
    required int destinatario,
    required String contenido,
  }) async {
    final url = Uri.parse('http://192.168.116.213:3000/enviar-mensaje');

    final datos = {
      'remitente': remitente,
      'destinatario': destinatario,
      'contenido': contenido,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    print('📩 Enviando mensaje: $datos');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al enviar mensaje');
    }
  }

  static Future<List<Mensaje>> obtenerMensajes(int idUsuario) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/mensajes?idUsuario=$idUsuario',
    );

    final response = await http.get(url);

    print('📨 Cargando mensajes...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Mensaje.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los mensajes');
    }
  }

  static Future<void> actualizarEstadoContrato({
    required String estado,
    required int organizadorId,
    required int organizadorUsuarioId,
    required int proveedorId,
    required int proveedorUsuarioId,
    required int productoId,
    required int catalogoId,
    required int eventoId,
  }) async {
    final url = Uri.parse(
      'http://192.168.116.213:3000/actualizarEstadoContrato',
    );

    final body = jsonEncode({
      'estado': estado,
      'organizador_idorganizador1': organizadorId,
      'organizador_usuario_idusuario': organizadorUsuarioId,
      'proveedor_idproveedor1': proveedorId,
      'proveedor_usuario_idusuario': proveedorUsuarioId,
      'producto_idproducto': productoId,
      'producto_catalogo_idcatalogo': catalogoId,
      'evento_idevento': eventoId,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('📤 Actualizando estado del contrato...');
    print('Estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el estado del contrato');
    }
  }
}
