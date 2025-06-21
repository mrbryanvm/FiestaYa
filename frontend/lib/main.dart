import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'decoracion/colores_app.dart';
import 'decoracion/main_color.dart';
import 'decoracion/tema.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Konekta',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: mainColor,
            scaffoldBackgroundColor: ColoresApp.fondoclaro,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: ColoresApp.fondooscuro),
              bodyMedium: TextStyle(color: ColoresApp.fondooscuro),
              labelLarge: TextStyle(color: ColoresApp.fondooscuro),
            ),
            iconTheme: const IconThemeData(color: ColoresApp.fondooscuro),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: mainColor,
            scaffoldBackgroundColor: ColoresApp.fondooscuro,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: ColoresApp.fondoclaro),
              bodyMedium: TextStyle(color: ColoresApp.fondoclaro),
              labelLarge: TextStyle(color: ColoresApp.fondoclaro),
            ),
            iconTheme: const IconThemeData(color: ColoresApp.fondoclaro),
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}
