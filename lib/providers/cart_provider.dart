import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  final List<String> _wishlistIds = [];

  // Unmodifiable = ye kist kewal provider hi update kr skta hai
  // cartProvider.items.add(...) se List change nahi kar sakte.
  List<CartItem> get items => List.unmodifiable(_items);
  List<String> get wishlistIds => List.unmodifiable(_wishlistIds);

  int get itemCount {
    int count = 0;

    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  double get subtotal {
    double total = 0;

    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  double get deliveryFee => _items.isEmpty ? 0 : 99;

  double get finalTotal => subtotal + deliveryFee;

  void addProduct(Product product) {
    // Check karenge ki product pehle se cart mein hai ya nahi
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].product.id == product.id) {
        _items[i].quantity++;
        notifyListeners();
        return;
      }
    }

    // Agar product cart mein nahi hai, toh naya item add kar do
    _items.add(CartItem(product: product, quantity: 1));

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    // Product ko cart mein search karenge
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].product.id == productId) {
        if (_items[i].quantity > 1) {
          _items[i].quantity--;
        } else {
          _items.removeAt(i);
        }

        notifyListeners();
        return;
      }
    }
  }

  void removeItemCompletely(String productId) {
    // Product milne par use poori tarah remove kar do
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].product.id == productId) {
        _items.removeAt(i);
        notifyListeners();
        return;
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isFavorite(String productId) {
    // Wishlist mein product ID check karo
    for (int i = 0; i < _wishlistIds.length; i++) {
      if (_wishlistIds[i] == productId) {
        return true;
      }
    }

    return false;
  }

  void toggleFavorite(String productId) {
    // Agar product pehle se favorite hai, toh remove kar do
    for (int i = 0; i < _wishlistIds.length; i++) {
      if (_wishlistIds[i] == productId) {
        _wishlistIds.removeAt(i);
        notifyListeners();
        return;
      }
    }
    // Agar favorite nahi hai, toh wishlist mein add kar do
    _wishlistIds.add(productId);
    notifyListeners();
  }
}
