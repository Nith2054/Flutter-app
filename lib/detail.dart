import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'checkout_screen.dart';
import 'checkout_screen.dart'; // Import CheckoutScreen

class DetailScreen extends StatelessWidget {
  final int data; // Product ID passed from the product list

  DetailScreen({required this.data});

  // Fetch product detail based on the product ID
  Future<Map<String, dynamic>> _getProductDetail() async {
    var url = Uri.parse("http://127.0.0.1:5000/products/$data"); // Adjusted endpoint to get specific product
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load product details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getProductDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                  strokeWidth: 4,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No product data found.'));
            } else {
              var product = snapshot.data!;
              String imageUrl = product['image'] ?? 'assets/placeholder.png';
              String title = product['title'] ?? 'Product Title';
              String description = product['description'] ?? 'No description available';
              String price = product['price'] != null ? "\$${product['price']}" : 'Price not available';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display product image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.brown[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        imageUrl,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/placeholder.png', // Local fallback image
                            height: 250,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Product description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Product price and checkout button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price:",
                        style: TextStyle(fontSize: 18, color: Colors.brown[800]),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to CheckoutScreen, pass product to checkout
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: [product], // Pass product to checkout
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, // Modify this color as desired
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "CheckOut",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
