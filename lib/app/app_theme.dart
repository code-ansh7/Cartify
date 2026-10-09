import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFFFF9F2),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD95D39),
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD95D39),
      foregroundColor: Colors.black,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF1C1917),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD95D39),
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD95D39),
      foregroundColor: Colors.white,
    ),
  );
}
