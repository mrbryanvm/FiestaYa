import 'package:flutter/material.dart';
import '../models/evento_model.dart'; // Importamos el modelo

class CrearEventoScreen extends StatefulWidget {
  const CrearEventoScreen({Key? key}) : super(key: key);

  @override
  _CrearEventoScreenState createState() => _CrearEventoScreenState();
}

class _CrearEventoScreenState extends State<CrearEventoScreen> {
  // Controladores de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController maxAsistentesController = TextEditingController();

  // Variables para guardar datos seleccionados
  String tipoEvento = '';
  List<String> serviciosSeleccionados = [];
  DateTime? fechaEvento;
  bool mostrarAsistentes = false;

  // Función para guardar el evento
  void guardarEvento() {
    if (fechaEvento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una fecha')),
      );
      return;
    }

    // Creamos el objeto Evento
    Evento nuevoEvento = Evento(
      nombre: nombreController.text,
      tipo: tipoEvento,
      servicios: serviciosSeleccionados,
      fecha: fechaEvento!,
      ciudad: ciudadController.text,
      maxAsistentes: int.tryParse(maxAsistentesController.text) ?? 0,
      mostrarAsistentes: mostrarAsistentes,
    );

    // Aquí puedes hacer print o enviar al backend
    print(nuevoEvento.toJson());

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento guardado exitosamente')),
    );
  }

  // Función para mostrar selector de fecha
  Future<void> seleccionarFecha() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        fechaEvento = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1E40),
      appBar: AppBar(
        title: Text('Crear evento'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: 'Nombre del evento',
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ciudadController,
              decoration: InputDecoration(
                hintText: 'Ciudad',
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: maxAsistentesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Número máximo de asistentes',
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: seleccionarFecha,
              child: Text(fechaEvento == null
                  ? 'Seleccionar fecha'
                  : 'Fecha: ${fechaEvento!.toLocal().toString().split(' ')[0]}'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: tipoEvento.isNotEmpty ? tipoEvento : null,
              hint: Text('Selecciona el tipo de evento'),
              items: ['Concierto', 'Feria', 'Reunión'].map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  tipoEvento = valor!;
                });
              },
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('¿Mostrar asistentes?'),
              value: mostrarAsistentes,
              onChanged: (valor) {
                setState(() {
                  mostrarAsistentes = valor ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.pop(context); // Cancelar
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: guardarEvento,
                  child: Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
