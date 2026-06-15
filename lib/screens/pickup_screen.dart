import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  PICKUP SCREEN — DeliVip Retrait
// ═══════════════════════════════════════════════════════════════════

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  int _selectedMode = 1; // 0=Livraison, 1=Retrait, 2=Sur place
  final Set<int> _favourited = {1}; // index 1 (Round Eatery) is favourited

  final List<_PickupResto> _restos = [
    _PickupResto('\u{1F366}', 'Ice Cream Bar', 4.1, '30-35 min \u2022 0.5 km', [
      const Color(0xFFF48FB1), const Color(0xFFC2185B),
    ]),
    _PickupResto('\u{1F957}', 'Round Eatery', 4.5, '30-40 min \u2022 0.5 km', [
      const Color(0xFF81C784), const Color(0xFF2E7D32),
    ]),
    _PickupResto('\u{1F30D}', 'African Flavour', 4.1, '30-35 min \u2022 0.5 km', [
      const Color(0xFFFFCC80), const Color(0xFFE65100),
    ]),
    _PickupResto('\u{1F37D}\uFE0F', 'Foodilistica', 4.4, '30-35 min \u2022 0.5 km', [
      const Color(0xFFEF9A9A), const Color(0xFFC62828),
    ]),
    _PickupResto('\u{1F451}', 'Almafi VIP', 4.1, '30-35 min \u2022 0.5 km', [
      const Color(0xFFCE93D8), const Color(0xFF6A1B9A),
    ]),
    _PickupResto('\u{1F969}', 'Steaky Treats', 4.2, '30-35 min \u2022 0.5 km', [
      const Color(0xFFBCAAA4), const Color(0xFF4E342E),
    ]),
    _PickupResto('\u{2615}', 'Mon Caf\u00E9 Carlo', 4.3, '30-35 min \u2022 0.5 km', [
      const Color(0xFFBDBDBD), const Color(0xFF424242),
    ]),
    _PickupResto('\u{1FAD5}', 'Casa Della Saucy', 4.0, '30-39 min \u2022 0.5 km', [
      const Color(0xFF66BB6A), const Color(0xFF1B5E20),
    ]),
    _PickupResto('\u{1F373}', 'Breakfast & Breakfast', 4.0, '30-35 min \u2022 0.5 km', [
      const Color(0xFFFFF176), const Color(0xFFF57F17),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Mode Tabs ───────────────────────────────────────
            _buildModeTabs(),
            // ── Sub-header ──────────────────────────────────────
            _buildSubHeader(),
            // ── Map ─────────────────────────────────────────────
            _buildMap(),
            // ── Search row ──────────────────────────────────────
            _buildSearchRow(),
            // ── Category chips ──────────────────────────────────
            _buildCategoryChips(),
            // ── Scrollable body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ..._restos.asMap().entries.map((entry) => _buildRestoCard(entry.key, entry.value)),
                    _buildActionButtons(),
                    _buildDisclaimer(),
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

  // ═══════════════════ MODE TABS ═════════════════════════════════
  Widget _buildModeTabs() {
    final labels = ['Livraison', 'Retrait', 'Sur place'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(labels.length, (index) {
          final isActive = _selectedMode == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedMode = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labels[index],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ SUB-HEADER ════════════════════════════════
  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Maintenant \u2022 Agadir Marina',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.tune, size: 20, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ MAP ═══════════════════════════════════════
  Widget _buildMap() {
    return Container(
      height: 200,
      width: double.infinity,
      color: const Color(0xFFE8F0E9),
      child: Stack(
        children: [
          // Street grid lines
          ...List.generate(6, (i) {
            return Positioned(
              left: 0,
              right: 0,
              top: 20.0 + i * 32,
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            );
          }),
          ...List.generate(6, (i) {
            return Positioned(
              top: 0,
              bottom: 0,
              left: 30.0 + i * 60,
              child: Container(
                width: 1,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            );
          }),
          // Restaurant pins (fork icons)
          Positioned(
            top: 30,
            left: 50,
            child: const Text('\u{1F37D}\uFE0F', style: TextStyle(fontSize: 20)),
          ),
          Positioned(
            top: 80,
            left: 160,
            child: const Text('\u{1F37D}\uFE0F', style: TextStyle(fontSize: 20)),
          ),
          Positioned(
            top: 120,
            left: 260,
            child: const Text('\u{1F37D}\uFE0F', style: TextStyle(fontSize: 20)),
          ),
          Positioned(
            top: 50,
            left: 300,
            child: const Text('\u{1F37D}\uFE0F', style: TextStyle(fontSize: 20)),
          ),
          Positioned(
            top: 140,
            left: 80,
            child: const Text('\u{1F37D}\uFE0F', style: TextStyle(fontSize: 20)),
          ),
          // Center user location pin
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Icon(Icons.location_on, size: 32, color: Color(0xFF4285F4)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    'Centre Agadir',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SEARCH ROW ════════════════════════════════
  Widget _buildSearchRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Qu'est-ce qui vous fait envie ?",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.tune, size: 20, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ CATEGORY CHIPS ════════════════════════════
  Widget _buildCategoryChips() {
    final chips = [
      {'emoji': '\u{1F35F}', 'label': 'Fast Food'},
      {'emoji': '\u{1F334}', 'label': 'Carib\u00E9en'},
      {'emoji': '\u{1F971}', 'label': 'Chinois'},
      {'emoji': '\u{1F950}', 'label': 'Fran\u00E7ais'},
    ];

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: chips.map((chip) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(chip['emoji']!, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chip['label']!,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════ RESTAURANT CARD ═══════════════════════════
  Widget _buildRestoCard(int index, _PickupResto resto) {
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
      ],
    );
  }

  // ═══════════════════ ACTION BUTTONS ════════════════════════════
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text(
                'CHERCHER OU PARCOURIR',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {},
            child: Text(
              'VOIR TOUS LES RESTAURANTS',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DISCLAIMER ════════════════════════════════
  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey,
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text:
                  'DeliVip est r\u00E9mun\u00E9r\u00E9 par les restaurants pour le marketing et les promotions, '
                  'ce qui influence les recommandations personnalis\u00E9es. ',
            ),
            TextSpan(
              text: 'En savoir plus ou modifier les param\u00E8tres',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF00BFA5),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
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
              _navItem(Icons.home, 'Accueil', true),
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
              color: isActive ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.black : Colors.grey,
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

class _PickupResto {
  final String emoji;
  final String name;
  final double rating;
  final String subtitle;
  final List<Color> gradientColors;

  const _PickupResto(this.emoji, this.name, this.rating, this.subtitle, this.gradientColors);
}
