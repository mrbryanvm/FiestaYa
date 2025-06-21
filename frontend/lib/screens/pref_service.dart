import 'package:flutter/material.dart';
import '../componentes/icon_button.dart';
import '../componentes/mostrar_aviso.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import '../services/api_service.dart';
import 'registro_catalogo.dart';

class PrefService extends StatefulWidget {
  final int idUsuario;
  final int idProveedor;
  final String empresa;
  const PrefService({
    super.key,
    required this.idUsuario,
    required this.idProveedor,
    required this.empresa,
  });

  @override
  State<PrefService> createState() => _PrefServiceState();
}

class _PrefServiceState extends State<PrefService> {
  final List<Map<String, dynamic>> servicios = [
    {'texto': 'Amplificación', 'icono': Icons.volume_up},
    {'texto': 'Catering', 'icono': Icons.restaurant},
    {'texto': 'Seguridad', 'icono': Icons.security},
    {'texto': 'Fotografía', 'icono': Icons.photo_camera},
    {'texto': 'Cotillón', 'icono': Icons.celebration},
    {'texto': 'Decoración', 'icono': Icons.format_paint},
    {'texto': 'Mobiliario', 'icono': Icons.chair},
    {'texto': 'Transporte', 'icono': Icons.local_shipping},
    {'texto': 'Local', 'icono': Icons.location_city},
    {'texto': 'Limpieza', 'icono': Icons.cleaning_services},
    {'texto': 'Animación', 'icono': Icons.emoji_people},
    {'texto': 'Otros', 'icono': Icons.more_horiz},
  ];

  final Set<String> seleccionados = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro proveedor'),
        backgroundColor: ColoresApp.celeste,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: ColoresApp.naranja),
            onPressed: () {
              ThemeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Text(
                  'Seleccione los servicios que ofrecera',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children:
                        servicios.map((servicio) {
                          final seleccionado = seleccionados.contains(
                            servicio['texto'],
                          );
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconSquareButton(
                                icono: servicio['icono'],
                                onPressed: () {
                                  setState(() {
                                    if (seleccionado) {
                                      seleccionados.remove(servicio['texto']);
                                    } else {
                                      seleccionados.add(servicio['texto']);
                                    }
                                  });
                                },
                                size: 80,
                                iconSize: 50,
                                color:
                                    seleccionado
                                        ? ColoresApp.naranja
                                        : ColoresApp.celeste,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                servicio['texto'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: ColoresApp.naranja,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (seleccionados.isEmpty) {
                        mostrarAviso(
                          context: context,
                          titulo: 'Error',
                          contenido:
                              'Por favor, selecciona al menos un servicio.',
                          onAceptar: () {},
                        );
                        return;
                      }

                      try {
                        await ApiService.registrarPreferencias(
                          categorias: seleccionados.toList(),
                          idProveedor: widget.idProveedor,
                          idUsuario: widget.idUsuario,
                        );
                        if (!context.mounted) return;

                        mostrarAviso(
                          context: context,
                          titulo: 'Éxito',
                          contenido: 'Preferencias registradas correctamente.',
                          onAceptar: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RegistroCatalogo(
                                      idUsuario: widget.idUsuario,
                                      idProveedor: widget.idProveedor,
                                      empresa: widget.empresa,
                                    ),
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        mostrarAviso(
                          context: context,
                          titulo: 'Error',
                          contenido:
                              'Ocurrió un error al registrar preferencias.',
                          onAceptar: () {},
                        );
                      }
                    },
                    child: Text(
                      "Ingresar catálogo",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
