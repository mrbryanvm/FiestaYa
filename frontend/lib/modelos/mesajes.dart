class Mensaje {
  final int idmensaje;
  final int remitente;
  final String contenido;
  final DateTime fechahora;

  Mensaje({
    required this.idmensaje,
    required this.remitente,
    required this.contenido,
    required this.fechahora,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idmensaje: json['idmensaje'],
      remitente: json['remitente'],
      contenido: json['contenido'],
      fechahora: DateTime.parse(json['fechahora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idmensaje': idmensaje,
      'remitente': remitente,
      'contenido': contenido,
    };
  }
}
