import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'crear_evento_screen.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  DateTime? fechaNacimiento;
  bool _cargando = false;
  String _mensaje = '';

  final Color azulOxford = Color(0xFF14213D);
  final Color naranja = Color(0xFFFCA311);
  final Color blanco = Colors.white;

  Future<void> registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    if (fechaNacimiento == null) {
      setState(() {
        _mensaje = 'Por favor selecciona tu fecha de nacimiento';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _mensaje = '';
    });

    final url = Uri.parse('http://10.0.2.2:3000/api/usuarios/registro');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombreController.text.trim(),
        'correo': correoController.text.trim(),
        'contrasena': contrasenaController.text.trim(),
        'fechaNacimiento': fechaNacimiento!.toIso8601String(),
      }),
    );

    setState(() {
      _cargando = false;
    });

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CrearEventoScreen()),
      );
    } else {
      setState(() {
        _mensaje = '❌ Error al registrar usuario';
      });
    }
  }

  Future<void> _registrarseConGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CrearEventoScreen()),
      );
    } catch (e) {
      print('Error con Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: 'Selecciona tu fecha de nacimiento',
        cancelText: 'Cancelar',
        confirmText: 'Aceptar',
        locale: const Locale('es', 'ES'),
      );

      if (picked != null) {
        setState(() {
          fechaNacimiento = picked;
        });
      }
    } catch (e) {
      print("Error al seleccionar fecha: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = fechaNacimiento == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(fechaNacimiento!);

   return Scaffold(
  resizeToAvoidBottomInset: true,
  backgroundColor: azulOxford,
  body: SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/logo.png', height: 100),
                    const SizedBox(height: 20),
                    Text('Bienvenido', style: TextStyle(color: blanco, fontSize: 20)),
                    const SizedBox(height: 20),
                    _campoTexto('Nombre de usuario', nombreController),
                    const SizedBox(height: 15),
                    _campoTexto('Correo electrónico', correoController, tipoCorreo: true),
                    const SizedBox(height: 15),
                    _campoTexto('Contraseña', contrasenaController, oculto: true),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () => _seleccionarFecha(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: blanco,
                          labelText: 'Fecha de nacimiento',
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fechaNacimiento == null
                                  ? ''
                                  : DateFormat('dd/MM/yyyy').format(fechaNacimiento!),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _cargando ? null : registrarUsuario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: naranja,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _cargando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Registrarse',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _registrarseConGoogle,
                      icon: Image.asset('assets/google_logo.png', height: 24),
                      label: const Text('Registrarse con Google', style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(_mensaje, style: TextStyle(color: blanco)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
);

  }

  // Campo de texto reutilizable
  Widget _campoTexto(String label, TextEditingController controller,
      {bool oculto = false, bool tipoCorreo = false}) {
    return TextFormField(
      controller: controller,
      obscureText: oculto,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        if (tipoCorreo && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Correo inválido';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
