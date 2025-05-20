import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CrearEventoScreen extends StatefulWidget {
  @override
  _CrearEventoScreenState createState() => _CrearEventoScreenState();
}

class _CrearEventoScreenState extends State<CrearEventoScreen> {
  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _maxAsistentesController = TextEditingController();

  // Variables para almacenar selecciones
  String? _tipoEvento;
  String? _servicios;
  DateTime? _fechaEvento;
  bool? _verAsistentes;

  // Opciones para dropdowns
  final List<String> tiposEvento = ['Concierto', 'Conferencia', 'Fiesta', 'Reunión'];
  final List<String> servicios = ['Catering', 'Seguridad', 'Decoración'];

  // Función para seleccionar la fecha del evento
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaEvento = fechaSeleccionada;
      });
    }
  }

  // Acción cuando se presiona "Guardar"
  void _guardarEvento() {
    final nombre = _nombreController.text.trim();
    final ciudad = _ciudadController.text.trim();
    final maxAsistentes = _maxAsistentesController.text.trim();

    if (nombre.isEmpty ||
        _tipoEvento == null ||
        _servicios == null ||
        _fechaEvento == null ||
        ciudad.isEmpty ||
        maxAsistentes.isEmpty ||
        _verAsistentes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Aquí iría la lógica para guardar el evento o hacer la petición al backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento "$nombre" creado correctamente')),
    );

    // Limpia los campos
    _nombreController.clear();
    _ciudadController.clear();
    _maxAsistentesController.clear();
    setState(() {
      _tipoEvento = null;
      _servicios = null;
      _fechaEvento = null;
      _verAsistentes = null;
    });
  }

  // Acción cuando se presiona "Cancelar"
  void _cancelar() {
    Navigator.pop(context); // Vuelve a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1D37),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D37),
        title: Text('FiestaYa', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Crear evento',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            SizedBox(height: 16),
            _buildInputField(_nombreController, 'Nombre del evento'),
            _buildDropdown('Selecciona el tipo de evento', tiposEvento, _tipoEvento, (value) {
              setState(() => _tipoEvento = value);
            }),
            _buildDropdown('Servicios requerido/s', servicios, _servicios, (value) {
              setState(() => _servicios = value);
            }),
            _buildDatePicker(),
            _buildInputField(_ciudadController, 'Ingresa una ciudad', icon: Icons.location_on),
            _buildInputField(_maxAsistentesController, 'Escribe el número máximo de asistentes', keyboardType: TextInputType.number),
            _buildDropdown('Permitir visualización de asistentes', ['Sí', 'No'], _verAsistentes == true ? 'Sí' : _verAsistentes == false ? 'No' : null, (value) {
              setState(() => _verAsistentes = value == 'Sí');
            }),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Cancelar', Colors.orange, _cancelar),
                _buildButton('Guardar', Colors.orange, _guardarEvento),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método reutilizable para campos de texto
  Widget _buildInputField(TextEditingController controller, String label, {IconData? icon, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          hintText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  // Método para construir Dropdowns
  Widget _buildDropdown(String hint, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  // Widget para el selector de fecha
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _seleccionarFecha(context),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            hintText: 'Fecha/s del evento',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            _fechaEvento != null
                ? "${_fechaEvento!.day}/${_fechaEvento!.month}/${_fechaEvento!.year}"
                : '',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }

  // Método para los botones
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.black)),
    );
  }
}
