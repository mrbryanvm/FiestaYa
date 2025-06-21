import 'package:flutter/material.dart';
import '../decoracion/colores_app.dart';
import '../modelos/mesajes.dart';
import '../services/api_service.dart';

class Notificaciones extends StatelessWidget {
  final int idusuario;

  const Notificaciones({super.key, required this.idusuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: FutureBuilder<List<Mensaje>>(
        future: ApiService.obtenerMensajes(idusuario),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay mensajes disponibles.'));
          }

          final mensajes = snapshot.data!;
          return ListView.builder(
            itemCount: mensajes.length,
            itemBuilder: (context, index) {
              final msg = mensajes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Card(
                  color: ColoresApp.naranja,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: Icon(
                      Icons.notifications,
                      size: 24,
                      color: ColoresApp.celeste,
                    ),
                    title: Text(
                      msg.contenido,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Fecha: ${msg.fechahora.toLocal()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
