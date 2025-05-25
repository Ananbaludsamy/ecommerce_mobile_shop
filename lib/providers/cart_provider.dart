import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final String price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    // แปลง price จาก string เป็น double (ลบ comma และ ກີບ ออก)
    final cleanPrice = product.price.replaceAll(',', '').replaceAll(' ກີບ', '');
    return double.parse(cleanPrice) * quantity;
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}