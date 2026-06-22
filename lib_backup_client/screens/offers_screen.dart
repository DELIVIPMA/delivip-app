import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  OFFERS SCREEN — DeliVip Offres et récompenses
// ═══════════════════════════════════════════════════════════════════

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int _selectedTab = 0; // 0=Offres, 1=Récompenses
  final Set<int> _favourited = {3}; // index 3 (Quernos) favourited

  final List<_OfferResto> _deals = [
    _OfferResto(
      emoji: '\u{1F354}',
      name: 'Papos Burgers',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: 'D\u00E9pensez 200 DH, \u00E9conomisez 50 DH',
      gradientColors: [const Color(0xFFFFCC80), const Color(0xFFE65100)],
    ),
    _OfferResto(
      emoji: '\u{1F355}',
      name: 'Zizza Italiano',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: '\u00C9conomies sur articles s\u00E9lectionn\u00E9s',
      gradientColors: [const Color(0xFFEF9A9A), const Color(0xFFC62828)],
    ),
    _OfferResto(
      emoji: '\u{1F32E}',
      name: 'Zizzy and Friends',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: 'D\u00E9pensez 200 DH, \u00E9conomisez 50 DH',
      gradientColors: [const Color(0xFF81C784), const Color(0xFF2E7D32)],
    ),
    _OfferResto(
      emoji: '\u{1F959}',
      name: 'Quernos',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: '\u00C9conomies sur articles s\u00E9lectionn\u00E9s',
      gradientColors: [const Color(0xFFF8BBD0), const Color(0xFFD81B60)],
    ),
    _OfferResto(
      emoji: '\u{1F957}',
      name: 'Leny Foods',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: '\u00C9conomies sur articles s\u00E9lectionn\u00E9s',
      gradientColors: [const Color(0xFF66BB6A), const Color(0xFF1B5E20)],
    ),
  ];

  final List<_OfferResto> _moreRestos = [
    _OfferResto(
      emoji: '\u{1F371}',
      name: 'Crop Rool Restaurant',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: null,
      gradientColors: [const Color(0xFFBCAAA4), const Color(0xFF4E342E)],
    ),
    _OfferResto(
      emoji: '\u{1F363}',
      name: 'Slads Place',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: '\u00C9conomies sur articles s\u00E9lectionn\u00E9s',
      gradientColors: [const Color(0xFFCE93D8), const Color(0xFF6A1B9A)],
    ),
    _OfferResto(
      emoji: '\u{1F9C7}',
      name: 'Pie Retreat',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: '\u00C9conomies sur articles s\u00E9lectionn\u00E9s',
      gradientColors: [const Color(0xFFFFF176), const Color(0xFFF57F17)],
    ),
    _OfferResto(
      emoji: '\u{1F362}',
      name: 'Mirashe',
      rating: 4.1,
      subtitle: '3.50 DH Livraison \u2022 30-35 min',
      banner: null,
      gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
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
            _buildTopBar(),
            // ── Tab Bar ─────────────────────────────────────────
            _buildTabBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Filter Row ──────────────────────────────────────
            _buildFilterRow(),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ..._deals.asMap().entries.map((e) => _buildDealCard(e.key, e.value)),
                    _buildPaginationDots(),
                    _buildComeBackLater(),
                    ..._moreRestos.asMap().entries.map((e) => _buildDealCard(e.key + _deals.length, e.value)),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Offres',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 36), // balance
        ],
      ),
    );
  }

  // ═══════════════════ TAB BAR ═══════════════════════════════════
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTab == 0 ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.diamond, size: 16, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      'Offres',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTab == 1 ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'R\u00E9compenses',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ FILTER ROW ════════════════════════════════
  Widget _buildFilterRow() {
    final filters = [
      Icons.tune,
      null, // Retrait with emoji
      null, // Trier
      null, // Meilleur
    ];
    final labels = ['', 'Retrait', 'Trier \u25BE', 'Meilleur \u203A'];
    final icons = [Icons.tune, null, null, null];
    final emojis = ['', '\u{1F697}', '', ''];

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        children: List.generate(4, (i) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icons[i] != null)
                  Icon(icons[i], size: 16, color: Colors.black),
                if (emojis[i].isNotEmpty)
                  Text(emojis[i], style: const TextStyle(fontSize: 14)),
                if (labels[i].isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    labels[i],
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.black),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ DEAL CARD ═════════════════════════════════
  Widget _buildDealCard(int index, _OfferResto resto) {
    final isFav = _favourited.contains(index);
    return Column(
      children: [
        // Image area
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: resto.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(resto.emoji, style: const TextStyle(fontSize: 65)),
              ),
              // Promo banner (top left)
              if (resto.banner != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA5),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      resto.banner!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              // Heart top right
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isFav) {
                        _favourited.remove(index);
                      } else {
                        _favourited.add(index);
                      }
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Info row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resto.name,
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                resto.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Subtitle
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              resto.subtitle,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFEBEDF0)),
      ],
    );
  }

  // ═══════════════════ PAGINATION DOTS ════════════════════════════
  Widget _buildPaginationDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          if (i == 0) {
            // Active pill
            return Container(
              width: 20,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }
          // Inactive circle
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ COME BACK LATER ═══════════════════════════
  Widget _buildComeBackLater() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Revenez plus tard pour de nouvelles offres',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, height: 1.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'En attendant, d\u00E9couvrez ces options savoureuses \u00E0 prix quotidiens',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════ BOTTOM NAV ════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Accueil', false),
              _navItem(Icons.search, 'Chercher', false),
              _navItem(Icons.shopping_bag_outlined, '\u00C9picerie', false),
              _navItem(Icons.shopping_cart, 'Paniers', false),
              _navItem(Icons.person, 'Compte', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Data model
// ═══════════════════════════════════════════════════════════════════

class _OfferResto {
  final String emoji;
  final String name;
  final double rating;
  final String subtitle;
  final String? banner;
  final List<Color> gradientColors;

  const _OfferResto({
    required this.emoji,
    required this.name,
    required this.rating,
    required this.subtitle,
    this.banner,
    required this.gradientColors,
  });
}
