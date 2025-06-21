import 'package:flutter/material.dart';
import 'package:konekta_app/decoracion/colores_app.dart';
import '../modelos/evento.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;

  const EventoCard({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColoresApp.naranja,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.nombre,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text(evento.fecha.toLocal().toString().split(' ')[0]),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 5),
                Expanded(child: Text(evento.ubicacion)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 5),
                Text('Asistentes: ${evento.numeroAsistentes}'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.map, size: 16),
                const SizedBox(width: 5),
                Text('Departamento: ${evento.nombreDepartamento}'),
              ],
            ),
            const SizedBox(height: 10),
            Text(evento.descripcion, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
