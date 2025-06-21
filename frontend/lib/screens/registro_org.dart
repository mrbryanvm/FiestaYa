import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konekta_app/modelos/departamento.dart';

import '../componentes/google_button.dart';
import '../componentes/mostrar_aviso.dart';
import '../componentes/textfield.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import '../services/api_service.dart';
import 'organizador_home.dart';

class RegistroOrg extends StatefulWidget {
  const RegistroOrg({super.key});

  @override
  State<RegistroOrg> createState() => _RegistroOrgState();
}

class _RegistroOrgState extends State<RegistroOrg> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController numrefController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool passwordVisible = false;
  DateTime? fechaNacimiento;
  Departamento? departamentoSeleccionado;
  bool cargando = false;
  List<Departamento> departamentos = [];

  @override
  void initState() {
    super.initState();
    cargarDepartamentos();
  }

  Future<void> cargarDepartamentos() async {
    try {
      final datos = await ApiService.obtenerDepartamentos();
      print(
        '📦 Departamentos cargados: ${datos.map((e) => e.nombre).toList()}',
      );
      setState(() {
        departamentos = datos;
        departamentoSeleccionado = datos.first;
      });
    } catch (e) {
      print('🚨 Error cargando departamentos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Organizador'),
        backgroundColor: ColoresApp.celeste,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Konekta',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.naranja,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bienvenido',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      labeltext: 'Nombre de usuario',
                      controller: usuarioController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      labeltext: 'Nombre completo',
                      controller: nombreController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child:
                          departamentos.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField<Departamento>(
                                value: departamentoSeleccionado,
                                items:
                                    departamentos.map((dep) {
                                      return DropdownMenuItem<Departamento>(
                                        value: dep,
                                        child: SizedBox(
                                          width: 250,
                                          child: Text(dep.nombre),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (nuevo) {
                                  setState(() {
                                    departamentoSeleccionado = nuevo;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Departamento de residencia',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColoresApp.celeste,
                                      width: 2,
                                    ),
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
                                dropdownColor: ColoresApp.naranja,
                              ),
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      labeltext: 'Número de referencia',
                      controller: numrefController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (fechaSeleccionada != null) {
                          fechaNacimiento = fechaSeleccionada;

                          fechaNacimientoController.text =
                              '${fechaSeleccionada.day.toString().padLeft(2, '0')}/${fechaSeleccionada.month.toString().padLeft(2, '0')}/${fechaSeleccionada.year}';
                        }
                      },
                      child: AbsorbPointer(
                        child: Textfield(
                          labeltext: 'Fecha de nacimiento',
                          controller: fechaNacimientoController,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      labeltext: 'Correo electronico',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
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
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: !passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed:
                            cargando
                                ? null
                                : () async {
                                  setState(() => cargando = true);

                                  if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    mostrarAviso(
                                      context: context,
                                      titulo: 'Error',
                                      contenido:
                                          'Las contraseñas no coinciden.',
                                      onAceptar: () {},
                                    );
                                    setState(() => cargando = false);
                                    return;
                                  }

                                  final nombreCompleto =
                                      nombreController.text.trim();
                                  final telefono = numrefController.text.trim();
                                  final fechaFormateada = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(fechaNacimiento!);
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  final departamentoId =
                                      departamentoSeleccionado?.id;

                                  if (nombreCompleto.isEmpty ||
                                      telefono.isEmpty ||
                                      fechaFormateada.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty ||
                                      departamentoId == null) {
                                    mostrarAviso(
                                      context: context,
                                      titulo: 'Error',
                                      contenido:
                                          'Por favor, complete todos los campos.',
                                      onAceptar: () {},
                                    );
                                    setState(() => cargando = false);
                                    return;
                                  }

                                  try {
                                    final resultado =
                                        await ApiService.registrarOrganizador({
                                          'nomusuario': nombreCompleto,
                                          'contrasena': password,
                                          'correoelectronico': email,
                                          'departamento_iddepartamento':
                                              departamentoId,
                                          'nombrecompleto': nombreCompleto,
                                          'telefonoorg': telefono,
                                          'fechanacimiento': fechaFormateada,
                                        });

                                    final int idUsuario =
                                        resultado['idusuario'];
                                    final int idOrganizador =
                                        resultado['idorganizador'];
                                    final String nombre =
                                        resultado['nombrecompleto'];

                                    if (!context.mounted) return;

                                    mostrarAviso(
                                      context: context,
                                      titulo: 'Registro exitoso',
                                      contenido:
                                          'El organizador fue registrado correctamente.',
                                      onAceptar: () {
                                        setState(() => cargando = false);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => OrganizadorHome(
                                                  idusuario: idUsuario,
                                                  idOrganizador: idOrganizador,
                                                  tipoUsuario: 'organizador',
                                                  nombre: nombre,
                                                ),
                                          ),
                                        );
                                      },
                                    );

                                    // Limpiar campos
                                    nombreController.clear();
                                    numrefController.clear();
                                    fechaNacimientoController.clear();
                                    emailController.clear();
                                    passwordController.clear();
                                    confirmPasswordController.clear();
                                  } catch (e) {
                                    mostrarAviso(
                                      context: context,
                                      titulo: 'Error',
                                      contenido:
                                          'No se pudo completar el registro: $e',
                                      onAceptar: () {},
                                    );
                                    setState(() => cargando = false);
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.naranja,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child: GoogleButton(
                        text: 'Ingresar con Google',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                Icons.brightness_6,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                ThemeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
