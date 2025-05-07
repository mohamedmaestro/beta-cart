import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String quantity;
  final double price;
  final double mrp;
  final String description;
  final String ingredients;
  final String nutrition;
  final String imageUrl;
  final int quantityValue;
  final int itemquantity;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.mrp,
    required this.description,
    required this.ingredients,
    required this.nutrition,
    required this.imageUrl,
    this.quantityValue = 1,
    this.itemquantity = 1,
  });

  Product copyWith({
    String? id,
    String? name,
    String? quantity,
    double? price,
    double? mrp,
    String? description,
    String? ingredients,
    String? nutrition,
    String? imageUrl,
    int? quantityValue,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      nutrition: nutrition ?? this.nutrition,
      imageUrl: imageUrl ?? this.imageUrl,
      quantityValue: quantityValue ?? this.quantityValue,
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantityValue));
  }

  get totalAmount => null;

  void addItem(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantityValue: _items[index].quantityValue + 1,
      );
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantityValue: _items[index].quantityValue + 1,
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (_items[index].quantityValue > 1) {
        _items[index] = _items[index].copyWith(
          quantityValue: _items[index].quantityValue - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // ID-based versions
  void increaseQuantityById(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantityValue: _items[index].quantityValue + 1,
      );
      notifyListeners();
    }
  }

  void decreaseQuantityById(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (_items[index].quantityValue > 1) {
        _items[index] = _items[index].copyWith(
          quantityValue: _items[index].quantityValue - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}