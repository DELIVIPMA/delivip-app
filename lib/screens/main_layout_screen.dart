import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'orders_screen.dart';
import 'account_screen.dart';
import 'restaurant_menu_screen.dart';
import '../data/models.dart';
import '../pages/category_list_page.dart';
import '../pages/dynamic_listing_page.dart';

/// App Shell with persistent bottom navigation.
/// Sub-pages (restaurant menu, category) are stacked via Stack overlay,
/// so the bottom nav bar stays visible at all times.
class MainLayoutScreen extends StatefulWidget {
  final String? initialAddress;
  const MainLayoutScreen({super.key, this.initialAddress});
  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  /// Stack of overlay pages pushed on top of tab content
  final List<Widget> _pageStack = [];

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeScreen(
        initialAddress: widget.initialAddress,
        onOpenRestaurant: _openRestaurant,
        onOpenCategory: _openCategory,
        onOpenSearch: () => _switchTab(1),
      ),
      const SearchPage(),
      const OrdersScreen(),
      const AccountScreen(),
    ];
  }

  void _switchTab(int index) {
    _pageStack.clear();
    setState(() => _currentIndex = index);
  }

  void _openRestaurant(Restaurant r) {
    setState(
      () =>
          _pageStack.add(RestaurantMenuScreen(restaurant: r, onBack: _popPage)),
    );
  }

  void _openCategory(String c) {
    setState(
      () => _pageStack.add(
        CategoryListPage(
          category: c,
          onBack: _popPage,
          onStoreTap: (cardItem) {
            // Find matching restaurant from sample data by name
            try {
              final restaurant = sampleRestaurants.firstWhere(
                (r) =>
                    cardItem.name.toLowerCase().contains(
                      r.name.toLowerCase(),
                    ) ||
                    r.name.toLowerCase().contains(cardItem.name.toLowerCase()),
              );
              _openRestaurant(restaurant);
            } catch (_) {
              // No match found: create a Restaurant from the card item data
              final rating = double.tryParse(cardItem.rating) ?? 4.5;
              _pageStack.add(
                RestaurantMenuScreen(
                  restaurant: Restaurant(
                    id: cardItem.name.hashCode.toString(),
                    name: cardItem.name,
                    rating: rating,
                    time: cardItem.subtitle,
                    fee: '5.00 DH',
                    emoji: '🍽️',
                    imageUrl: cardItem.imageUrl,
                    reviewCount: 100,
                    menu: [],
                  ),
                  onBack: _popPage,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _popPage() {
    if (_pageStack.isNotEmpty) {
      setState(() => _pageStack.removeLast());
    }
  }

  bool get _hasSubPage => _pageStack.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          // Main tab content
          IndexedStack(index: _currentIndex, children: _tabs),
          // Overlay sub-pages (above tabs, below bottom nav)
          ..._pageStack.map((p) => Positioned.fill(child: p)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final accent = const Color(0xFF0E6B56);
    final grey = const Color(0xFF8E8E93);

    // When on a sub-page, show a back bar instead of tab icons
    if (_hasSubPage) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: accent,
                  onPressed: _popPage,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: accent,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    // Normal tab bar
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Home', 0, accent, grey),
              _navItem(Icons.search, 'Search', 1, accent, grey),
              _navItem(Icons.shopping_bag_outlined, 'Orders', 2, accent, grey),
              _navItem(Icons.person_outline, 'Account', 3, accent, grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index,
    Color active,
    Color inactive,
  ) {
    final on = index == _currentIndex;
    return GestureDetector(
      onTap: () => _switchTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: on ? active : inactive),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: on ? active : inactive,
              fontWeight: on ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
