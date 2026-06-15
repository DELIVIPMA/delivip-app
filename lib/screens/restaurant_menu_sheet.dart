import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  RESTAURANT MENU SHEET — DeliVip Menu complet du restaurant
// ═══════════════════════════════════════════════════════════════════

class RestaurantMenuSheet extends StatefulWidget {
  const RestaurantMenuSheet({super.key});

  @override
  State<RestaurantMenuSheet> createState() => _RestaurantMenuSheetState();
}

class _RestaurantMenuSheetState extends State<RestaurantMenuSheet> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();
  int _activeCategory = 0;

  final List<String> _categories = [
    'Les plus pop.',
    'S\u00E9lectionn\u00E9s',
    'Entr\u00E9es',
    'Salades',
    'Pizzas sp\u00E9c.',
    'Divers',
    'Boissons',
  ];

  // Global keys for each section to compute offsets
  final Map<int, GlobalKey> _sectionKeys = {
    for (int i = 0; i < 7; i++) i: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset + 160; // offset for tabs + app bar
    for (int i = 0; i < _categories.length; i++) {
      final key = _sectionKeys[i]!.currentContext;
      if (key != null) {
        final box = key.findRenderObject() as RenderBox?;
        if (box != null) {
          final pos = box.localToGlobal(Offset.zero);
          // Check if this section is visible at top of viewport
          final sectionTop = pos.dy - kToolbarHeight - 120;
          if (offset >= sectionTop - 20) {
            if (_activeCategory != i) {
              setState(() => _activeCategory = i);
              _scrollTabToVisible(i);
            }
          }
        }
      }
    }
  }

  void _scrollTabToVisible(int index) {
    if (_tabScrollController.hasClients) {
      final offset = index * 80.0;
      final maxScroll = _tabScrollController.position.maxScrollExtent;
      _tabScrollController.animateTo(
        offset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _onCategoryTap(int index) {
    setState(() => _activeCategory = index);
    final key = _sectionKeys[index]!.currentContext;
    if (key != null) {
      Scrollable.ensureVisible(
        key,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.08,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Category Tabs (sticky) ──────────────────────────
            _buildCategoryTabs(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Scrollable Menu Body ────────────────────────────
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Popular section
                  _buildSliverSectionHeader('Les plus populaires', 0),
                  _buildImageItemSliver(
                    '\u{1F355}',
                    const Color(0xFFFFF3E0),
                    'Pizza Champignons',
                    '65.00 DH',
                    'Base ail, mozzarella, champignons cremini, ricotta, thym, huile de truffe. Ajouter roquette en suppl\u00E9ment',
                  ),
                  _buildImageItemSliver(
                    '\u{1F336}',
                    const Color(0xFFFFEBEE),
                    'Pizza Piquante',
                    '60.00 DH',
                    'Pepperoni, mozzarella, marinara \u00E9pic\u00E9e, huile d\u2019olive infus\u00E9e au piment',
                  ),
                  _buildImageItemSliver(
                    '\u{1F9C0}',
                    const Color(0xFFFFFDE7),
                    'Pizza Margherita',
                    '55.00 DH',
                    'Perles de mozzarella, marinara, parmesan r\u00E2p\u00E9, basilic frais, huile d\u2019olive extra vierge',
                  ),
                  _buildImageItemSliver(
                    '\u{1F355}',
                    const Color(0xFFE8F5E9),
                    'Pizza Ronde 45cm',
                    '85.00 DH',
                    'Commence comme un d\u00E9licieux fromage. Jusqu\u2019\u00E0 4 garnitures suppl\u00E9mentaires',
                    promo: true,
                  ),

                  // Selected for you
                  _buildSliverSectionHeader('S\u00E9lectionn\u00E9s pour vous', 1),
                  _buildTextItemSliver('Pizza Anniversaire', '80.00 DH',
                      desc: 'Pepperoni, marinara, mozzarella, ail et huile d\u2019olive extra'),
                  _buildTextItemSliver('Salade C\u00E9sar Vegan', '55.00 DH',
                      desc: 'Petits l\u00E9gumes, vinaigrette vegan, cro\u00FBtons, levure nutritionnelle, c\u00E2pres'),
                  _buildTextItemSliver('Salade Roquette', '35.00 DH',
                      desc: 'Roquette, fenouil, vinaigre et huile d\u2019olive, pecorino et amandes'),
                  _buildTextItemSliver(
                    'Eau Min\u00E9rale',
                    '15.00 DH',
                    desc: 'Doit avoir 18 ans',
                    strikethroughPrice: '20.00 DH',
                  ),

                  // Entrées
                  _buildSliverSectionHeader('Entr\u00E9es', 2),
                  _buildImageItemSliver(
                    '\u{1F9C4}',
                    const Color(0xFFFFF8E1),
                    'Pains \u00E0 l\'Ail',
                    'Prix selon options',
                    null,
                    badge: 'Populaire',
                    badgeBlack: true,
                  ),

                  // Salades
                  _buildSliverSectionHeader('Salades', 3),
                  _buildTextItemSliver('Salade C\u00E9sar Vegan', '55.00 DH', badge: 'Populaire', badgeBlack: true),
                  _buildTextItemSliver('Salade Roquette', '35.00 DH'),

                  // Nos Pizzas Spéciales
                  _buildSliverSectionHeader('Nos Pizzas Sp\u00E9ciales', 4),
                  _buildImageItemSliver('\u{1F355}', const Color(0xFFFFF3E0), 'Pizza Champignons', '65.00 DH', null),
                  _buildImageItemSliver('\u{1F336}', const Color(0xFFFFEBEE), 'Pizza Piquante', '60.00 DH', null),
                  _buildImageItemSliver('\u{1F9C0}', const Color(0xFFFFFDE7), 'Pizza Margherita', '55.00 DH', null),
                  _buildImageItemSliver('\u{1F382}', const Color(0xFFF3E5F5), 'Pizza Anniversaire', '80.00 DH', null,
                      badge: 'Populaire', badgeBlack: true),

                  // Divers
                  _buildSliverSectionHeader('Divers', 5),
                  _buildTextItemSliver('Pains \u00E0 l\'Ail', '4.50 DH', badge: 'Populaire', badgeBlack: true),
                  _buildTextItemSliver('Marinara', '3.00 DH', badge: 'Populaire', badgeBlack: true),
                  _buildTextItemSliver('Gla\u00E7age Balsamique', '4.50 DH'),

                  // Boissons
                  _buildSliverSectionHeader('Boissons (18+ requis)', 6),
                  _buildTextItemSliver('Bouteille Eau Min\u00E9rale', '20.00 DH', desc: 'Doit avoir 18 ans'),

                  // Bottom spacing for sticky bar
                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              ),
            ),
            // ── Sticky Promo Bar ────────────────────────────────
            _buildStickyPromoBar(),
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
          Expanded(
            child: Text(
              'Pizza Roma Agadir (Ag\u2026',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, size: 22, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ CATEGORY TABS ═════════════════════════════
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, size: 20, color: Colors.black.withOpacity(0.6)),
          ),
          // Scrollable chips
          Expanded(
            child: ListView.builder(
              controller: _tabScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.only(right: 16),
              itemBuilder: (context, index) {
                final isActive = _activeCategory == index;
                return GestureDetector(
                  onTap: () => _onCategoryTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _categories[index],
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            color: isActive ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isActive)
                          Container(height: 2, width: 24, color: Colors.black),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SLIVER SECTION HEADER ═════════════════════
  Widget _buildSliverSectionHeader(String title, int sectionIndex) {
    return SliverToBoxAdapter(
      key: _sectionKeys[sectionIndex],
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
  Widget _buildImageItemSliver(
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
  Widget _buildTextItemSliver(
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
