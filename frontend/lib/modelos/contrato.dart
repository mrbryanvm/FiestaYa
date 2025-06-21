class ContratoModel {
  final String estado;
  final DateTime? fechacontrato;
  final String detalles;
  final int organizadorId;
  final int organizadorUsuarioId;
  final int proveedorId;
  final int proveedorUsuarioId;
  final int productoId;
  final int idCatalogo;
  final int eventoId;

  ContratoModel({
    required this.estado,
    this.fechacontrato,
    required this.detalles,
    required this.organizadorId,
    required this.organizadorUsuarioId,
    required this.proveedorId,
    required this.proveedorUsuarioId,
    required this.productoId,
    required this.idCatalogo,
    required this.eventoId,
  });

  factory ContratoModel.fromJson(Map<String, dynamic> json) {
    return ContratoModel(
      estado: json['estado'],
      fechacontrato: DateTime.parse(json['fechacontrato']),
      detalles: json['detalles'],
      organizadorId: json['organizador_idorganizador1'],
      organizadorUsuarioId: json['organizador_usuario_idusuario'],
      proveedorId: json['proveedor_idproveedor1'],
      proveedorUsuarioId: json['proveedor_usuario_idusuario'],
      productoId: json['producto_idproducto'],
      idCatalogo: json['producto_catalogo_idcatalogo'],
      eventoId: json['evento_idevento'],
    );
  }
}
