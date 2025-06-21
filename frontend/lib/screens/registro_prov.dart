import 'package:flutter/material.dart';
import '../componentes/mostrar_aviso.dart';
import '../componentes/textfield.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import '../modelos/departamento.dart';
import '../services/api_service.dart';
import 'pref_service.dart';

class RegistroProv extends StatefulWidget {
  const RegistroProv({super.key});

  @override
  State<RegistroProv> createState() => _RegistroProvState();
}

class _RegistroProvState extends State<RegistroProv> {
  final TextEditingController nombreNegocioController = TextEditingController();
  final TextEditingController propietarioController = TextEditingController();
  final TextEditingController numrefController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool passwordVisible = false;
  bool cargando = false;
  List<Departamento> departamentos = [];
  Departamento? departamentoSeleccionado;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Konekta',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.naranja,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Bienvenido',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Textfield(
                  labeltext: 'Nombre del negocio',
                  controller: nombreNegocioController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                Textfield(
                  labeltext: 'Propietario (nombre completo)',
                  controller: propietarioController,
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
                              labelText: 'Departamento del negocio',
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
                Textfield(
                  labeltext: 'Ubicación del negocio',
                  controller: ubicacionController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                Textfield(
                  labeltext: 'Correo electronico de referencia',
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
                const SizedBox(height: 15),
                SizedBox(
                  width: 250,
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
                                  contenido: 'Las contraseñas no coinciden.',
                                  onAceptar: () {},
                                );
                                return;
                              }

                              final nombreNegocio =
                                  nombreNegocioController.text.trim();
                              final propietario =
                                  propietarioController.text.trim();
                              final numReferencia =
                                  numrefController.text.trim();
                              final ubicacion = ubicacionController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final departamentoId =
                                  departamentoSeleccionado?.id;

                              if (nombreNegocio.isEmpty ||
                                  propietario.isEmpty ||
                                  numReferencia.isEmpty ||
                                  ubicacion.isEmpty ||
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
                                return;
                              }

                              try {
                                final resultado =
                                    await ApiService.registrarProveedor({
                                      'nomusuario': nombreNegocio,
                                      'contrasena': password,
                                      'correoelectronico': email,
                                      'departamento_iddepartamento':
                                          departamentoId,
                                      'nombrenegocio': nombreNegocio,
                                      'propietario': propietario,
                                      'telefono': numReferencia,
                                      'ubicacion': ubicacion,
                                    });
                                final int idUsuario = resultado['idusuario'];
                                final int idProveedor =
                                    resultado['idproveedor'];
                                if (!context.mounted) return;
                                mostrarAviso(
                                  context: context,
                                  titulo: 'Registro exitoso',
                                  contenido:
                                      'El proveedor fue registrado correctamente.',
                                  onAceptar: () {
                                    setState(() => cargando = false);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PrefService(
                                              idUsuario: idUsuario,
                                              idProveedor: idProveedor,
                                              empresa: nombreNegocio,
                                            ),
                                      ),
                                    );
                                  },
                                );
                                nombreNegocioController.clear();
                                propietarioController.clear();
                                numrefController.clear();
                                ubicacionController.clear();
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
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.naranja,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Continuar registro',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
