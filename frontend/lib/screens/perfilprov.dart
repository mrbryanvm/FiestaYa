import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../decoracion/colores_app.dart';
import '../modelos/perfil_proveedor.dart';
import '../services/api_service.dart';

class ProvPerfil extends StatefulWidget {
  final int idUsuario;
  final int idProveedor;

  const ProvPerfil({
    super.key,
    required this.idUsuario,
    required this.idProveedor,
  });

  @override
  State<ProvPerfil> createState() => _ProvPerfilState();
}

class _ProvPerfilState extends State<ProvPerfil> {
  PerfilProveedor? perfil;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    final p = await ApiService.obtenerPerfilProveedor(widget.idUsuario);
    setState(() {
      perfil = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (perfil == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Proveedor'),
        backgroundColor: ColoresApp.celeste,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 25),
            Text(
              'Datos generales',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Text('Nombre del negocio: ${perfil!.nombreNegocio}'),
            const SizedBox(height: 5),
            Text('Nombre de usuario: ${perfil!.nomUsuario}'),
            const SizedBox(height: 15),
            Text('Propietario: ${perfil!.propietario}'),
            const SizedBox(height: 15),
            Text('Teléfono: ${perfil!.telefono}'),
            const SizedBox(height: 15),
            Text('Correo electrónico: ${perfil!.correoElectronico}'),
            const SizedBox(height: 15),
            Text('Ubicación: ${perfil!.ubicacion}'),
            SizedBox(height: 16),
            Text('Departamento: ${perfil!.departamento}'),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
              onPressed: () {},
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.pink),
              onPressed: () {},
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
              onPressed: () {},
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColoresApp.celeste,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
