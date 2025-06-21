class PerfilProveedor {
  final int idUsuario;
  final String nomUsuario;
  final String? contrasena;
  final String correoElectronico;
  final String? perfil;
  final String? departamento;
  final String nombreNegocio;
  final String propietario;
  final int telefono;
  final String ubicacion;

  PerfilProveedor({
    required this.idUsuario,
    required this.nomUsuario,
    this.contrasena,
    required this.correoElectronico,
    this.perfil,
    this.departamento,
    required this.nombreNegocio,
    required this.propietario,
    required this.telefono,
    required this.ubicacion,
  });

  factory PerfilProveedor.fromJson(Map<String, dynamic> json) {
    return PerfilProveedor(
      idUsuario: json['idusuario'],
      nomUsuario: json['nomusuario'],
      contrasena: json['contrasena'],
      correoElectronico: json['correoelectronico'],
      perfil: json['perfil'],
      departamento: json['departamento'],
      nombreNegocio: json['nombrenegocio'],
      propietario: json['propietario'],
      telefono: json['telefono'],
      ubicacion: json['ubicacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idUsuario,
      'nomusuario': nomUsuario,
      'correoelectronico': correoElectronico,
      'perfil': perfil,
      'nombrenegocio': nombreNegocio,
      'propietario': propietario,
      'telefono': telefono,
      'ubicacion': ubicacion,
    };
  }
}
