// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../componentes/card_producto.dart';
import '../componentes/solicitud_servicio.dart';
import '../decoracion/colores_app.dart';
import '../modelos/producto.dart';
import '../services/api_service.dart';
import 'perfilprov.dart';

class ServiciosOfertados extends StatefulWidget {
  final int idUsuario;
  final int idOrganizador;

  const ServiciosOfertados({
    super.key,
    required this.idUsuario,
    required this.idOrganizador,
  });

  @override
  State<ServiciosOfertados> createState() => _ServiciosOfertadosState();
}

class _ServiciosOfertadosState extends State<ServiciosOfertados> {
  final List<Producto> productos = [];
  bool _cargando = true;

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
      final lista = await ApiService.obtenerProd();
      print('✅ Productos recibidos: ${lista.length}');
      for (var p in lista) {
        print('${p.nombre} - ${p.descripcion}');
      }
      setState(() {
        productos
          ..clear()
          ..addAll(lista);
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      debugPrint('Error cargando productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios Ofertados'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Filtra los productos',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (_cargando)
                  const Center(child: CircularProgressIndicator())
                else if (productos.isEmpty)
                  const Center(
                    child: Text(
                      'No hay productos registrados',
                      style: TextStyle(fontSize: 15),
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
                            'ver_proveedor': 'Ver proveedor',
                            'solicitar_servicio': 'Solicitar servicio',
                          },
                          onOpcionSeleccionada: (value) {
                            if (value == 'ver_proveedor') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProvPerfil(
                                        idUsuario: producto.idusuario,
                                        idProveedor: producto.idproveedor,
                                      ),
                                ),
                              );
                            } else if (value == 'solicitar_servicio') {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => SolicitudServicioModal(
                                      producto: producto,
                                      idUsuOrg: widget.idUsuario,
                                      idOrganizador: widget.idOrganizador,
                                    ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
