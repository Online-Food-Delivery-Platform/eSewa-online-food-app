import 'package:flutter/material.dart';
import 'package:frontend_foodapp/Dashboard.dart';
import 'package:esewa_flutter/esewa_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String deliveryLocation = 'Tarakeshwar, Kavresthali';
  String promoCode = '';

  List<Map<String, dynamic>> cartItems = [
    {'name': 'Item Name', 'price': 0.0, 'quantity': 1},
  ];

  double deliveryFee = 0.0;
  double discount = 0.0;
  double subtotal = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    total = subtotal + deliveryFee - discount;
  }

  void _updateCart() {
    if (!mounted) return;
    setState(() {
      _calculateTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Row with Back and My Cart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const DashboardScreen(initialIndex: 0),
                        ),
                        (route) => false,
                      );
                    },
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'My Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to balance back icon
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Delivery location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Delivery Location",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                deliveryLocation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // TODO: open map
                          },
                          child: const Text("Change Location"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Promo code input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Promo Code...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (val) => promoCode = val,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: apply promo
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cart items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          color: Colors.orange.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.grey.shade300,
                                  child: const Center(child: Text("Image")),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item['price'].toStringAsFixed(2)}',
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () {
                                              if (item['quantity'] > 1) {
                                                setState(() {
                                                  item['quantity']--;
                                                  _calculateTotals();
                                                });
                                              }
                                            },
                                          ),
                                          Text('${item['quantity']}'),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                item['quantity']++;
                                                _calculateTotals();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cartItems.removeAt(index);
                                      _calculateTotals();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Totals section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow("Total Items", subtotal),
                          _buildSummaryRow("Delivery Fee", deliveryFee),
                          _buildSummaryRow("Discount", -discount),
                          const Divider(),
                          _buildSummaryRow("Total", total, isBold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Proceed to checkout
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Esewa.i.init(
                    context: context,
                    eSewaConfig: ESewaConfig.dev(
                      amt: total,
                      pid: 'PRODUCT-ID-001', // Replace with actual ID
                      su: 'https://example.com/success', // Replace with your success URL
                      fu: 'https://example.com/failure', // Replace with your failure URL
                    ),
                  );

                  if (result.hasData) {
                    final response = result.data!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Payment Successful! Ref ID: ${response.refId}',
                        ),
                      ),
                    );
                  } else {
                    final error = result.error!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Failed: $error')),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
