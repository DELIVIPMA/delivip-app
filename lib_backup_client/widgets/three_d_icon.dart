import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A beautifully styled 3D-like icon widget with gradient background and shadow.
/// Replaces plain emojis with modern Material icons.
class ThreeDIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool showShadow;

  const ThreeDIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(10),
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (backgroundColor ?? Colors.grey[100]!).withValues(
                    alpha: 0.4,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 0,
                  offset: Offset(-1, -1),
                ),
              ]
            : null,
        gradient: backgroundColor != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (backgroundColor!).withValues(alpha: 0.8),
                  backgroundColor!,
                  backgroundColor!.withValues(alpha: 0.6),
                ],
              )
            : null,
      ),
      child: Icon(icon, size: size * 0.55, color: iconColor ?? Colors.white),
    );
  }
}

/// Maps common emoji categories to Material icons
class AppIcons {
  // Store type icons (3D style)
  static IconData forStore(String emoji) {
    switch (emoji) {
      case '🍔':
        return Icons.restaurant_menu;
      case '🍕':
        return Icons.local_pizza;
      case '🥗':
        return Icons.ramen_dining;
      case '🍣':
        return Icons.set_meal;
      case '👗':
        return Icons.checkroom;
      case '👟':
        return Icons.run_circle;
      case '👜':
        return Icons.shopping_bag;
      case '🏪':
        return Icons.storefront;
      case '🛒':
        return Icons.shopping_cart;
      case '🧺':
        return Icons.shopping_basket;
      case '🛍️':
        return Icons.shopping_bag;
      case '🍟':
        return Icons.restaurant;
      case '🥤':
        return Icons.coffee;
      case '🍱':
        return Icons.dining;
      case '👨‍👩‍👧‍👦':
        return Icons.people;
      default:
        return Icons.storefront;
    }
  }

  static IconData forProduct(String emoji) {
    return forStore(emoji);
  }

  // Category icons
  static IconData get restaurants => Icons.restaurant_menu;
  static IconData get boutiques => Icons.shopping_bag;
  static IconData get supermarkets => Icons.storefront;

  // UI icons
  static IconData get location => Icons.location_on;
  static IconData get search => Icons.search;
  static IconData get notifications => Icons.notifications;
  static IconData get home => Icons.home;
  static IconData get orders => Icons.receipt_long;
  static IconData get account => Icons.person;
  static IconData get cart => Icons.shopping_cart;
  static IconData get star => Icons.star;
  static IconData get clock => Icons.access_time;
  static IconData get add => Icons.add;
  static IconData get remove => Icons.remove;
  static IconData get close => Icons.close;
  static IconData get check => Icons.check;
  static IconData get arrowDown => Icons.keyboard_arrow_down;
  static IconData get arrowRight => Icons.chevron_right;
  static IconData get fire => Icons.local_fire_department;
  static IconData get note => Icons.edit;
  static IconData get truck => Icons.local_shipping;
  static IconData get discount => Icons.percent;
  static IconData get promo => Icons.bolt;
  static IconData get info => Icons.info;

  // Store category color mapping
  static Color colorForCategory(String category) {
    switch (category) {
      case 'restaurants':
        return const Color(0xFFFF7043);
      case 'boutiques':
        return const Color(0xFFEC407A);
      case 'supermarkets':
        return const Color(0xFF26A69A);
      default:
        return AppTheme.primary;
    }
  }

  static Color bgColorForCategory(String category) {
    switch (category) {
      case 'restaurants':
        return const Color(0xFFFFF3E0);
      case 'boutiques':
        return const Color(0xFFFCE4EC);
      case 'supermarkets':
        return const Color(0xFFE0F2F1);
      default:
        return const Color(0xFFF5F5F5);
    }
  }
}
