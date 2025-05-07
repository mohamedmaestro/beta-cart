import 'package:beta_cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:beta_cart/models/product_model.dart';

class BarcodeService {
  // Product database with sample products
  static final Map<String, Product> productDatabase = {
    't100': Product(
      id: 't100',
      name: 'Biscuit',
      quantity: '1 pack',
      price: 100,
      mrp: 120,
      description: 'Delicious crispy biscuits',
      ingredients: 'Flour, sugar, butter',
      nutrition: 'Energy: 100kcal',
      imageUrl: 'assets/biscuit.png',
      quantityValue: 1, // Only keep this one
    ),
    't200': Product(
      id: 't200',
      name: 'Water Bottle',
      quantity: '1 liter',
      price: 200,
      mrp: 250,
      description: 'Mineral water bottle',
      ingredients: 'Mineral water',
      nutrition: 'Hydration: 100%',
      imageUrl: 'assets/water_bottle.png',
      quantityValue: 1, // Only keep this one
    ),
  };

  // Method to create product from barcode
  static Product createProductFromBarcode(String barcode) {
    return Product(
      id: barcode,
      name: 'Product $barcode',
      quantity: '1 unit',
      price: _generatePrice(barcode),
      mrp: _generatePrice(barcode) * 1.2,
      description: 'Scanned product with barcode $barcode',
      ingredients: 'Various ingredients',
      nutrition: 'Nutritional information',
      imageUrl: 'assets/default_product.png',
      quantityValue: 1, // Only keep this one
    );
  }

  // Helper method for price generation
  static double _generatePrice(String barcode) {
    final hash = barcode.hashCode.abs();
    return (100 + (hash % 900)).toDouble();
  }

  // Main scanning method
  static Future<Product?> scanBarcode(BuildContext context) async {
    try {
      // Implement your scanning logic here
      // This could use MobileScanner or another package
      // For now, we'll return a mock product
      await Future.delayed(const Duration(seconds: 1)); // Simulate scan delay
      return createProductFromBarcode('t${DateTime.now().millisecondsSinceEpoch}');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanning failed: $e')),
        );
      }
      return null;
    }
  }
}