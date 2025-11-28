import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      accentColor: const Color(0xFF3F51B5),
      backgroundColor: const Color(0xFFF5F6FA),
      cardColor: const Color(0xFFFFFFFF),
      errorColor: const Color(0xFFD32F2F),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color.fromARGB(255, 195, 195, 195),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 10,
      enableFeedback: true,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shadowColor: Colors.black54,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      accentColor: const Color(0xFF29B6F6),
      backgroundColor: const Color(0xFF0F0F12),
      cardColor: const Color(0xFF1C1C1E),
      errorColor: const Color(0xFFEF5350),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor: const Color(0xFF29B6F6),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color.fromARGB(255, 29, 28, 28),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 10,
      enableFeedback: true,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shadowColor: Color.fromARGB(236, 0, 0, 0),
    ),
  );
}
