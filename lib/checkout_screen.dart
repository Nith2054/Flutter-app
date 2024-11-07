import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List cartItems;

  CheckoutScreen({required this.cartItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    // Calculate total amount for the cart
    for (var item in widget.cartItems) {
      double price = 0.0;
      double quantity = (item['quantity'] != null && item['quantity'] is double)
          ? item['quantity']
          : 1.0; // Default to 1 if quantity is null

      // Safely parse the price, assuming it's a string
      String priceStr = item['price'] ?? '0.0'; // Default to '0.0' if price is null
      price = double.tryParse(priceStr) ?? 0.0; // Safely parse the price as a double

      // Calculate total amount by multiplying price with quantity
      totalAmount += price * quantity; // Adding the calculated total for this item
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Order',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  double price = 0.0;
                  double quantity = (item['quantity'] != null && item['quantity'] is double)
                      ? item['quantity']
                      : 1.0; // Default to 1 if quantity is null

                  // Safely parse the price, assuming it's a string
                  String priceStr = item['price'] ?? '0.0'; // Default to '0.0' if price is null
                  price = double.tryParse(priceStr) ?? 0.0; // Safely parse the price as a double

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: item['image'] == null
                          ? Icon(Icons.image, size: 50, color: Colors.grey)
                          : Image.network(
                        item['image'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Product ID: ${item['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display Quantity
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      item['quantity'] = (quantity - 1);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    item['quantity'] = (quantity + 1);
                                  });
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          // Display Price below Quantity
                          Text(
                            'Price: \$${(price * quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}', // Display total with 2 decimal places
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle payment processing or any checkout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Proceeding to payment...')),
                  );

                  // Clear cart items after payment is done
                  setState(() {
                    widget.cartItems.clear(); // Remove all products from the cart
                  });

                  // Optionally, navigate back to the previous screen after payment
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.brown[400]!, Colors.orange[400]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
