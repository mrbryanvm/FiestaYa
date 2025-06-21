import 'package:flutter/material.dart';
import '../decoracion/colores_app.dart';

class Textfield extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const Textfield({
    super.key,
    required this.labeltext,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labeltext,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColoresApp.celeste),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColoresApp.celeste, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
