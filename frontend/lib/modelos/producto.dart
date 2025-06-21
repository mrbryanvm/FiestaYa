class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int preferenciaservId;
  final String categoria;
  final bool disponible;
  final int catalogoId;
  final int idusuario;
  final int idproveedor;
  final String? imagen;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.preferenciaservId,
    required this.categoria,
    required this.disponible,
    required this.catalogoId,
    required this.idusuario,
    required this.idproveedor,
    this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['idproducto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      preferenciaservId: json['preferenciaserv_idpreferenciaserv'],
      categoria: json['categoria'],
      disponible: json['disponible'],
      catalogoId: json['catalogo_idcatalogo'],
      idusuario: json['catalogo_proveedor_usuario_idusuario'],
      idproveedor: json['preferenciaserv_proveedor_idproveedor'],
      imagen: json['imagen'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idproducto': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'preferenciaserv_idpreferenciaserv': preferenciaservId,
    'catalogoId': catalogoId,
    'idusuario': idusuario,
    'idproveedor': idproveedor,
    'imagen': imagen,
    'disponible': disponible,
  };
}
