import 'package:flutter/material.dart';
import '../componentes/google_button.dart';
import '../componentes/mostrar_aviso.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import '../services/api_service.dart';
import 'organizador_home.dart';
import 'preregistro.dart';
import 'proveedor_home.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  Future<void> _iniciarSesion() async {
    final emailOUsuario = emailController.text.trim();
    final contrasena = passwordController.text.trim();

    if (emailOUsuario.isEmpty || contrasena.isEmpty) {
      mostrarAviso(
        context: context,
        titulo: 'Campos vacíos',
        contenido: 'Por favor, complete todos los campos.',
        onAceptar: () {},
      );
      return;
    }

    try {
      final respuesta = await ApiService.autenticarUsuario(
        nomusuario: emailOUsuario.contains('@') ? null : emailOUsuario,
        correoelectronico: emailOUsuario.contains('@') ? emailOUsuario : null,
        contrasena: contrasena,
      );

      print('✅ Usuario autenticado: $respuesta');

      if (!mounted) return;

      if (respuesta.containsKey('error')) {
        throw Exception(respuesta['error']);
      }

      final tipoUsuario = respuesta['tipoUsuario'];
      final idUsuario = respuesta['idusuario'];

      if (tipoUsuario == 'organizador') {
        if (respuesta['idorganizador'] == null) {
          throw Exception(
            'El campo idorganizador no está presente en la respuesta.',
          );
        }
        final int idRol = respuesta['idorganizador'];
        final String usuario = respuesta['nombre'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => OrganizadorHome(
                  idusuario: idUsuario,
                  idOrganizador: idRol,
                  tipoUsuario: tipoUsuario,
                  nombre: usuario,
                ),
          ),
        );
      } else if (tipoUsuario == 'proveedor') {
        if (respuesta['idproveedor'] == null) {
          throw Exception(
            'El campo idproveedor no está presente en la respuesta.',
          );
        }
        final int idRol = respuesta['idproveedor'];
        final String usuario = respuesta['empresa'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProveedorHome(
                  idusuario: idUsuario,
                  idProveedor: idRol,
                  tipoUsuario: tipoUsuario,
                  empresa: usuario,
                ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error al iniciar sesión: $e');
      mostrarAviso(
        context: context,
        titulo: 'Error',
        contenido: e.toString().replaceFirst('Exception: ', ''),
        onAceptar: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión'),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Text(
                    'Konekta',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: ColoresApp.naranja,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset("assets/images/home.jpg", height: 250),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico o usuario',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColoresApp.celeste),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColoresApp.celeste,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColoresApp.celeste),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColoresApp.celeste,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: IconTheme.of(context).color,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _iniciarSesion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.naranja,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: GoogleButton(
                      text: 'Acceder con Google',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreRegistro()),
                      );
                    },
                    child: const Text("¿Aún no estas registrado?"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
