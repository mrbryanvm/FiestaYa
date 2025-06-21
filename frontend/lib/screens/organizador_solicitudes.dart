import 'package:flutter/material.dart';
import '../modelos/contrato.dart';
import '../componentes/solicitud_card.dart';
import '../decoracion/colores_app.dart';
import '../services/api_service.dart';

class OrganizadorSolicitudes extends StatefulWidget {
  final int idusuario;
  final int idOrganizador;
  const OrganizadorSolicitudes({
    super.key,
    required this.idOrganizador,
    required this.idusuario,
  });

  @override
  State<OrganizadorSolicitudes> createState() => _OrganizadorSolicitudesState();
}

class _OrganizadorSolicitudesState extends State<OrganizadorSolicitudes> {
  late Future<List<ContratoModel>> _futuroContratos;

  @override
  void initState() {
    super.initState();
    _futuroContratos = ApiService.obtenerContratosPorUsuario(widget.idusuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Productos'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: FutureBuilder<List<ContratoModel>>(
        future: _futuroContratos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay solicitudes disponibles.'));
          } else {
            final contratos = snapshot.data!;
            return ListView.builder(
              itemCount: contratos.length,
              itemBuilder: (context, index) {
                final contrato = contratos[index];
                return SolicitudCard(contrato: contrato);
              },
            );
          }
        },
      ),
    );
  }
}
