import 'package:flutter/material.dart';
import 'package:konekta_app/modelos/producto.dart';
import '../decoracion/colores_app.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final Map<String, String>? opcionesMenu;
  final void Function(String)? onOpcionSeleccionada;

  const ProductoCard({
    super.key,
    required this.producto,
    this.opcionesMenu,
    this.onOpcionSeleccionada,
  });

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Disponible':
        return Colors.green;
      case 'Agotado':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: ColoresApp.naranja,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Icon(Icons.image_not_supported, size: 55),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (opcionesMenu != null && opcionesMenu!.isNotEmpty)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: onOpcionSeleccionada,
                          itemBuilder: (context) {
                            return opcionesMenu!.entries.map((entry) {
                              return PopupMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList();
                          },
                        ),
                    ],
                  ),
                  Text(producto.descripcion),
                  const SizedBox(height: 3),
                  Text('Categoría: ${producto.categoria}'),
                  Text('Precio: Bs. ${producto.precio}'),
                  Chip(
                    label: Text(producto.disponible ? 'Disponible' : 'Agotado'),
                    backgroundColor: _colorEstado(
                      producto.disponible ? 'Disponible' : 'Agotado',
                    ).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _colorEstado(
                        producto.disponible ? 'Disponible' : 'Agotado',
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
