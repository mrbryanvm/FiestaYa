import 'package:flutter/material.dart';

class ThemeProvider {
  static final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  static void toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
