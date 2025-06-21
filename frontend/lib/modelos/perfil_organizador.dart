class PerfilOrganizador {
  final int idUsuario;
  final String nomUsuario;
  final String? contrasena;
  final String correoElectronico;
  final String? perfil;
  final String? departamento;
  final String nombreCompleto;
  final String telefonoOrg;

  PerfilOrganizador({
    required this.idUsuario,
    required this.nomUsuario,
    this.contrasena,
    required this.correoElectronico,
    this.perfil,
    this.departamento,
    required this.nombreCompleto,
    required this.telefonoOrg,
  });

  factory PerfilOrganizador.fromJson(Map<String, dynamic> json) {
    return PerfilOrganizador(
      idUsuario: json['idusuario'],
      nomUsuario: json['nomusuario'],
      contrasena: json['contrasena'],
      correoElectronico: json['correoelectronico'],
      perfil: json['perfil'],
      departamento: json['departamento'],
      nombreCompleto: json['nombrecompleto'],
      telefonoOrg: json['telefonoorg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idUsuario,
      'nomusuario': nomUsuario,
      'correoelectronico': correoElectronico,
      'nombrecompleto': nombreCompleto,
      'telefonoorg': telefonoOrg,
    };
  }
}
