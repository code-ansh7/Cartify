import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: Text('Order Screen'),
    );
  }
}