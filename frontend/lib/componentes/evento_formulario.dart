import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../decoracion/colores_app.dart';
import '../modelos/departamento.dart';
import '../services/api_service.dart';
import 'mostrar_aviso.dart';

class EventoFormulario extends StatefulWidget {
  final int idOrganizador;
  final int idUsuario;

  const EventoFormulario({
    super.key,
    required this.idOrganizador,
    required this.idUsuario,
  });

  @override
  State<EventoFormulario> createState() => _EventoFormularioState();
}

class _EventoFormularioState extends State<EventoFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _numAsistentesController =
      TextEditingController();
  DateTime? _fechaSeleccionada;
  List<Departamento> _departamentosDisponibles = [];
  Departamento? _departamentoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarDepartamentos();
  }

  void _cargarDepartamentos() async {
    try {
      final departamentos = await ApiService.obtenerDepartamentos();
      setState(() {
        _departamentosDisponibles = departamentos;
      });
    } catch (e) {
      print('Error al cargar departamentos: $e');
    }
  }

  Future<void> _guardarEvento() async {
    if (_formKey.currentState!.validate() && _fechaSeleccionada != null) {
      try {
        await ApiService.crearEvento({
          'nombreevento': _nombreController.text.trim(),
          'fechaevento': DateFormat('yyyy-MM-dd').format(_fechaSeleccionada!),
          'ubicacion': _ubicacionController.text.trim(),
          'numeroasistentes': int.parse(_numAsistentesController.text.trim()),
          'departamento_iddepartamento': _departamentoSeleccionado!.id,
          'descripcion': _descripcionController.text.trim(),
          'organizador_idorganizador': widget.idOrganizador,
          'organizador_usuario_idusuario': widget.idUsuario,
        });

        if (!mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        print('❌ Error al guardar evento: $e');
        mostrarAviso(
          context: context,
          titulo: 'Error',
          contenido: 'No se pudo guardar el evento.',
          onAceptar: () {},
        );
      }
    } else if (_fechaSeleccionada == null) {
      mostrarAviso(
        context: context,
        titulo: 'Falta la fecha',
        contenido: 'Debes seleccionar una fecha para el evento.',
        onAceptar: () {},
      );
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  Future<void> _seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColoresApp.naranja,
      title: const Text('Crear Evento', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del evento',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaSeleccionada == null
                          ? 'Selecciona una fecha'
                          : DateFormat(
                            'dd/MM/yyyy',
                          ).format(_fechaSeleccionada!),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _seleccionarFecha,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numAsistentesController,
                decoration: const InputDecoration(
                  labelText: 'Número de asistentes',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 10),
              _departamentosDisponibles.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<Departamento>(
                    value: _departamentoSeleccionado,
                    hint: const Text('Selecciona departamento'),
                    items:
                        _departamentosDisponibles
                            .map(
                              (d) => DropdownMenuItem(
                                value: d,
                                child: Text(d.nombre),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _departamentoSeleccionado = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Selecciona un departamento' : null,
                  ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
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
            onPressed: _guardarEvento,
            child: const Text('Guardar'),
          ),
        ),
      ],
    );
  }
}
