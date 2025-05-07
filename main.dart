import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beta_cart/barcode.dart';
import 'package:beta_cart/cart_provider.dart';
import 'package:beta_cart/checkout.dart' as checkout;
import 'package:beta_cart/home.dart';
import 'package:beta_cart/login.dart';
import 'package:beta_cart/mycart.dart';
import 'package:beta_cart/onboardingscreen.dart';
import 'models/product_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beta Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomePage(),
        '/barcode': (context) => const BarcodeScanner(),
        '/myCart': (context) => const MyCart(),
        '/checkout': (context) => const checkout.CheckoutScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }
}
