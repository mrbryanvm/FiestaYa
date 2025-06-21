import 'package:flutter/material.dart';
import '../componentes/card_evento.dart';
import '../componentes/evento_formulario.dart';
import '../componentes/mostrar_aviso.dart';
import '../decoracion/colores_app.dart';
import '../services/api_service.dart';
import '../modelos/evento.dart';

class Eventos extends StatefulWidget {
  final int idUsuario;
  final int idOrganizador;
  const Eventos({
    super.key,
    required this.idUsuario,
    required this.idOrganizador,
  });

  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  bool _cargando = true;
  final List<Evento> eventos = [];

  @override
  void initState() {
    super.initState();
    _cargarEventosDesdeBD();
  }

  Future<void> _cargarEventosDesdeBD() async {
    setState(() => _cargando = true);
    try {
      final lista = await ApiService.obtenerEventos(widget.idUsuario);
      setState(() {
        eventos
          ..clear()
          ..addAll(lista);
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      debugPrint('Error cargando eventos: $e');
    }
  }

  void _agregarEvento() async {
    final seAgregoEvento = await showDialog<bool>(
      context: context,
      builder:
          (context) => EventoFormulario(
            idUsuario: widget.idUsuario,
            idOrganizador: widget.idOrganizador,
          ),
    );

    if (seAgregoEvento == true) {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Guardado',
        contenido: 'Evento registrado correctamente. Cargando eventos...',
        onAceptar: () {},
      );
      _cargarEventosDesdeBD();
    } else {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Aviso',
        contenido: 'No se añadió ningún evento.',
        onAceptar: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Eventos'),
        backgroundColor: ColoresApp.celeste,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    child: ElevatedButton.icon(
                      onPressed: _agregarEvento,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar evento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.naranja,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (_cargando)
                    const Center(child: CircularProgressIndicator())
                  else if (eventos.isEmpty)
                    const Center(
                      child: Text(
                        'Aún no tienes eventos registrados.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: eventos.length,
                        itemBuilder: (context, index) {
                          final e = eventos[index];
                          return Stack(
                            children: [
                              EventoCard(evento: e),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'eliminar') {
                                      final confirmado = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text(
                                                '¿Eliminar evento?',
                                              ),
                                              content: const Text(
                                                'Esta acción no se puede deshacer.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Eliminar'),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirmado == true) {
                                        try {
                                          await ApiService.eliminarEvento(e.id);
                                          setState(() {
                                            eventos.removeAt(index);
                                          });
                                          _cargarEventosDesdeBD();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Evento eliminado exitosamente',
                                              ),
                                            ),
                                          );
                                        } catch (error) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error al eliminar el evento',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'editar',
                                          child: Text('Editar'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'eliminar',
                                          child: Text('Eliminar'),
                                        ),
                                      ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
