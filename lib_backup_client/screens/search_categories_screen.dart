import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  SEARCH CATEGORIES SCREEN — DeliVip Recherche & Catégories
// ═══════════════════════════════════════════════════════════════════

class SearchCategoriesScreen extends StatelessWidget {
  const SearchCategoriesScreen({super.key});

  static const Color _teal = Color(0xFF00BFA5);

  // ═════════════════════════════════════════════════════════════════
  //  Data: Meilleures catégories
  // ═════════════════════════════════════════════════════════════════
  static const List<_CategoryItem> _topCategories = [
    _CategoryItem(
      emoji: '\u{1F373}',
      name: 'Petit-d\u00E9jeuner & Brunch',
      bg: Color(0xFF1A1A1A),
    ),
    _CategoryItem(
      emoji: '\u2615',
      name: 'Caf\u00E9 & Th\u00E9',
      bg: Color(0xFF8B0000),
    ),
    _CategoryItem(
      emoji: '\u{1F48E}',
      name: 'Offres',
      bgStart: Color(0xFF00BFA5),
      bgEnd: Color(0xFF009688),
      isGradient: true,
    ),
    _CategoryItem(
      emoji: '\u2B50',
      name: 'R\u00E9compenses',
      bg: Color(0xFF2E7D32),
    ),
    _CategoryItem(
      emoji: '\u{1F3C6}',
      name: 'Meilleur rapport qualit\u00E9',
      bg: Color(0xFFFFF8E1),
    ),
    _CategoryItem(
      emoji: '\u2708\uFE0F',
      name: 'Livraison gratuite',
      bg: Color(0xFFFFFDE7),
    ),
  ];

  // ═════════════════════════════════════════════════════════════════
  //  Data: Toutes les catégories
  // ═════════════════════════════════════════════════════════════════
  static const List<_CategoryItem> _allCategories = [
    _CategoryItem(emoji: '\u{1F32E}', name: 'Mexicain', bg: Color(0xFFFF8F00)),
    _CategoryItem(emoji: '\u{1F35F}', name: 'Fast Food', bg: Color(0xFFD32F2F)),
    _CategoryItem(emoji: '\u{1F957}', name: 'Healthy', bg: Color(0xFF388E3C)),
    _CategoryItem(emoji: '\u{1F355}', name: 'Pizza', bg: Color(0xFFF57C00)),
    _CategoryItem(emoji: '\u{1F35C}', name: 'Asiatique', bg: Color(0xFF4E342E)),
    _CategoryItem(
      emoji: '\u{1F950}',
      name: 'Boulangerie',
      bg: Color(0xFFF9A825),
    ),
    _CategoryItem(emoji: '\u{1F96A}', name: 'Sandwich', bg: Color(0xFF00796B)),
    _CategoryItem(emoji: '\u{1F363}', name: 'Sushi', bg: Color(0xFFC62828)),
    _CategoryItem(
      emoji: '\u{1F356}',
      name: 'Cor\u00E9en',
      bg: Color(0xFF212121),
    ),
    _CategoryItem(
      emoji: '\u{1F372}',
      name: 'Vietnamien',
      bg: Color(0xFFE53935),
    ),
    _CategoryItem(emoji: '\u{1F331}', name: 'Vegan', bg: Color(0xFF66BB6A)),
    _CategoryItem(
      emoji: '\u{1F9CB}',
      name: 'Bubble Tea',
      bg: Color(0xFF7B1FA2),
    ),
    _CategoryItem(
      emoji: '\u{1F964}',
      name: 'Jus & Smoothies',
      bgStart: Color(0xFFFF6F00),
      bgEnd: Color(0xFFFF8F00),
      isGradient: true,
    ),
    _CategoryItem(emoji: '\u{1F354}', name: 'Burgers', bg: Color(0xFF5D4037)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar (sticky top) ─────────────────────────
            _buildSearchBar(),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    // Section: Meilleures catégories
                    _buildSectionTitle('Meilleures cat\u00E9gories'),
                    _buildTopCategoriesGrid(),
                    // Section: Toutes les catégories
                    _buildSectionTitle(
                      'Toutes les cat\u00E9gories',
                      topMargin: 20,
                    ),
                    _buildAllCategoriesGrid(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // ── Bottom Nav Bar ──────────────────────────────────
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ SEARCH BAR ════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Nourriture, shopping, boissons, etc',
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFFAAAAAA),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          ),
          style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }

  // ═══════════════════ SECTION TITLE ═════════════════════════════
  Widget _buildSectionTitle(String title, {double topMargin = 8}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topMargin, 16, 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // ═══════════════════ TOP CATEGORIES GRID ═══════════════════════
  Widget _buildTopCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: _topCategories.length,
        itemBuilder: (context, index) =>
            _buildCategoryCard(_topCategories[index], shadow: true),
      ),
    );
  }

  // ═══════════════════ ALL CATEGORIES GRID ═══════════════════════
  Widget _buildAllCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: _allCategories.length,
        itemBuilder: (context, index) => _buildCategoryCard(
          _allCategories[index],
          shadow: false,
          border: true,
        ),
      ),
    );
  }

  // ═══════════════════ CATEGORY CARD ═════════════════════════════
  Widget _buildCategoryCard(
    _CategoryItem item, {
    bool shadow = false,
    bool border = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: border
            ? Border.all(color: const Color(0xFFF0F0F0), width: 1)
            : null,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Image area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: item.isGradient
                    ? LinearGradient(
                        colors: [item.bgStart!, item.bgEnd!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [item.bg, item.bg],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 50)),
              ),
            ),
          ),
          // Label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.white,
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ BOTTOM NAV ════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEBEDF0), width: 1)),
        color: Colors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, 'Accueil', false),
              _navItem(Icons.search, 'Chercher', true),
              _navItem(Icons.shopping_cart_outlined, '\u00C9picerie', false),
              _navItem(Icons.receipt_long_outlined, 'Paniers', false),
              _navItem(Icons.person_outline, 'Compte', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: active ? Colors.black : Colors.grey),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Supporting model
// ═══════════════════════════════════════════════════════════════════

class _CategoryItem {
  final String emoji;
  final String name;
  final Color bg;
  final Color? bgStart;
  final Color? bgEnd;
  final bool isGradient;

  const _CategoryItem({
    required this.emoji,
    required this.name,
    this.bg = Colors.transparent,
    this.bgStart,
    this.bgEnd,
    this.isGradient = false,
  });
}
