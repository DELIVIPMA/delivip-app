import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  DINE IN SCREEN — DeliVip Sur place
// ═══════════════════════════════════════════════════════════════════

class DineInScreen extends StatefulWidget {
  const DineInScreen({super.key});

  @override
  State<DineInScreen> createState() => _DineInScreenState();
}

class _DineInScreenState extends State<DineInScreen> {
  int _selectedMode = 2; // 0=Livraison, 1=Retrait, 2=Sur place

  final List<_Resto> _fullRestos = [
    _Resto('\u{1F957}', 'Burgs Restaurant', 4.3, [
      const Color(0xFFFF6B35),
      const Color(0xFFE65100),
    ]),
    _Resto('\u{1F37D}\uFE0F', 'Fresh Foods', 4.3, [
      const Color(0xFFD32F2F),
      const Color(0xFFB71C1C),
    ]),
    _Resto('\u{1F355}', 'Rolls & Slice', 4.3, [
      const Color(0xFF388E3C),
      const Color(0xFF1B5E20),
    ]),
    _Resto('\u{1F9C1}', 'Pâtisserie Agadir', 4.3, [
      const Color(0xFF7B1FA2),
      const Color(0xFF4A148C),
    ]),
    _Resto('\u{1F958}', 'Reez Restaurant', 4.3, [
      const Color(0xFF5D4037),
      const Color(0xFF3E2723),
    ]),
    _Resto('\u{1F959}', 'Ann\u2019s Délices', 4.3, [
      const Color(0xFF1976D2),
      const Color(0xFF0D47A1),
    ]),
    _Resto('\u{1F32D}', 'Vida Cera', 4.3, [
      const Color(0xFFFBC02D),
      const Color(0xFFF57F17),
    ]),
    _Resto('\u{1F371}', 'Caledon Rounds', 4.3, [
      const Color(0xFF00897B),
      const Color(0xFF004D40),
    ]),
  ];

  final List<_MiniResto> _popularRestos = [
    _MiniResto('\u{1F964}', 'Pop-pop', 4.1, '5.00 DH Livraison \u2022 10-25 min', const Color(0xFFFFF3E0)),
    _MiniResto('\u{1F3E0}', 'Haven Café', 4.2, '5.00 DH Livraison \u2022 15-25 min', const Color(0xFFE8F5E9)),
    _MiniResto('\u{1F966}', 'Brucellos', 4.3, '5.00 DH Livraison \u2022 10-25 min', const Color(0xFFFCE4EC)),
    _MiniResto('\u{1F354}', 'Fries & Burger', 4.3, '5.00 DH Livraison \u2022 15-25 min', const Color(0xFFFFF8E1)),
    _MiniResto('\u{1F357}', 'Africanna Inn', 4.3, '5.00 DH Livraison \u2022 10-25 min', const Color(0xFFE3F2FD)),
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
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Full width restaurant cards
                    ..._fullRestos.map((r) => _buildFullCard(r)),
                    // 2. Popular section
                    _buildPopularSection(),
                    // 3. More full cards
                    ..._popularRestos.skip(2).map((r) => _buildFullCardFromMini(r)),
                    // 4. Buttons
                    _buildActionButtons(),
                    // 5. Disclaimer
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

  // ═══════════════════ FULL RESTAURANT CARD ══════════════════════
  Widget _buildFullCard(_Resto resto) {
    return Column(
      children: [
        // Image area
        Container(
          height: 180,
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
                child: Text(resto.emoji, style: const TextStyle(fontSize: 70)),
              ),
              // Heart icon top right
              Positioned(
                top: 12,
                right: 12,
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
                  child: const Center(
                    child: Icon(Icons.favorite_border, size: 16, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Info row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resto.name,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                resto.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════ POPULAR SECTION ═══════════════════════════
  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Populaires près de vous',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'voir tout',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF00BFA5)),
                    ),
                    const Icon(Icons.chevron_right, size: 16, color: Color(0xFF00BFA5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: _popularRestos.take(2).map((r) => _buildMiniCard(r)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard(_MiniResto resto) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 110,
              color: resto.bgColor,
              child: Center(
                child: Text(resto.emoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        resto.name,
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      resto.rating.toStringAsFixed(1),
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  resto.subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ MINI TO FULL CONVERTER ════════════════════
  Widget _buildFullCardFromMini(_MiniResto resto) {
    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          color: resto.bgColor,
          child: Stack(
            children: [
              Center(
                child: Text(resto.emoji, style: const TextStyle(fontSize: 70)),
              ),
              Positioned(
                top: 12,
                right: 12,
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
                  child: const Center(
                    child: Icon(Icons.favorite_border, size: 16, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resto.name,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                resto.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
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
                  'DeliVip est rémunéré par les restaurants pour le marketing et les promotions, '
                  'ce qui influence les recommandations personnalisées affichées. ',
            ),
            TextSpan(
              text: 'En savoir plus ou modifier les paramètres',
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
              _navItem(Icons.shopping_bag_outlined, 'Épicerie', false),
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
//  Data models
// ═══════════════════════════════════════════════════════════════════

class _Resto {
  final String emoji;
  final String name;
  final double rating;
  final List<Color> gradientColors;

  const _Resto(this.emoji, this.name, this.rating, this.gradientColors);
}

class _MiniResto {
  final String emoji;
  final String name;
  final double rating;
  final String subtitle;
  final Color bgColor;

  const _MiniResto(this.emoji, this.name, this.rating, this.subtitle, this.bgColor);
}
