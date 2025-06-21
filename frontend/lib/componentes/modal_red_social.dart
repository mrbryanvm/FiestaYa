import 'package:flutter/material.dart';
import 'package:konekta_app/decoracion/colores_app.dart';
import '../services/api_service.dart';

class ModalRedSocial extends StatefulWidget {
  final int idProveedor;
  final int idUsuario;

  const ModalRedSocial({
    super.key,
    required this.idProveedor,
    required this.idUsuario,
  });

  @override
  State<ModalRedSocial> createState() => _ModalRedSocialState();
}

class _ModalRedSocialState extends State<ModalRedSocial> {
  final TextEditingController _enlaceController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String? _redSeleccionada;
  bool _cargando = false;

  Future<void> _registrarRedSocial() async {
    final nombre = _redSeleccionada;
    final enlace = _enlaceController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (nombre == null || enlace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nombre y enlace son obligatorios')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      await ApiService.registrarRedSocial(
        nombreRed: nombre,
        enlace: enlace,
        descripcion: descripcion,
        idproveedor: widget.idProveedor,
        idusuario: widget.idUsuario,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColoresApp.naranja,
      title: Text('Nueva Red Social', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _redSeleccionada,
              decoration: InputDecoration(labelText: 'Nombre de la red'),
              items:
                  ['WhatsApp', 'Facebook', 'Instagram']
                      .map(
                        (red) => DropdownMenuItem(value: red, child: Text(red)),
                      )
                      .toList(),
              onChanged: (valor) {
                setState(() {
                  _redSeleccionada = valor;
                });
              },
            ),
            TextFormField(
              controller: _enlaceController,
              decoration: InputDecoration(labelText: 'Enlace'),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción (opcional)'),
            ),
          ],
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
            onPressed: _cargando ? null : _registrarRedSocial,
            child:
                _cargando
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text('Registrar'),
          ),
        ),
      ],
    );
  }
}
