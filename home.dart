import 'package:beta_cart/barcode.dart';
import 'package:beta_cart/barcodeService.dart';
import 'package:beta_cart/cart_provider.dart';
import 'package:beta_cart/home.dart';
import 'package:beta_cart/mycart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beta_cart/services/barcode_service.dart';
import 'package:beta_cart/providers/cart_provider.dart';
import 'package:beta_cart/models/product_model.dart';

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
  int quantityValue;  // Add this line

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
    this.quantityValue = 1,  // Initialize with default value
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _scanBarcode() async {
    try {
      // Call the barcode scanner
      final product = await BarcodeService.scanBarcode(context);

      // Check if we got a product and the widget is still mounted
      if (product == null || !context.mounted) return;

      // Add to cart using the provider
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.addItem(product);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to cart after delay
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyCart(),
          fullscreenDialog: true,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning barcode: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildEnhancedAmazonDrawer(context),
      appBar: AppBar(
        title: const Text('Beta Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BarcodeScanner()),
              );

              if (scannedCode != null && scannedCode is String) {
                final product = getProductByBarcode(scannedCode); // your function

                if (product != null) {
                  Provider.of<CartProvider>(context, listen: false).ad(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found')),
                  );
                }
              }
            },
            tooltip: 'Scan Barcode',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/myCart');
            },
            tooltip: 'View Cart',
          ),
        ],
      ),
      body: _buildWelcomeContent(),
    );
  }

  Widget _buildWelcomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to Beta Cart',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Drawer _buildEnhancedAmazonDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6A11CB),
                  Color(0xFF2575FC),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hello, Mohamed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'noormohamed8645@mountzion.ac.in',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: const Text('Trending', style: TextStyle(fontWeight: FontWeight.bold)),
            initiallyExpanded: true,
            children: [
              _buildDrawerItem(context, 'Bestsellers', Icons.star, color: Colors.amber),
              _buildDrawerItem(context, 'New Releases', Icons.new_releases, color: Colors.green),
              _buildDrawerItem(context, 'Movers and Shakers', Icons.trending_up, color: Colors.red),
            ],
          ),
          ExpansionTile(
            title: const Text('Top Categories', style: TextStyle(fontWeight: FontWeight.bold)),
            initiallyExpanded: true,
            children: [
              _buildDrawerItem(context, 'Groceries', Icons.shopping_cart, onTap: () {
                Navigator.pop(context);
                _navigateToCategory(context, 'Groceries');
              }),
              _buildDrawerItem(context, 'Electronics', Icons.devices, onTap: () {
                Navigator.pop(context);
                _navigateToCategory(context, 'Electronics');
              }),
              _buildDrawerItem(context, 'Fashion', Icons.shopping_bag, onTap: () {
                Navigator.pop(context);
                _navigateToCategory(context, 'Fashion');
              }),
              _buildDrawerItem(context, 'Home & Kitchen', Icons.home, onTap: () {
                Navigator.pop(context);
                _navigateToCategory(context, 'Home & Kitchen');
              }),
              _buildDrawerItem(context, 'See All', Icons.more_horiz, onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/seeAll');
              }),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: 'English',
              isExpanded: true,
              items: <String>['English', 'Hindi', 'Tamil', 'Telugu']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Your Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          _buildDrawerItem(context, 'My Cart', Icons.shopping_cart),
          _buildDrawerItem(context, 'My Purchase History', Icons.shopping_basket),
          _buildDrawerItem(context, 'Offer Zone', Icons.local_offer),
          _buildDrawerItem(context, 'My Wish List', Icons.favorite),
          _buildDrawerItem(context, 'Coupons', Icons.turned_in_sharp),
          _buildDrawerItem(context, 'My Notification', Icons.notifications),
          _buildDrawerItem(context, 'My Account', Icons.person),
          const Divider(),
          _buildDrawerItem(context, 'Settings', Icons.settings),
          _buildDrawerItem(context, 'Sign Out', Icons.exit_to_app),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, {Color color = Colors.blue, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsPage(
          categoryName: category,
          items: _getProductsForCategory(category),
        ),
      ),
    );
  }

  List<Product> _getProductsForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return [
          Product(
            id: 'groceries_banana_001',
            name: 'Organic Bananas',
            quantity: '1 kg',
            price: 59,
            mrp: 79,
            description: 'Fresh organic bananas rich in potassium.',
            ingredients: 'Bananas',
            nutrition: 'Potassium: 358mg per 100g',
            imageUrl: 'https://example.com/banana.jpg',
          ),
        ];
      case 'Electronics':
        return [
          Product(
            id: 'electronics_earbuds_001',
            name: 'Wireless Earbuds',
            quantity: '1 pair',
            price: 1999,
            mrp: 2999,
            description: 'Premium wireless earbuds with ANC.',
            ingredients: '',
            nutrition: '',
            imageUrl: 'https://example.com/earbuds.jpg',
          ),
        ];
      case 'Fashion':
        return [
          Product(
            id: 'fashion_tshirt_001',
            name: 'Cotton T-Shirt',
            quantity: '1 piece',
            price: 499,
            mrp: 799,
            description: '100% cotton premium t-shirt.',
            ingredients: 'Cotton',
            nutrition: '',
            imageUrl: 'https://example.com/tshirt.jpg',
          ),
        ];
      case 'Home & Kitchen':
        return [
          Product(
            id: 'home_pan_001',
            name: 'Non-stick Pan',
            quantity: '1 piece',
            price: 899,
            mrp: 1299,
            description: 'Premium non-stick cooking pan.',
            ingredients: 'Aluminum, Ceramic Coating',
            nutrition: '',
            imageUrl: 'https://example.com/pan.jpg',
          ),
        ];
      default:
        return [
          Product(
            id: 'sample_${category.toLowerCase()}_001',
            name: 'Sample Product',
            quantity: '1 piece',
            price: 99,
            mrp: 129,
            description: 'Sample description for $category.',
            ingredients: 'Sample ingredients',
            nutrition: 'Sample nutrition',
            imageUrl: 'https://example.com/sample.jpg',
          ),
        ];
    }
  }

  getProductByBarcode(String scannedCode) {}
}

