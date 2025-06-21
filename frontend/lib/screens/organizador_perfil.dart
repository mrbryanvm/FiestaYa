import 'package:flutter/material.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import '../modelos/perfil_organizador.dart';
import '../services/api_service.dart';

class OrganizadorPerfil extends StatefulWidget {
  final int idusuario;
  final int idOrganizador;

  const OrganizadorPerfil({
    super.key,
    required this.idOrganizador,
    required this.idusuario,
  });

  @override
  State<OrganizadorPerfil> createState() => _OrganizadorPerfilState();
}

class _OrganizadorPerfilState extends State<OrganizadorPerfil> {
  bool editando = false;
  PerfilOrganizador? perfil;
  final nomUsuarioController = TextEditingController();
  final correoController = TextEditingController();
  final nomCompletoController = TextEditingController();
  final telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    final p = await ApiService.obtenerPerfilOrganizador(widget.idusuario);
    if (!mounted) return;
    setState(() {
      perfil = p;
      nomUsuarioController.text = p.nomUsuario;
      correoController.text = p.correoElectronico;
      nomCompletoController.text = p.nombreCompleto;
      telefonoController.text = p.telefonoOrg.toString();
    });
  }

  Future<void> guardarCambios() async {
    final actualizado = PerfilOrganizador(
      idUsuario: perfil!.idUsuario,
      nomUsuario: nomUsuarioController.text.trim(),
      correoElectronico: correoController.text.trim(),
      perfil: perfil!.perfil,
      nombreCompleto: nomCompletoController.text.trim(),
      telefonoOrg: telefonoController.text.trim(),
    );

    try {
      await ApiService.actualizarPerfilOrganizador(actualizado);
      setState(() {
        editando = false;
      });
      cargarPerfil();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (perfil == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Organizador'),
        backgroundColor: ColoresApp.celeste,
        actions: [
          IconButton(
            icon: Icon(
              editando ? Icons.check : Icons.edit,
              color: ColoresApp.naranja,
            ),
            onPressed: () {
              if (editando) {
                guardarCambios();
              } else {
                setState(() => editando = true);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6, color: ColoresApp.naranja),
            onPressed: () {
              ThemeProvider.toggleTheme();
            },
          ),
        ],
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
            TextField(
              controller: nomUsuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(
                    editando ? 255 : (0.6 * 255).toInt(),
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  editando ? 255 : (0.6 * 255).toInt(),
                ),
              ),
              enabled: editando,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(
                    editando ? 255 : (0.6 * 255).toInt(),
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  editando ? 255 : (0.6 * 255).toInt(),
                ),
              ),

              enabled: editando,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: nomCompletoController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(
                    editando ? 255 : (0.6 * 255).toInt(),
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  editando ? 255 : (0.6 * 255).toInt(),
                ),
              ),
              enabled: editando,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(
                    editando ? 255 : (0.6 * 255).toInt(),
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  editando ? 255 : (0.6 * 255).toInt(),
                ),
              ),
              keyboardType: TextInputType.phone,
              enabled: editando,
            ),
            const SizedBox(height: 15),
            Text('Departamento: ${perfil!.departamento}'),
          ],
        ),
      ),
    );
  }
}
