// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../decoracion/colores_app.dart';
import '../modelos/categoria.dart';
import '../services/api_service.dart';
import 'mostrar_aviso.dart';

class ProductoFormulario extends StatefulWidget {
  final int idUsuario;
  final int idProveedor;
  final String empresa;
  final int? idCatalogo;

  const ProductoFormulario({
    super.key,
    required this.idUsuario,
    required this.idProveedor,
    required this.empresa,
    this.idCatalogo,
  });

  @override
  State<ProductoFormulario> createState() => _ProductoFormularioState();
}

class _ProductoFormularioState extends State<ProductoFormulario> {
  int? _idCatalogoActual;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  String? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();
  List<Categoria> _categoriasDisponibles = [];
  Categoria? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _idCatalogoActual = widget.idCatalogo;
    _cargarCategorias();
  }

  void _cargarCategorias() async {
    try {
      final categorias = await ApiService.obtenerCategoriasPorProveedor(
        widget.idProveedor,
      );
      print(
        '📦 categorías cargadas: ${categorias.map((e) => e.categoria).toList()}',
      );
      setState(() {
        _categoriasDisponibles = categorias;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
    }
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      bool _seAgregoProducto = false;
      print('🧪 ID Catálogo actual: $_idCatalogoActual');

      try {
        if (widget.idCatalogo == null) {
          await ApiService.crearCatalogoYProducto({
            'empresa': widget.empresa,
            'proveedor_idproveedor': widget.idProveedor,
            'proveedor_usuario_idusuario': widget.idUsuario,
            'nombre_producto': _nombreController.text.trim(),
            'descripcion': _descripcionController.text.trim(),
            'precio': double.parse(_precioController.text.trim()),
            'idpreferenciaserv': _categoriaSeleccionada!.idpreferenciaserv,
            'imagen': _imagenSeleccionada,
          });
          _seAgregoProducto = true;
        } else {
          await ApiService.agregarProducto({
            'idcatalogo': _idCatalogoActual,
            'nombre': _nombreController.text.trim(),
            'descripcion': _descripcionController.text.trim(),
            'precio': double.parse(_precioController.text.trim()),
            'idpreferenciaserv': _categoriaSeleccionada!.idpreferenciaserv,
            'idproveedor': widget.idProveedor,
            'idusuario': widget.idUsuario,
            'imagen': _imagenSeleccionada,
          });

          _seAgregoProducto = true;
        }

        if (!mounted) return;
        Navigator.pop(context, _seAgregoProducto);
      } catch (e) {
        print('❌ Error al guardar producto: $e');
        mostrarAviso(
          context: context,
          titulo: 'Error',
          contenido: 'Error al guardar el producto.',
          onAceptar: () {},
        );
      }
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
              _categoriasDisponibles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Categoria>(
                    value: _categoriaSeleccionada,
                    hint: const Text('Categoría del producto'),
                    items:
                        _categoriasDisponibles.map((categoria) {
                          return DropdownMenuItem<Categoria>(
                            value: categoria,
                            child: Text(categoria.categoria),
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
                  onPressed: () async {
                    final XFile? imagen = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (imagen != null) {
                      setState(() {
                        _imagenSeleccionada = imagen.path;
                      });
                      if (!context.mounted) return;
                      mostrarAviso(
                        context: context,
                        titulo: 'Imagen seleccionada',
                        contenido: '✅ Se seleccionó la imagen correctamente.',
                        onAceptar: () {},
                      );
                    } else {
                      if (!context.mounted) return;
                      mostrarAviso(
                        context: context,
                        titulo: 'Sin selección',
                        contenido: 'ℹ️ No se seleccionó ninguna imagen.',
                        onAceptar: () {},
                      );
                    }
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
