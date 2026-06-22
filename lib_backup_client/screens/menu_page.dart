import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/nine_dot_menu.dart';
import '../widgets/section_cards.dart';
import '../models/store_type.dart';

/// ═══════════════════════════════════════════════════════════════════
///  MenuPage — Dashboard with section cards + 9-dot overlay menu
///
///  Bottom layer:   scrollable cards (Restaurants, Boutiques, etc.)
///  Top layer:      9-dot navigation menu centered as an overlay
/// ═══════════════════════════════════════════════════════════════════
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // ═══════ LAYER 1 : Content (scrollable) ═══════
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  const Text(
                    'DeliVIP',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Que souhaitez-vous aujourd\'hui ?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Section Cards ──
                  SectionCard(
                    icon: StoreTypeInfo.get(StoreType.restaurant).icon,
                    title: 'Restaurants',
                    subtitle: 'Commandez vos plats préférés',
                    color: StoreTypeInfo.get(StoreType.restaurant).color,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),

                  SectionCard(
                    icon: StoreTypeInfo.get(StoreType.shop).icon,
                    title: 'Boutiques',
                    subtitle: 'Tout ce dont vous avez besoin',
                    color: StoreTypeInfo.get(StoreType.shop).color,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),

                  SectionCard(
                    icon: Icons.flash_on,
                    title: 'Service rapide',
                    subtitle: 'Livraison en moins de 30 minutes',
                    color: const Color(0xFFFF6D00),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ═══════ LAYER 2 : 9-Dot Menu (overlay) ═══════
          Center(
            child: NineDotMenu(
              centerAlignment: Alignment.center,
              margin: EdgeInsets.zero,
              spreadRadius: 120,
              buttonSize: 56,
              showLabels: true,
              actions: [
                NavAction(
                  icon: Icons.add_shopping_cart,
                  label: 'Nouvelle\ncommande',
                  color: Color(0xFF00BFA5),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.account_balance_wallet,
                  label: 'Wallet',
                  color: Color(0xFFFFC107),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.motorcycle,
                  label: 'Riders',
                  color: Color(0xFF7C4DFF),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.map,
                  label: 'Map',
                  color: Color(0xFFFF5252),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.receipt_long,
                  label: 'Mes\ncommandes',
                  color: Color(0xFF448AFF),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.favorite,
                  label: 'Favoris',
                  color: Color(0xFFFF4081),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.local_offer,
                  label: 'Promos',
                  color: Color(0xFFFF6D00),
                  onTap: _dummyNav,
                ),
                NavAction(
                  icon: Icons.headset_mic,
                  label: 'Support',
                  color: Color(0xFF00BCD4),
                  onTap: _dummyNav,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _dummyNav() {
    // Will be replaced with actual navigation
  }
}
