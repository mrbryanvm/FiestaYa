import 'package:flutter/material.dart';

Future<void> mostrarAviso({
  required BuildContext context,
  required String titulo,
  required String contenido,
  required VoidCallback onAceptar,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              onAceptar();
            },
          ),
        ],
      );
    },
  );
}
