import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../data/cart_provider.dart';
import 'responsive_helper.dart';

// ─── Tab Configuration ─────────────────────────────────
const int _tabCount = 4;
const List<IconData> _tabIcons = [
  Icons.home_rounded,
  Icons.search_rounded,
  Icons.shopping_bag_rounded,
  Icons.person_outline_rounded,
];
const List<String> _tabLabels = ['Home', 'Search', 'Cart', 'Account'];

// ═══════════════════════════════════════════════════════════
//  MAIN NAVIGATION SCAFFOLD — Uber Eats Floating Pill Nav
// ═══════════════════════════════════════════════════════════

/// Persistent shell scaffold with a clean elevated pill-shaped
/// floating bottom navigation bar. Works with [StatefulShellRoute].
class MainNavigationScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String? initialAddress;

  const MainNavigationScaffold({
    super.key,
    required this.navigationShell,
    this.initialAddress,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: const ElasticOutCurve(0.75),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    final shell = widget.navigationShell;
    // Cart tab → open full‑screen cart (no bottom nav)
    if (index == 2) {
      GoRouter.of(context).push('/cart');
      // Keep the shell on the current index so the user returns to where they were
      return;
    }
    if (index == shell.currentIndex) return;
    _bounceController.forward(from: 0);
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final currentIndex = widget.navigationShell.currentIndex;
    final Color primaryColor = AppTheme.primaryTeal; // Color(0xFF39BCA8)
    final Color inactiveColor = Colors.black.withOpacity(0.35);

    return ResponsiveHelper.constrainWidth(
      context,
      Padding(
        padding: ResponsiveHelper.bottomNavPadding(context),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double tabWidth = constraints.maxWidth / _tabCount;
              return Stack(
                children: [
                  // Animated pill indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    left: currentIndex * tabWidth + (tabWidth - 48) / 2,
                    top: 8,
                    child: Container(
                      width: 48,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  // Tab items
                  Row(
                    children: List.generate(_tabCount, (index) {
                      final bool isActive = index == currentIndex;
                      final iconColor = isActive ? Colors.white : inactiveColor;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _onTap(index),
                          behavior: HitTestBehavior.translucent,
                          child: AnimatedBuilder(
                            animation: _bounceAnimation,
                            builder: (context, child) {
                              final double scale = isActive
                                  ? 1.0 + 0.18 * _bounceAnimation.value
                                  : 1.0;
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                index == 2
                                    ? _CartTabIcon(
                                        iconColor: iconColor,
                                        active: isActive,
                                      )
                                    : Icon(
                                        _tabIcons[index],
                                        size: 24,
                                        color: iconColor,
                                      ),
                                const SizedBox(height: 2),
                                Text(
                                  _tabLabels[index],
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: iconColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  CART TAB ICON WITH BADGE
// ═══════════════════════════════════════════════════════════

class _CartTabIcon extends StatelessWidget {
  final Color iconColor;
  final bool active;

  const _CartTabIcon({required this.iconColor, required this.active});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final itemCount = cart.itemCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Badge(
            isLabelVisible: itemCount > 0,
            label: Text(
              '$itemCount',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            smallSize: 18,
            largeSize: 18,
            backgroundColor: Colors.redAccent,
            textStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            child: Icon(Icons.shopping_bag_rounded, size: 24, color: iconColor),
          ),
        );
      },
    );
  }
}
