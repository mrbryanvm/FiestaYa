import 'package:flutter/material.dart';
import '../componentes/icon_button.dart';
import '../decoracion/colores_app.dart';
import '../decoracion/tema.dart';
import 'inicio_sesion.dart';
import 'registro_org.dart';
import 'registro_prov.dart';

class PreRegistro extends StatelessWidget {
  const PreRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
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
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Text(
                  'Elije el uso principal que le dará a la aplicación',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                IconSquareButton(
                  icono: Icons.connect_without_contact,
                  size: 180,
                  iconSize: 130,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroProv()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Ofertar servicios',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                IconSquareButton(
                  icono: Icons.celebration_outlined,
                  size: 180,
                  iconSize: 130,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroOrg()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Requerir servicios',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    );
                  },
                  child: const Text("¿Ya estas registrado?"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
