import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedFilter = 'All'; // Default

  final List<String> filters = ['All', 'Veg', 'Non-Veg'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Filter Toggle: Veg / Non-Veg / All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              filters.map((filter) {
                final isSelected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = filter;
                      // TODO: Apply filtering to item lists if needed
                    });
                  },
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 20),
        const SectionTitle(title: 'Popular Near You'),
        const SizedBox(height: 10),
        const HorizontalItemList(items: []),

        const SizedBox(height: 20),
        const SectionTitle(title: 'Offers for You'),
        const SizedBox(height: 10),
        const HorizontalOfferList(items: []),

        const SizedBox(height: 20),
        const SectionTitle(title: 'Recently Ordered'),
        const SizedBox(height: 10),
        const HorizontalItemList(items: []),

        const SizedBox(height: 20),
        const SectionTitle(title: 'AI Suggested for You'),
        const SizedBox(height: 10),
        const HorizontalItemList(items: []),

        const SizedBox(height: 20),
        const SectionTitle(title: 'Featured Restaurants'),
        const SizedBox(height: 10),
        const HorizontalRestaurantList(items: []),
      ],
    );
  }
}

// ---------------- Section Title ----------------
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

// ---------------- Horizontal Food Items ----------------
class HorizontalItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const HorizontalItemList({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child:
          items.isEmpty
              ? const Center(child: Text('No items'))
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FoodCard(item: item);
                },
              ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const FoodCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item['image'] != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
              : Container(
                height: 90,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.fastfood)),
              ),
          const SizedBox(height: 8),
          Text(
            item['name'] ?? 'Item Name',
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '\$${item['price'] ?? '0.00'}',
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}

// ---------------- Horizontal Offers ----------------
class HorizontalOfferList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const HorizontalOfferList({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child:
          items.isEmpty
              ? const Center(child: Text('No offers'))
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final offer = items[index];
                  return OfferCard(offer: offer);
                },
              ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;

  const OfferCard({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer['title'] ?? 'Offer Title',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            offer['description'] ?? 'Offer description goes here.',
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------- Horizontal Restaurants ----------------
class HorizontalRestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const HorizontalRestaurantList({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child:
          items.isEmpty
              ? const Center(child: Text('No restaurants'))
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final restaurant = items[index];
                  return RestaurantCard(restaurant: restaurant);
                },
              ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantCard({required this.restaurant, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.lightBlue.shade50,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          restaurant['image'] != null
              ? ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  restaurant['image'],
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
              : Container(
                height: 100,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.restaurant)),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  restaurant['name'] ?? 'Restaurant Name',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant['location'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
