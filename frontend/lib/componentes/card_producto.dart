import 'package:flutter/material.dart';
import '../decoracion/colores_app.dart';

class ProductoCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String? imagenPath;

  const ProductoCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    this.imagenPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: ColoresApp.naranja,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            imagenPath != null
                ? Image.asset(
                  imagenPath!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                : const Icon(Icons.image_not_supported, size: 60),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(descripcion),
                  const SizedBox(height: 4),
                  Text('Categoría: $categoria'),
                  Text('Precio: Bs. ${precio.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
