import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // API se products fetch karne ka function
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _products = data.map((jsonItem) => Product.fromJson(jsonItem)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}