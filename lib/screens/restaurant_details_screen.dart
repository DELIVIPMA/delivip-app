import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  RESTAURANT DETAILS SCREEN — DeliVip Détails restaurant
// ═══════════════════════════════════════════════════════════════════

class RestaurantDetailsScreen extends StatefulWidget {
  final int initialTab;

  const RestaurantDetailsScreen({super.key, this.initialTab = 0});

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late int _selectedTab; // 0 = Livraison, 1 = Retrait

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section
                    _buildHeroSection(context),
                    const SizedBox(height: 16),
                    // Restaurant info
                    _buildRestaurantInfo(),
                    const SizedBox(height: 12),
                    // Delivery/Pickup tabs
                    _buildDeliveryTabs(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Menu — Les plus populaires
                    _buildPopularSection(),
                    // Menu — Sélectionnés
                    _buildSelectedForYou(),
                    // Menu — Entrées
                    _buildSectionTitle('Entr\u00E9es'),
                    _buildTextItem('Pains \u00E0 l\'Ail', 'Prix selon options', badge: 'Populaire', badgeBlack: true),
                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFEBEDF0)),
                    // Menu — Salades
                    _buildSectionTitle('Salades'),
                    _buildTextItem('Salade C\u00E9sar Vegan', '55.00 DH', badge: 'Populaire', badgeBlack: true),
                    const SizedBox(height: 8),
                    _buildTextItem('Salade Roquette', '35.00 DH'),
                    const SizedBox(height: 16),
                    // Menu — Nos Pizzas Spéciales
                    _buildSectionTitle('Nos Pizzas Sp\u00E9ciales'),
                    _buildImageItem('Pizza Champignons', '65.00 DH', '\u{1F355}', const Color(0xFFFFF3E0)),
                    _buildImageItem('Pizza Piquante', '60.00 DH', '\u{1F336}', const Color(0xFFFFEBEE)),
                    _buildImageItem('Pizza Margherita', '55.00 DH', '\u{1F9C0}', const Color(0xFFFFFDE7)),
                    _buildImageItem('Pizza Anniversaire', '80.00 DH', '\u{1F382}', const Color(0xFFF3E5F5)),
                    // Menu — Divers
                    _buildSectionTitle('Divers'),
                    _buildTextItem('Pains \u00E0 l\'Ail', '4.50 DH', badge: 'Populaire', badgeBlack: true),
                    _buildTextItem('Marinara', '3.00 DH', badge: 'Populaire', badgeBlack: true),
                    _buildTextItem('Gla\u00E7age Balsamique', '4.50 DH'),
                    const SizedBox(height: 16),
                    // Menu — Boissons
                    _buildSectionTitle('Boissons (18+ requis)'),
                    _buildTextItem('Bouteille Eau Min\u00E9rale Pliny', '20.00 DH', subtitle: 'Doit avoir 18 ans pour acheter'),
                    const SizedBox(height: 80), // space for sticky bar
                  ],
                ),
              ),
            ),
            // ── Sticky bottom promo bar ─────────────────────────
            _buildStickyPromoBar(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ HERO SECTION ══════════════════════════════
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Fake map background
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0E9),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(),
            ),
          ),
          // Distance badge
          Positioned(
            right: 16,
            top: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '1.7 km',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          // Food emoji circles top right
          Positioned(
            right: 16,
            top: 100,
            child: Row(
              children: [
                _foodEmojiCircle('\u{1F355}'),
                const SizedBox(width: 4),
                _foodEmojiCircle('\u{1F354}'),
                const SizedBox(width: 4),
                _foodEmojiCircle('\u{1F957}'),
              ],
            ),
          ),
          // Map area label
          Positioned(
            left: 16,
            bottom: 12,
            child: Text(
              'Centre Agadir',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
            ),
          ),
          // Back arrow
          Positioned(
            left: 12,
            top: 8,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              ),
            ),
          ),
          // Heart
          Positioned(
            right: 16,
            top: 8,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border, size: 18, color: Colors.black),
            ),
          ),
          // More
          Positioned(
            right: 58,
            top: 8,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_horiz, size: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodEmojiCircle(String emoji) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  // ═══════════════════ RESTAURANT INFO ═══════════════════════════
  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pizza Roma Agadir',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            '\u2B50 4.6 (200+ avis) \u2022 Pizza \u2022 \u{1F4B0}\u{1F4B0}',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ouvert jusqu\u2019\u00E0 03:00',
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF00BFA5)),
                    ),
                    Text(
                      'Appuyez pour plus d\u2019infos',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          // Group order row
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.group, size: 20, color: Colors.black),
                const SizedBox(width: 10),
                Text(
                  'Commander en groupe',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DELIVERY/PICKUP TABS ══════════════════════
  Widget _buildDeliveryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Livraison tab
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Livraison',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_selectedTab == 0)
                      Container(height: 2, width: 30, color: Colors.black),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Retrait tab
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Retrait',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_selectedTab == 1)
                      Container(height: 2, width: 30, color: Colors.black),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _selectedTab == 0 ? '25\u201335 min \u2022 1.7 km' : '5\u201315 min \u2022 1.7 km',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════ POPULAR SECTION ═══════════════════════════
  Widget _buildPopularSection() {
    return _buildMenuSection(
      'Les plus populaires',
      [
        _MenuItem(
          name: 'Pizza Champignons',
          price: '65.00 DH',
          desc:
              'Base ail, mozzarella, champignons cremini, ricotta, thym, huile de truffe. Ajouter roquette en suppl\u00E9ment',
          emoji: '\u{1F355}',
          bgColor: const Color(0xFFFFF3E0),
        ),
        _MenuItem(
          name: 'Pizza Piquante',
          price: '60.00 DH',
          desc:
              'Pepperoni, mozzarella, marinara \u00E9pic\u00E9e, huile d\u2019olive infus\u00E9e au piment',
          emoji: '\u{1F336}',
          bgColor: const Color(0xFFFFEBEE),
        ),
        _MenuItem(
          name: 'Pizza Margherita',
          price: '55.00 DH',
          desc: 'Perles de mozzarella, marinara, parmesan r\u00E2p\u00E9, basilic frais, huile d\u2019olive extra vierge',
          emoji: '\u{1F9C0}',
          bgColor: const Color(0xFFFFFDE7),
        ),
        _MenuItem(
          name: 'Pizza Ronde 45cm',
          price: '85.00 DH',
          desc: 'Commence comme un d\u00E9licieux fromage. Jusqu\u2019\u00E0 4 garnitures suppl\u00E9mentaires',
          emoji: '\u{1F355}',
          bgColor: const Color(0xFFE8F5E9),
          promo: true,
        ),
      ],
    );
  }

  // ═══════════════════ SELECTED FOR YOU ══════════════════════════
  Widget _buildSelectedForYou() {
    return _buildMenuSection(
      'S\u00E9lectionn\u00E9s pour vous',
      [
        _MenuItem(
          name: 'Pizza Anniversaire',
          price: '80.00 DH',
          desc: 'Pepperoni, marinara, mozzarella, ail et huile d\u2019olive extra',
          emoji: null,
        ),
        _MenuItem(
          name: 'Salade C\u00E9sar Vegan',
          price: '55.00 DH',
          desc: 'Petits l\u00E9gumes, vinaigrette vegan maison, cro\u00FBtons, levure nutritionnelle, c\u00E2pres',
          emoji: null,
        ),
        _MenuItem(
          name: 'Salade Roquette',
          price: '35.00 DH',
          desc: 'Roquette, fenouil shav\u00E9, vinaigre et huile d\u2019olive, pecorino et amandes',
          emoji: null,
        ),
        _MenuItem(
          name: 'Bouteille Eau Min\u00E9rale',
          price: '15.00 DH',
          desc: 'Doit avoir 18 ans pour acheter',
          emoji: null,
          strikethroughPrice: '20.00 DH',
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        ...items.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  // ═══════════════════ MENU ITEM (with image) ════════════════════
  Widget _buildMenuItem(_MenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          if (item.promo == true)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Promo',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00BFA5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item.price,
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                          ),
                          if (item.strikethroughPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              item.strikethroughPrice!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (item.desc != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.desc!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.emoji != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: item.bgColor ?? Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(item.emoji!, style: const TextStyle(fontSize: 36)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
        ],
      ),
    );
  }

  // ═══════════════════ TEXT ONLY ITEM ════════════════════════════
  Widget _buildTextItem(String name, String price, {String? subtitle, String? badge, bool badgeBlack = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          if (badge != null)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBlack ? Colors.black : const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: badgeBlack ? Colors.white : const Color(0xFF00BFA5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
        ],
      ),
    );
  }

  // ═══════════════════ IMAGE ITEM (short) ════════════════════════
  Widget _buildImageItem(String name, String price, String emoji, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 36)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
        ],
      ),
    );
  }

  // ═══════════════════ SECTION TITLE ═════════════════════════════
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // ═══════════════════ STICKY PROMO BAR ══════════════════════════
  Widget _buildStickyPromoBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: const Color(0xFFE8F5E9),
      child: Center(
        child: Text(
          '\u00C9conomisez 25 DH. Conditions applicables.',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00BFA5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Supporting models
// ═══════════════════════════════════════════════════════════════════

class _MenuItem {
  final String name;
  final String price;
  final String? desc;
  final String? emoji;
  final Color? bgColor;
  final bool? promo;
  final String? strikethroughPrice;

  const _MenuItem({
    required this.name,
    required this.price,
    this.desc,
    this.emoji,
    this.bgColor,
    this.promo,
    this.strikethroughPrice,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  Grid painter for fake map background
// ═══════════════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.12)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
