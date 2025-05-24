import 'package:flutter/material.dart';

import '../decoracion/colores_app.dart';

class IconSquareButton extends StatelessWidget {
  final IconData icono;
  final double size;
  final double iconSize;
  final Color color;
  final VoidCallback onPressed;

  const IconSquareButton({
    super.key,
    required this.icono,
    required this.onPressed,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.color = ColoresApp.celeste,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Icon(icono, size: iconSize, color: IconTheme.of(context).color),
      ),
    );
  }
}
