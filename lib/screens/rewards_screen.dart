import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  REWARDS SCREEN — DeliVip Récompenses restaurants
// ═══════════════════════════════════════════════════════════════════

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final Set<int> _favourites = {4}; // item index 4 (Iguanas) favourited by default

  final List<_RestaurantItem> _restaurants = [
    _RestaurantItem(
      name: 'Ice Cream Bar',
      rating: '4.1',
      emoji: '\u{1F366}',
      gradientStart: const Color(0xFFFF6B9D),
      gradientEnd: const Color(0xFFFF8C69),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
    _RestaurantItem(
      name: 'Coco Restaurant',
      rating: '4.1',
      emoji: '\u{1F35C}',
      gradientStart: const Color(0xFFFFF3E0),
      gradientEnd: const Color(0xFFFFE0B2),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
    _RestaurantItem(
      name: 'Cherrp',
      rating: '4.1',
      emoji: '\u{1F357}',
      gradientStart: const Color(0xFFFF5722),
      gradientEnd: const Color(0xFFFF7043),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
    _RestaurantItem(
      name: 'Lizzy\'s Home',
      rating: '4.1',
      emoji: '\u{1F958}',
      gradientStart: const Color(0xFF4E342E),
      gradientEnd: const Color(0xFF6D4C41),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
    _RestaurantItem(
      name: 'Iguanas',
      rating: '4.1',
      emoji: '\u{1F354}',
      gradientStart: const Color(0xFFE91E8C),
      gradientEnd: const Color(0xFFFF4081),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
    _RestaurantItem(
      name: 'Shrippy Cos',
      rating: '4.1',
      emoji: '\u{1F957}',
      gradientStart: const Color(0xFF8D6E63),
      gradientEnd: const Color(0xFFA1887F),
      subtitle: '3.50 DH Livraison \u2022 30\u201335 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Tab Bar ──────────────────────────────────────────
            _buildTabBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Text(
                        'Gagnez des r\u00E9compenses restaurants',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Restaurant list
                    ...List.generate(_restaurants.length, (i) => _buildRestaurantCard(i)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 8),
          Text(
            'Offres',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ TAB BAR ═══════════════════════════════════
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Offres tab (inactive)
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u{1F48E} Offres',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 2, width: 0, color: Colors.transparent),
              ],
            ),
          ),
          // Récompenses tab (active)
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u{2B50} R\u00E9compenses',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 2, width: 36, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ RESTAURANT CARD ═══════════════════════════
  Widget _buildRestaurantCard(int index) {
    final item = _restaurants[index];
    final isFav = _favourites.contains(index);

    return Column(
      children: [
        // Image area
        SizedBox(
          width: double.infinity,
          height: 180,
          child: Stack(
            children: [
              // Gradient background with emoji
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [item.gradientStart, item.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 65)),
                ),
              ),
              // Heart icon top right
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isFav) {
                        _favourites.remove(index);
                      } else {
                        _favourites.add(index);
                      }
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Info row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                item.rating,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Subtitle
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.subtitle,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Thin divider between cards
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Supporting model
// ═══════════════════════════════════════════════════════════════════

class _RestaurantItem {
  final String name;
  final String rating;
  final String emoji;
  final Color gradientStart;
  final Color gradientEnd;
  final String subtitle;

  const _RestaurantItem({
    required this.name,
    required this.rating,
    required this.emoji,
    required this.gradientStart,
    required this.gradientEnd,
    required this.subtitle,
  });
}
