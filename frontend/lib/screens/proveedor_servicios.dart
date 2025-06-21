import 'package:flutter/material.dart';
import '../componentes/card_producto.dart';
import '../componentes/mostrar_aviso.dart';
import '../componentes/producto_formulario.dart';
import '../decoracion/colores_app.dart';
import '../modelos/producto.dart';
import '../services/api_service.dart';

class ProveedorServicios extends StatefulWidget {
  final int idProveedor;
  final int idUsuario;
  final String empresa;
  const ProveedorServicios({
    super.key,
    required this.idProveedor,
    required this.idUsuario,
    required this.empresa,
  });

  @override
  State<ProveedorServicios> createState() => _ProveedorServiciosState();
}

class _ProveedorServiciosState extends State<ProveedorServicios> {
  final List<Producto> productos = [];
  bool _cargando = true;
  int? idCatalogo;

  @override
  void initState() {
    super.initState();
    _cargarProductosDesdeBD();
  }

  Future<void> _cargarProductosDesdeBD() async {
    setState(() {
      _cargando = true;
    });
    try {
      final lista = await ApiService.obtenerProductos(widget.idProveedor);
      print('✅ Productos recibidos: ${lista.length}');
      for (var p in lista) {
        print('${p.nombre} - ${p.descripcion}');
      }
      setState(() {
        productos
          ..clear()
          ..addAll(lista);
        if (lista.isNotEmpty) {
          idCatalogo = lista.first.catalogoId;
        }
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      debugPrint('Error cargando productos: $e');
    }
  }

  void _agregarProducto() async {
    print('ID Catálogo actual: $idCatalogo');

    final seAgregoProducto = await showDialog<bool>(
      context: context,
      builder:
          (context) => ProductoFormulario(
            idUsuario: widget.idUsuario,
            idProveedor: widget.idProveedor,
            empresa: widget.empresa,
            idCatalogo: idCatalogo,
          ),
    );

    if (seAgregoProducto == true) {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Guardado',
        contenido: 'Producto agregado correctamente. Cargando productos...',
        onAceptar: () {},
      );
      _cargarProductosDesdeBD();
    } else {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Aviso',
        contenido: 'No se añadió ningún producto.',
        onAceptar: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Servicios'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 180,
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
                    if (_cargando)
                      const Center(child: CircularProgressIndicator())
                    else if (productos.isEmpty)
                      const Center(
                        child: Text(
                          'No tienes productos registrados',
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
                              producto: producto,
                              opcionesMenu: {
                                'eliminar': 'Eliminar',
                                'cambiar_estado':
                                    producto.disponible
                                        ? 'Agotado'
                                        : 'Disponible',
                              },
                              onOpcionSeleccionada: (value) async {
                                if (value == 'eliminar') {
                                  await ApiService.eliminarProducto(
                                    producto.id,
                                  );
                                  _cargarProductosDesdeBD();
                                } else if (value == 'cambiar_estado') {
                                  final nuevoEstado = !producto.disponible;
                                  await ApiService.actualizarDisponibilidad(
                                    producto.id,
                                    nuevoEstado,
                                  );
                                  _cargarProductosDesdeBD();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
