class Categoria {
  final int idpreferenciaserv;
  final String categoria;

  Categoria({required this.idpreferenciaserv, required this.categoria});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idpreferenciaserv: json['idpreferenciaserv'],
      categoria: json['categoria'],
    );
  }
}
