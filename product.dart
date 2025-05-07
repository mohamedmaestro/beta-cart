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
  final int quantityValue; // Ensure this exists

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
    required this.quantityValue, // Must be included
  });
}
