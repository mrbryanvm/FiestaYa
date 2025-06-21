import 'package:flutter/material.dart';
import 'package:konekta_app/modelos/contrato.dart';
import '../decoracion/colores_app.dart';

class SolicitudCard extends StatelessWidget {
  final List<PopupMenuEntry<String>>? opcionesMenu;
  final ContratoModel contrato;

  const SolicitudCard({super.key, this.opcionesMenu, required this.contrato});

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'aceptado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColoresApp.naranja,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text(
                    'Detalles de solicitud',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (opcionesMenu != null && contrato.estado == 'pendiente')
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => opcionesMenu!,
                  ),
              ],
            ),
            Text(contrato.detalles),
            Row(
              children: [
                const Text('Estado:'),
                const SizedBox(width: 8),
                Chip(
                  label: Text(contrato.estado),
                  backgroundColor: _colorEstado(
                    contrato.estado,
                  ).withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: _colorEstado(contrato.estado),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
