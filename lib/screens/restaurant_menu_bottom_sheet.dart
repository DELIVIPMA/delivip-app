import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  RESTAURANT MENU BOTTOM SHEET — DeliVip Bottom sheet menu
//  Use with DraggableScrollableSheet:
//    showModalBottomSheet(
//      context: context,
//      isScrollControlled: true,
//      backgroundColor: Colors.white,
//      shape: const RoundedRectangleBorder(
//        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//      ),
//      builder: (_) => DraggableScrollableSheet(
//        initialChildSize: 0.6,
//        minChildSize: 0.4,
//        maxChildSize: 1.0,
//        expand: false,
//        builder: (_, controller) =>
//            RestaurantMenuBottomSheet(scrollController: controller),
//      ),
//    );
// ═══════════════════════════════════════════════════════════════════

class RestaurantMenuBottomSheet extends StatefulWidget {
  final ScrollController? scrollController;

  const RestaurantMenuBottomSheet({super.key, this.scrollController});

  @override
  State<RestaurantMenuBottomSheet> createState() => _RestaurantMenuBottomSheetState();
}

class _RestaurantMenuBottomSheetState extends State<RestaurantMenuBottomSheet> {
  int _selectedTab = 0; // 0 = Livraison, 1 = Retrait

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Drag Handle ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // ── Scrollable Content ────────────────────────────────
          Expanded(
            child: CustomScrollView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Restaurant info
                SliverToBoxAdapter(child: _buildRestaurantHeader()),
                // Delivery/Pickup tabs
                SliverToBoxAdapter(child: _buildDeliveryTabs()),
                const SliverToBoxAdapter(
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                ),
                // Popular section
                _buildSliverSectionHeader('Les plus populaires'),
                _buildImageItem(
                  '\u{1F355}',
                  const Color(0xFFFFF3E0),
                  'Pizza Champignons',
                  '65.00 DH',
                  'Base ail, mozzarella, champignons cremini, ricotta, thym, huile de truffe. Ajouter roquette en suppl\u00E9ment',
                ),
                _buildImageItem(
                  '\u{1F336}',
                  const Color(0xFFFFEBEE),
                  'Pizza Piquante',
                  '60.00 DH',
                  'Pepperoni, mozzarella, marinara \u00E9pic\u00E9e, huile d\u2019olive infus\u00E9e au piment',
                ),
                _buildImageItem(
                  '\u{1F9C0}',
                  const Color(0xFFFFFDE7),
                  'Pizza Margherita',
                  '55.00 DH',
                  'Perles de mozzarella, marinara, parmesan r\u00E2p\u00E9, basilic frais, huile d\u2019olive extra vierge',
                ),
                _buildImageItem(
                  '\u{1F355}',
                  const Color(0xFFE8F5E9),
                  'Pizza Ronde 45cm',
                  '85.00 DH',
                  'Commence comme un d\u00E9licieux fromage. Jusqu\u2019\u00E0 4 garnitures suppl\u00E9mentaires',
                  promo: true,
                ),

                // Selected for you
                _buildSliverSectionHeader('S\u00E9lectionn\u00E9s pour vous'),
                _buildTextItem('Pizza Anniversaire', '80.00 DH',
                    desc: 'Pepperoni, marinara, mozzarella, ail et huile d\u2019olive extra'),
                _buildTextItem('Salade C\u00E9sar Vegan', '55.00 DH',
                    desc: 'Petits l\u00E9gumes, vinaigrette vegan, cro\u00FBtons, levure nutritionnelle, c\u00E2pres'),
                _buildTextItem('Salade Roquette', '35.00 DH',
                    desc: 'Roquette, fenouil, vinaigre et huile d\u2019olive, pecorino et amandes'),
                _buildTextItem('Eau Min\u00E9rale', '15.00 DH',
                    desc: 'Doit avoir 18 ans', strikethroughPrice: '20.00 DH'),

                // Entrées
                _buildSliverSectionHeader('Entr\u00E9es'),
                _buildImageItem(
                  '\u{1F9C4}',
                  const Color(0xFFFFF8E1),
                  'Pains \u00E0 l\'Ail',
                  'Prix selon options',
                  null,
                  badge: 'Populaire',
                  badgeBlack: true,
                ),

                // Salades
                _buildSliverSectionHeader('Salades'),
                _buildTextItem('Salade C\u00E9sar Vegan', '55.00 DH', badge: 'Populaire', badgeBlack: true),
                _buildTextItem('Salade Roquette', '35.00 DH'),

                // Nos Pizzas Spéciales
                _buildSliverSectionHeader('Nos Pizzas Sp\u00E9ciales'),
                _buildImageItem('\u{1F355}', const Color(0xFFFFF3E0), 'Pizza Champignons', '65.00 DH', null),
                _buildImageItem('\u{1F336}', const Color(0xFFFFEBEE), 'Pizza Piquante', '60.00 DH', null),
                _buildImageItem('\u{1F9C0}', const Color(0xFFFFFDE7), 'Pizza Margherita', '55.00 DH', null),
                _buildImageItem('\u{1F382}', const Color(0xFFF3E5F5), 'Pizza Anniversaire', '80.00 DH', null,
                    badge: 'Populaire', badgeBlack: true),

                // Divers
                _buildSliverSectionHeader('Divers'),
                _buildTextItem('Pains \u00E0 l\'Ail', '4.50 DH', badge: 'Populaire', badgeBlack: true),
                _buildTextItem('Marinara', '3.00 DH', badge: 'Populaire', badgeBlack: true),
                _buildTextItem('Gla\u00E7age Balsamique', '4.50 DH'),

                // Boissons
                _buildSliverSectionHeader('Boissons (18+ requis)'),
                _buildTextItem('Bouteille Eau Min\u00E9rale', '20.00 DH', desc: 'Doit avoir 18 ans'),

                // Bottom spacing for promo bar
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
          // ── Sticky Promo Bar ──────────────────────────────────
          _buildStickyPromoBar(),
        ],
      ),
    );
  }

  // ═══════════════════ RESTAURANT HEADER ═════════════════════════
  Widget _buildRestaurantHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
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
          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
          const SizedBox(height: 12),
          // Commander maintenant row
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
                  'Commander maintenant',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ═══════════════════ DELIVERY/PICKUP TABS ══════════════════════
  Widget _buildDeliveryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
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
    );
  }

  // ═══════════════════ SLIVER SECTION HEADER ═════════════════════
  Widget _buildSliverSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  // ═══════════════════ IMAGE ITEM SLIVER ═════════════════════════
  Widget _buildImageItem(
    String emoji,
    Color bgColor,
    String name,
    String price,
    String? desc, {
    bool promo = false,
    String? badge,
    bool badgeBlack = false,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
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
                                name,
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                            if (promo)
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
                            if (badge != null && !promo)
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
                        if (desc != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            desc,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, height: 1.4),
                          ),
                        ],
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
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 36))),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TEXT ITEM SLIVER ══════════════════════════
  Widget _buildTextItem(
    String name,
    String price, {
    String? desc,
    String? badge,
    bool badgeBlack = false,
    String? strikethroughPrice,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
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
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
                        Row(
                          children: [
                            Text(
                              price,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                            ),
                            if (strikethroughPrice != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                strikethroughPrice,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (desc != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            desc,
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
