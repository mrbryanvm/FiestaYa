// ignore_for_file: unused_field, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import '../modelos/evento.dart';
import '../modelos/producto.dart';
import '../services/api_service.dart';

class SolicitudServicioModal extends StatefulWidget {
  final Producto producto;
  final int idUsuOrg;
  final int idOrganizador;

  const SolicitudServicioModal({
    super.key,
    required this.producto,
    required this.idUsuOrg,
    required this.idOrganizador,
  });

  @override
  State<SolicitudServicioModal> createState() => _SolicitudServicioModalState();
}

class _SolicitudServicioModalState extends State<SolicitudServicioModal> {
  int cantidad = 1;
  final TextEditingController _detallesController = TextEditingController();
  bool _cargando = true;
  final List<Evento> eventos = [];
  Evento? eventoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarEventosDesdeBD();
  }

  Future<void> _cargarEventosDesdeBD() async {
    setState(() => _cargando = true);
    try {
      final lista = await ApiService.obtenerEventos(widget.idUsuOrg);
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

  Future<bool> enviarSolicitudContrato() async {
    final double total = widget.producto.precio * cantidad;
    final String detalles = '''
    Solicitud de servicio:
    Producto: ${widget.producto.nombre}
    Precio unitario: ${widget.producto.precio.toStringAsFixed(2)} Bs
    Cantidad: $cantidad
    Total: ${total.toStringAsFixed(2)} Bs
    Detalles: ${_detallesController.text}
    Evento: ${eventoSeleccionado?.nombre}
    Fecha evento: ${eventoSeleccionado?.fecha}
    Ubicación: ${eventoSeleccionado?.ubicacion}
    Cantidad de personas: ${eventoSeleccionado?.numeroAsistentes}
    ''';

    final datosContrato = {
      'estado': 'pendiente',
      'detalles': detalles,
      'organizador_idorganizador': widget.idOrganizador,
      'organizador_usuario_idusuario': widget.idUsuOrg,
      'proveedor_idproveedor': widget.producto.idproveedor,
      'proveedor_usuario_idusuario': widget.producto.idusuario,
      'producto_idproducto': widget.producto.id,
      'producto_catalogo_idcatalogo': widget.producto.catalogoId,
      'evento_idevento': eventoSeleccionado?.id,
    };

    try {
      final response = await ApiService.registrarContrato(datosContrato);
      print('✅ Contrato registrado: $response');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Contrato registrado con éxito')),
      );
      return true;
    } catch (e) {
      print('❌ Error al registrar contrato: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error al registrar contrato')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double total = widget.producto.precio * cantidad;

    return AlertDialog(
      title: Text('Solicitar servicio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.producto.nombre,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Precio unitario: ${widget.producto.precio.toStringAsFixed(2)} Bs',
          ),
          SizedBox(height: 12),
          TextField(
            controller: _detallesController,
            decoration: InputDecoration(labelText: 'Detalles del servicio'),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cantidad: $cantidad'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    cantidad++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Total: ${total.toStringAsFixed(2)} Bs'),
          SizedBox(height: 8),
          DropdownButtonFormField<Evento>(
            value: eventoSeleccionado,
            hint: Text('Seleccionar evento'),
            items:
                eventos.map((evento) {
                  return DropdownMenuItem<Evento>(
                    value: evento,
                    child: Text(evento.nombre),
                  );
                }).toList(),
            onChanged: (Evento? newValue) {
              setState(() {
                eventoSeleccionado = newValue;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (eventoSeleccionado == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚠️ Debes seleccionar un evento.'),
                ),
              );
              return;
            }
            final String contenido = '''
              SOLICITUD DE SERVICIO:
              Producto: ${widget.producto.nombre}
              Precio unitario: ${widget.producto.precio.toStringAsFixed(2)} Bs
              Cantidad: $cantidad
              Total: ${total.toStringAsFixed(2)} Bs
              Detalles: ${_detallesController.text}
              EVENTO:
              Nombre: ${eventoSeleccionado?.nombre ?? 'Sin seleccionar'}
              Fecha: ${eventoSeleccionado?.fecha ?? 'Sin fecha'}
              Ubicación: ${eventoSeleccionado?.ubicacion ?? 'Sin ubicación'}
              Cantidad de personas: ${eventoSeleccionado?.numeroAsistentes ?? 'No especificado'}
              ''';

            print(
              '📤 Enviando mensaje de ${widget.idUsuOrg} a ${widget.producto.idusuario}',
            );

            try {
              final exito = await enviarSolicitudContrato();

              try {
                final datos = {
                  'remitente': widget.idUsuOrg,
                  'destinatario': widget.producto.idusuario,
                  'contenido': contenido,
                };
                if (!context.mounted) return;

                print('🧪 Datos JSON antes de enviar: ${jsonEncode(datos)}');
                if (!exito) {
                  Navigator.pop(context);
                  return;
                }

                await ApiService.enviarMensaje(
                  remitente: widget.idUsuOrg,
                  destinatario: widget.producto.idusuario,
                  contenido: contenido,
                );

                if (!context.mounted) return;

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Servicio solicitado y notificado'),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '⚠️ Servicio solicitado, pero no se envió la notificación',
                    ),
                  ),
                );
              }
            } catch (e) {
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('❌ Error al solicitar servicio')),
              );
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
