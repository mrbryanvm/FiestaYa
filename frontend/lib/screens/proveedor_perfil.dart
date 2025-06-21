import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../componentes/modal_red_social.dart';
import '../componentes/mostrar_aviso.dart';
import '../decoracion/colores_app.dart';
import '../modelos/perfil_proveedor.dart';
import '../services/api_service.dart';
import '../decoracion/tema.dart';

class ProveedorPerfil extends StatefulWidget {
  final int idUsuario;
  final int idProveedor;

  const ProveedorPerfil({
    super.key,
    required this.idUsuario,
    required this.idProveedor,
  });

  @override
  State<ProveedorPerfil> createState() => _ProveedorPerfilState();
}

class _ProveedorPerfilState extends State<ProveedorPerfil> {
  bool editando = false;
  PerfilProveedor? perfil;
  final nombreUsuarioController = TextEditingController();
  final nombreNegocioController = TextEditingController();
  final propietarioController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final ubicacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    final p = await ApiService.obtenerPerfilProveedor(widget.idUsuario);
    setState(() {
      perfil = p;
      nombreUsuarioController.text = p.nomUsuario;
      nombreNegocioController.text = p.nombreNegocio;
      propietarioController.text = p.propietario;
      telefonoController.text = p.telefono.toString();
      correoController.text = p.correoElectronico;
      ubicacionController.text = p.ubicacion;
    });
  }

  Future<void> guardarCambios() async {
    final actualizado = PerfilProveedor(
      idUsuario: perfil!.idUsuario,
      nomUsuario: perfil!.nomUsuario,
      correoElectronico: correoController.text.trim(),
      perfil: perfil!.perfil,
      nombreNegocio: nombreNegocioController.text.trim(),
      propietario: propietarioController.text.trim(),
      telefono: int.parse(telefonoController.text.trim()),
      ubicacion: ubicacionController.text.trim(),
    );

    try {
      await ApiService.actualizarPerfilProveedor(actualizado);
      setState(() {
        perfil = actualizado;
        editando = false;
      });
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

  void _agregarRedSocial() async {
    final seAgregoRed = await showDialog<bool>(
      context: context,
      builder:
          (context) => ModalRedSocial(
            idProveedor: widget.idProveedor,
            idUsuario: widget.idUsuario,
          ),
    );
    if (seAgregoRed == true) {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Guardado',
        contenido: 'Red agregada correctamente.',
        onAceptar: () {},
      );
    } else {
      if (!mounted) return;
      await mostrarAviso(
        context: context,
        titulo: 'Aviso',
        contenido: 'No se añadió ningúna red',
        onAceptar: () {},
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
        title: Text('Perfil del Proveedor'),
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
              controller: nombreNegocioController,
              decoration: InputDecoration(
                labelText: 'Nombre del Negocio',
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
            const SizedBox(height: 5),
            TextField(
              controller: nombreUsuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de Usuario',
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
              controller: propietarioController,
              decoration: InputDecoration(
                labelText: 'Propietario',
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
            TextField(
              controller: correoController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
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
              keyboardType: TextInputType.emailAddress,
              enabled: editando,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ubicacionController,
              decoration: InputDecoration(
                labelText: 'Ubicación',
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
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Añadir'),
              onPressed: _agregarRedSocial,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.naranja,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
