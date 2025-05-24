import 'package:flutter/material.dart';

import '../componentes/google_button.dart';
import '../componentes/textfield.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';

class RegistroOrg extends StatefulWidget {
  const RegistroOrg({super.key});

  @override
  State<RegistroOrg> createState() => _RegistroOrgState();
}

class _RegistroOrgState extends State<RegistroOrg> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController numrefController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool passwordVisible = false;

  String? departamentoSeleccionado;
  final List<String> departamentos = [
    'La Paz',
    'Cochabamba',
    'Santa Cruz',
    'Oruro',
    'Potosí',
    'Chuquisaca',
    'Tarija',
    'Beni',
    'Pando',
  ];

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
                      width: 350,
                      child: DropdownButtonFormField<String>(
                        value: departamentoSeleccionado,
                        items:
                            departamentos
                                .map(
                                  (dep) => DropdownMenuItem(
                                    value: dep,
                                    child: SizedBox(
                                      width: 250,
                                      child: Text(dep),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            departamentoSeleccionado = value;
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
                    Textfield(
                      labeltext: 'Ubicación del negocio',
                      controller: ubicacionController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      labeltext: 'Correo electronico',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350,
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
                      width: 350,
                      child: TextField(
                        controller: passwordController,
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
                        onPressed: () {},
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
