import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CrearEventoScreen extends StatelessWidget {
  const CrearEventoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14213D), // Oxford Blue
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FiestaYa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Crear evento',
                  style: TextStyle(
                    color: Color(0xFFE5E5E5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                _buildTextField('Escribe el nombre del evento'),
                _buildDropdown('Selecciona el tipo de evento'),
                _buildTextFieldWithIcon('Servicio/s requerido/s', FontAwesomeIcons.globe),
                _buildTextFieldWithIcon('Fecha/s del evento', FontAwesomeIcons.calendar),
                _buildTextFieldWithIcon('Ingresa una ciudad', FontAwesomeIcons.locationDot),
                _buildTextField('Escribe el número máximo de asistentes'),
                _buildDropdown('Selecciona el tipo de evento'),
                _buildDropdown('Permitir visualización de asistentes'),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCA311), // Orange
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCA311), // Orange
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFE5E5E5),
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFE5E5E5),
          hintText: label,
          suffixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration.collapsed(hintText: label),
          items: const [
            DropdownMenuItem(value: '1', child: Text('Opción 1')),
            DropdownMenuItem(value: '2', child: Text('Opción 2')),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }
}
