import 'package:flutter/material.dart';

import '../decoracion/colores_app.dart';

class ProductoFormulario extends StatefulWidget {
  final Function(
    String nombre,
    String descripcion,
    double precio,
    String categoria,
    String? imagenPath,
  )
  onGuardar;

  const ProductoFormulario({super.key, required this.onGuardar});

  @override
  State<ProductoFormulario> createState() => _ProductoFormularioState();
}

class _ProductoFormularioState extends State<ProductoFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  String? _categoriaSeleccionada;
  String? _imagenSeleccionada;

  final List<String> categorias = [
    'Amplificación',
    'Catering',
    'Seguridad',
    'Fotografía',
    'Cotillón',
    'Decoración',
    'Mobiliario',
    'Transporte',
    'Local',
    'Limpieza',
    'Animación',
    'Otros',
  ];

  void _guardarProducto() {
    if (_formKey.currentState!.validate()) {
      widget.onGuardar(
        _nombreController.text,
        _descripcionController.text,
        double.tryParse(_precioController.text) ?? 0,
        _categoriaSeleccionada ?? '',
        _imagenSeleccionada,
      );
      Navigator.pop(context);
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColoresApp.naranja,
      title: const Text(
        'Agregar Producto',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                hint: const Text('Categoría del producto'),
                items:
                    categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: ColoresApp.celeste,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    // Aquí luego puedes abrir el picker de imágenes
                    setState(() {
                      _imagenSeleccionada = 'ruta/ficticia/imagen.png';
                    });
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Seleccionar imagen'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 120,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ColoresApp.celeste,
              foregroundColor: Colors.black,
            ),
            onPressed: _cancelar,
            child: const Text('Cancelar'),
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoresApp.celeste,
              foregroundColor: Colors.black,
            ),
            onPressed: _guardarProducto,
            child: const Text('Guardar'),
          ),
        ),
      ],
    );
  }
}
