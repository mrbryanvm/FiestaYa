class Evento {
  final int id;
  final String nombre;
  final DateTime fecha;
  final String ubicacion;
  final int numeroAsistentes;
  final int idDepartamento;
  final String nombreDepartamento;
  final String descripcion;
  final int idOrganizador;
  final int idUsuarioOrganizador;

  Evento({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.ubicacion,
    required this.numeroAsistentes,
    required this.idDepartamento,
    required this.nombreDepartamento,
    required this.descripcion,
    required this.idOrganizador,
    required this.idUsuarioOrganizador,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['idevento'],
      nombre: json['nombreevento'],
      fecha: DateTime.parse(json['fechaevento']),
      ubicacion: json['ubicacion'],
      numeroAsistentes: json['numeroasistentes'],
      idDepartamento: json['departamento_iddepartamento'],
      nombreDepartamento: json['nombredep'],
      descripcion: json['descripcion'],
      idOrganizador: json['organizador_idorganizador'],
      idUsuarioOrganizador: json['organizador_usuario_idusuario'],
    );
  }
}
