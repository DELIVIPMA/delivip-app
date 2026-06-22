import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'restaurant_menu_screen.dart';

import '../data/models.dart';
import '../pages/category_list_page.dart';
import '../widgets/global_background.dart';
import '../widgets/responsive_helper.dart';

/// O(1) restaurant lookup map (shared across all navigation entry points)
final Map<String, Restaurant> _globalRestaurantByName = {
  for (final r in sampleRestaurants) r.name: r,
};

/// App Shell with persistent bottom navigation using floating glass nav bar.
/// Sub-pages (restaurant menu, category) are stacked via Stack overlay.
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

  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

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
      const CartScreen(),
      const AccountScreen(),
    ];
  }

  void _switchTab(int index) {
    _pageStack.clear();
    setState(() => _currentIndex = index);
  }

  void _openRestaurant(Restaurant r) {
    setState(
      () => _pageStack.add(
        RestaurantMenuScreen(
          restaurant: r,
          onBack: _popPage,
          onNavigateToCart: () {
            _pageStack.clear();
            _currentIndex = 2;
            setState(() {});
          },
          onNavigateToSearch: () {
            _pageStack.clear();
            _currentIndex = 1;
            setState(() {});
          },
        ),
      ),
    );
  }

  void _openCategory(String c) {
    setState(
      () => _pageStack.add(
        CategoryListPage(
          category: c,
          onBack: _popPage,
          onStoreTap: (cardItem) {
            // Pop the category page first, then push the restaurant menu
            _pageStack.removeLast();
            final restaurant = _globalRestaurantByName[cardItem.name];
            if (restaurant != null) {
              _openRestaurant(restaurant);
            } else {
              final match = _globalRestaurantByName.entries.firstWhere(
                (e) =>
                    cardItem.name.toLowerCase().contains(e.key.toLowerCase()) ||
                    e.key.toLowerCase().contains(cardItem.name.toLowerCase()),
                orElse: () => MapEntry(
                  '',
                  Restaurant(
                    id: cardItem.name.hashCode.toString(),
                    name: cardItem.name,
                    rating: double.tryParse(cardItem.rating) ?? 4.5,
                    time: cardItem.subtitle,
                    fee: '5.00 DH',
                    emoji: '🍽️',
                    imageUrl: cardItem.imageUrl,
                    reviewCount: 100,
                    menu: [],
                  ),
                ),
              );
              _openRestaurant(match.value);
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
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: _hasSubPage
          // ─── Sub-page : full screen overlay (no tab content visible) ──
          ? GlobalBackground(
              child: Stack(
                children: [
                  // Only the topmost sub-page is visible
                  Positioned.fill(child: _pageStack.last),
                ],
              ),
            )
          // ─── Main tabs : show background + tab content ──
          : GlobalBackground(
              child: IndexedStack(index: _currentIndex, children: _tabs),
            ),
      bottomNavigationBar:
          // Full‑screen pages that provide their own bottom bar (no global nav)
          _hasSubPage && _pageStack.last is RestaurantMenuScreen
          ? null
          // Cart tab → CartScreen has its own pill bar → hide global nav
          : _currentIndex == 2
          ? null
          : _hasSubPage
          ? _buildBackBar()
          : _buildGlassBottomNav(),
    );
  }

  // ─── Back Bar (when on sub-page) ───────────────────────
  Widget _buildBackBar() {
    return ResponsiveHelper.constrainWidth(
      context,
      Padding(
        padding: ResponsiveHelper.bottomNavPadding(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: _teal,
                    onPressed: _popPage,
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 15),
                      fontWeight: FontWeight.w500,
                      color: _teal,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Floating Glass Bottom Navigation ──────────────────
  Widget _buildGlassBottomNav() {
    const tabIcons = [
      Icons.home_rounded,
      Icons.search_rounded,
      Icons.shopping_bag_rounded,
      Icons.person_outline_rounded,
    ];
    const tabLabels = ['Home', 'Search', 'Orders', 'Account'];
    const tabCount = 4;

    return ResponsiveHelper.constrainWidth(
      context,
      Padding(
        padding: ResponsiveHelper.bottomNavPadding(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: _teal.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildNavBarStack(tabCount, tabIcons, tabLabels),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the inner stack layers for the navigation bar
  /// (pill indicator, glowing dot, tab items).
  /// Wrapped in a single [LayoutBuilder] so [AnimatedPositioned] widgets
  /// are valid direct children of the [Stack].
  Widget _buildNavBarStack(
    int tabCount,
    List<IconData> tabIcons,
    List<String> tabLabels,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tabWidth = constraints.maxWidth / tabCount;

        final double pillLeft = _currentIndex * tabWidth + (tabWidth - 52) / 2;
        final double dotLeft = _currentIndex * tabWidth + (tabWidth - 6) / 2;

        return Stack(
          children: [
            // ── Animated pill background ──
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              left: pillLeft,
              top: 10,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            // ── Glowing dot indicator ──
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              left: dotLeft,
              top: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _teal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withValues(alpha: 0.45),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: _teal.withValues(alpha: 0.25),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // ── Tab items ──
            Row(
              children: List.generate(tabCount, (index) {
                final bool isActive = index == _currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _switchTab(index),
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Icon(
                          tabIcons[index],
                          size: 24,
                          color: isActive
                              ? _teal
                              : _dark.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tabLabels[index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isActive
                                ? _teal
                                : _dark.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
