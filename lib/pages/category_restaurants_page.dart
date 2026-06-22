import 'package:flutter/material.dart';

class CategoryRestaurantsPage extends StatefulWidget {
  final String categoryName;

  const CategoryRestaurantsPage({super.key, required this.categoryName});

  @override
  State<CategoryRestaurantsPage> createState() =>
      _CategoryRestaurantsPageState();
}

class _CategoryRestaurantsPageState extends State<CategoryRestaurantsPage> {
  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'First Tacos Agadir',
      'rating': '4.8',
      'time': '20-30 min',
      'tag': 'Tacos',
    },
    {'name': 'KFC', 'rating': '4.5', 'time': '15-25 min', 'tag': 'Chicken'},
    {
      'name': 'Burger Station',
      'rating': '4.7',
      'time': '20-40 min',
      'tag': 'Burgers',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final rootNav = Navigator.of(context, rootNavigator: true);
            if (rootNav.canPop()) {
              rootNav.pop();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: _restaurants.length,
        itemBuilder: (context, index) =>
            _buildRestaurantCard(_restaurants[index]),
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Left side: image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.fastfood, size: 36, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            // Middle: restaurant info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['tag'] as String,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        data['rating'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF6B6B6B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['time'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side: Order button
            IconButton(
              icon: const Icon(Icons.message, color: Color(0xFF25D366)),
              tooltip: 'Order via WhatsApp',
              onPressed: () {
                // TODO: Implement PDF generation and WhatsApp routing
              },
            ),
          ],
        ),
      ),
    );
  }
}
