import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class CartifyApp extends StatefulWidget {
  const CartifyApp({super.key});

  @override
  State<CartifyApp> createState() => _CartifyAppState();
}

class _CartifyAppState extends State<CartifyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartify E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}