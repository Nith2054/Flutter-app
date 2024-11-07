import 'dart:convert';
import 'package:fake_store/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'checkout_screen.dart';  // Import CheckoutScreen here
import 'detail.dart';
import 'sendDataToAPIServer.dart';
import 'cart.dart';  // Assuming CartScreen is in cart.dart

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> cartItems = [];  // List to store items added to the cart
  Future<List>? _myFuture;

  @override
  void initState() {
    super.initState();
    _myFuture = _getProduct();
  }

  Future<List> _getProduct() async {
    var url = Uri.parse("http://127.0.0.1:5000/products");
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    return data;
  }

  void addToCart(dynamic product) {
    setState(() {
      cartItems.add(product);  // Add product to cart list
    });
  }

  void removeFromCart(dynamic product) {
    setState(() {
      cartItems.remove(product);  // Remove product from cart list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Shop Menu", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProductScreen()),
              );
            },
            icon: Icon(Icons.add_box, size: 28),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: badges.Badge(
              badgeContent: Text(
                "${cartItems.length}",  // Display cart count based on the length of cartItems
                style: TextStyle(fontSize: 12, color: Colors.yellowAccent),
              ),
              badgeAnimation: badges.BadgeAnimation.scale(
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.square,
                badgeColor: Colors.brown,
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        cartItems: cartItems,  // Pass cartItems to CheckoutScreen
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown[300]!, Colors.brown[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List>(
          future: _myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("No record"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(data: 12)),
                    );
                  },
                ),
              );
            }
            var products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.brown[100],
                  elevation: 5,
                  shadowColor: Colors.brown[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(data: product['id']),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              product['image'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "\$${product['price']}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () => print("Favorite"),
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addToCart(product);  // Add product to cart
                              },
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
