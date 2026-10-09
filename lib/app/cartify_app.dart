import 'package:flutter/material.dart';
import 'package:novamart/app/app_theme.dart';
import 'package:novamart/screens/home_screen.dart';

class CartifyApp extends StatelessWidget {
  const CartifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      home: HomeScreen()
    );
  }
}
