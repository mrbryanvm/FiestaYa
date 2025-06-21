import 'package:flutter/material.dart';
import '../modelos/contrato.dart';
import '../componentes/solicitud_card.dart';
import '../decoracion/colores_app.dart';
import '../services/api_service.dart';

class ProveedorSolicitudes extends StatefulWidget {
  final int idusuario;
  final int idProveedor;
  const ProveedorSolicitudes({
    super.key,
    required this.idProveedor,
    required this.idusuario,
  });

  @override
  State<ProveedorSolicitudes> createState() => _ProveedorSolicitudesState();
}

class _ProveedorSolicitudesState extends State<ProveedorSolicitudes> {
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
                return SolicitudCard(
                  contrato: contrato,
                  opcionesMenu: [
                    PopupMenuItem(
                      value: 'aceptar',
                      child: const Text('Aceptar'),
                      onTap: () async {
                        await ApiService.actualizarEstadoContrato(
                          estado: 'aceptado',
                          organizadorId: contrato.organizadorId,
                          organizadorUsuarioId: contrato.organizadorUsuarioId,
                          proveedorId: widget.idProveedor,
                          proveedorUsuarioId: widget.idusuario,
                          productoId: contrato.productoId,
                          catalogoId: contrato.idCatalogo,
                          eventoId: contrato.eventoId,
                        );
                        final String contenido =
                            'SOLICITUD ACEPTADA, la solicitud al servicio fue aceptada, por método de pago contra entrega';

                        await ApiService.enviarMensaje(
                          remitente: widget.idusuario,
                          destinatario: contrato.organizadorUsuarioId,
                          contenido: contenido,
                        );
                        setState(() {
                          _futuroContratos =
                              ApiService.obtenerContratosPorUsuario(
                                widget.idusuario,
                              );
                        });
                      },
                    ),
                    PopupMenuItem(
                      value: 'rechazar',
                      child: const Text('Rechazar'),
                      onTap: () async {
                        await ApiService.actualizarEstadoContrato(
                          estado: 'rechazado',
                          organizadorId: contrato.organizadorId,
                          organizadorUsuarioId: contrato.organizadorUsuarioId,
                          proveedorId: widget.idProveedor,
                          proveedorUsuarioId: widget.idusuario,
                          productoId: contrato.productoId,
                          catalogoId: contrato.idCatalogo,
                          eventoId: contrato.eventoId,
                        );
                        final String contenido =
                            'SOLICITUD RECHAZADA, la solicitud al servicio fue rechazada.';

                        await ApiService.enviarMensaje(
                          remitente: widget.idusuario,
                          destinatario: contrato.organizadorUsuarioId,
                          contenido: contenido,
                        );
                        setState(() {
                          _futuroContratos =
                              ApiService.obtenerContratosPorUsuario(
                                widget.idusuario,
                              );
                        });
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
