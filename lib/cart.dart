import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final int user_id;

  CartScreen({required this.user_id});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List> products;
  List cartItems = [];

  @override
  void initState() {
    super.initState();
    products = _getProduct();
  }

  // Fetch products from the API
  Future<List> _getProduct() async {
    var url = Uri.parse("http://127.0.0.1:5000/products");
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    return data;
  }

  // Add product to the cart
  Future<void> _addToCart(int productId, int quantity) async {
    var existingProduct = cartItems.firstWhere(
          (item) => item['id'] == productId,
      orElse: () => {},
    );

    if (existingProduct.isEmpty) {
      setState(() {
        cartItems.add({'id': productId, 'quantity': quantity});
      });
    } else {
      setState(() {
        existingProduct['quantity'] += quantity;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added to cart!')),
    );
  }

  // Remove product from the cart
  Future<void> _removeFromCart(int productId) async {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product removed from cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                } else {
                  double totalAmount = 0;

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = snapshot.data![index];

                      int quantity = cartItems.firstWhere(
                            (item) => item['id'] == product['id'],
                        orElse: () => {'quantity': 0},
                      )['quantity'] ?? 0;

                      double price = 0.0;
                      if (product['price'] != null) {
                        price = double.tryParse(product['price']) ?? 0.0;
                      }

                      double total = quantity * price;
                      totalAmount += total;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product['image'] ?? '',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(product['title'] ?? 'Unknown Product'),
                          subtitle: Text(
                            "Quantity: $quantity x \$${price.toStringAsFixed(2)} = \$${total.toStringAsFixed(2)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _removeFromCart(product['id']);
                                },
                                icon: Icon(Icons.delete_forever_outlined),
                                color: Colors.redAccent,
                              ),
                              IconButton(
                                onPressed: () {
                                  _addToCart(product['id'], 1);
                                },
                                icon: Icon(Icons.add_shopping_cart),
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<List>(
                      future: products,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("Calculating...");
                        }

                        double totalAmount = 0;
                        for (var item in cartItems) {
                          int quantity = item['quantity'] ?? 0;
                          final product = snapshot.data!.firstWhere(
                                (p) => p['id'] == item['id'],
                            orElse: () => {'price': 0},
                          );
                          totalAmount += (product['price']?.toDouble() ?? 0.0) * quantity;
                        }

                        return Text(
                          "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Total Items: ${cartItems.length}",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen(cartItems: cartItems)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