class SeeAllPage extends StatelessWidget {
  const SeeAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8E2DE2),
              Color(0xFF4A00E0),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search categories...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildCategorySection('Shop by Department', [
                    'Amazon Fresh',
                    'Health & Personal Care',
                    'Beauty & Luxury',
                    'Home & Kitchen',
                    'Grocery & Gourmet',
                  ], context),
                  _buildCategorySection('Fashion', [
                    'Women\'s Fashion',
                    'Men\'s Fashion',
                    'Kids\' Fashion',
                    'Jewelry',
                    'Watches',
                  ], context),
                  _buildCategorySection('Electronics', [
                    'Mobiles & Accessories',
                    'Computers & Tablets',
                    'TV & Home Entertainment',
                    'Cameras & Photography',
                    'Gaming',
                  ], context),
                  _buildCategorySection('Toys & Games', [
                    'Toys',
                    'Baby Products',
                    'Video Games',
                    'Board Games',
                    'Collectibles',
                  ], context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> categories, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailsPage(
                        categoryName: "All $title",
                        items: _getProductsForCategory(title),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        ...categories.map((category) => _buildCategoryItem(category, context)).toList(),
      ],
    );
  }

  Widget _buildCategoryItem(String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailsPage(
                categoryName: title,
                items: _getProductsForCategory(title),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Product> _getProductsForCategory(String category) {
    switch (category) {
      case 'Amazon Fresh':
        return [
          Product(
            id: 'amazon_fresh_banana_001',
            name: 'Organic Bananas',
            quantity: '1 kg',
            price: 59,
            mrp: 79,
            description: 'Fresh organic bananas rich in potassium.',
            ingredients: 'Bananas',
            nutrition: 'Potassium: 358mg per 100g',
            imageUrl: 'https://example.com/banana.jpg',
          ),
        ];
      case 'Health & Personal Care':
        return [
          Product(
            id: 'health_toothpaste_001',
            name: 'Toothpaste',
            quantity: '100g',
            price: 85,
            mrp: 99,
            description: 'Whitening toothpaste with fluoride.',
            ingredients: 'Fluoride, Hydrated Silica',
            nutrition: '',
            imageUrl: 'https://example.com/toothpaste.jpg',
          ),
        ];
      default:
        return [
          Product(
            id: 'sample_${category.toLowerCase()}_001',
            name: 'Sample Product',
            quantity: '1 piece',
            price: 99,
            mrp: 129,
            description: 'Sample description for $category.',
            ingredients: 'Sample ingredients',
            nutrition: 'Sample nutrition',
            imageUrl: 'https://example.com/sample.jpg',
          ),
        ];
    }
  }
}

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;
  final List<Product> items;

  const CategoryDetailsPage({
    super.key,
    required this.categoryName,
    required this.items,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final product = widget.items[index];
            return _buildProductCard(product, context);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      product.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.shopping_bag),
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product.quantity,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${product.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'MRP: ₹${product.mrp}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isExpanded
                      ? product.description
                      : '${product.description.substring(0,
                      product.description.length > 50 ? 50 : product.description.length)}...',
                  style: const TextStyle(fontSize: 14),
                ),
                if (product.description.length > 50)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Show Less' : 'Show More',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                const SizedBox(height: 12),
                if (product.ingredients.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        product.ingredients,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                if (product.nutrition.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Nutrition:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        product.nutrition,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Provider.of<CartProvider>(context, listen: false).addToCart(product); // Pass the product instance
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white)
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}