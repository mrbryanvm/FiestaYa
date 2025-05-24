import 'package:flutter/material.dart';

import '../componentes/card_producto.dart';
import '../componentes/producto_formulario.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';

class RegistroCatalogo extends StatefulWidget {
  const RegistroCatalogo({super.key});

  @override
  State<RegistroCatalogo> createState() => _RegistroCatalogoState();
}

class _RegistroCatalogoState extends State<RegistroCatalogo> {
  final List<Map<String, dynamic>> productos = [];

  void _agregarProducto() {
    showDialog(
      context: context,
      builder:
          (context) => ProductoFormulario(
            onGuardar: (nombre, descripcion, precio, categoria, imagen) {
              setState(() {
                productos.add({
                  'nombre': nombre,
                  'descripcion': descripcion,
                  'precio': precio,
                  'categoria': categoria,
                  'imagen': imagen,
                });
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: _agregarProducto,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar producto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.naranja,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (productos.isEmpty)
                      const Center(
                        child: Text(
                          'Ingresar al menos un producto para terminar registro',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final producto = productos[index];
                            return ProductoCard(
                              nombre: producto['nombre'],
                              descripcion: producto['descripcion'],
                              precio: producto['precio'],
                              categoria: producto['categoria'],
                              imagenPath: producto['imagenPath'],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                Icons.brightness_6,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                ThemeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
