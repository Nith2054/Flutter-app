import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

// Use relative paths for your local files
import 'form.dart';
import 'login_page.dart';
import 'detail.dart';
import 'product_list.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate a login state
    bool isLoggedIn = false; // Set this to true if the user is logged in

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const Dashboard() : const LoginPage(), // Navigate based on login state
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.brown[800],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.point_of_sale_outlined, color: Colors.brown[100]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 10, top: 10),
            child: badges.Badge(
              badgeContent: Text(
                "50",
                style: TextStyle(fontSize: 10, color: Colors.brown[100]),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
                padding: const EdgeInsets.all(5),
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown[800]!, width: 1),
                elevation: 10,
              ),
              onTap: () {},
              child: Icon(Icons.notifications, color: Colors.brown[100]),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("NITH"),
              accountEmail: const Text("nithloy@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage("https://i.pinimg.com/564x/fd/ad/f8/fdadf84d67138a6fb29cad6ce1031d76.jpg"),
              ),
              decoration: BoxDecoration(color: Colors.brown[800]),
            ),
            ListTile(
              leading: const Icon(Icons.storefront_rounded, size: 50, color: Colors.brown),
              title: const Text("Shop Now", style: TextStyle(fontSize: 18, color: Colors.brown)),
              subtitle: const Text("Browse our exclusive items", style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded, size: 50, color: Colors.brown),
              title: const Text("Product List", style: TextStyle(fontSize: 18, color: Colors.brown)),
              subtitle: const Text("View all available products", style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductList()));
              },
            ),
            const Expanded(child: SizedBox()), // Spacer to push Logout to the bottom
            ListTile(
              leading: const Icon(Icons.logout, size: 50, color: Colors.brown),
              title: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.brown)),
              subtitle: const Text("Log out of your account", style: TextStyle(color: Colors.brown)),
              onTap: () {
                // Simulating logout by navigating to LoginPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Version 1.0", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductList()));
                    },
                    child: Card(
                      color: Colors.brown[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront_rounded, size: 60, color: Colors.brown),
                            Text(
                              "Shop Now",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductList()));
                    },
                    child: Card(
                      color: Colors.brown[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list_alt_rounded, size: 60, color: Colors.brown),
                            Text(
                              "Product List",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
