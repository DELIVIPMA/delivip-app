import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  CONVENIENCE SCREEN — DeliVip Dépannage / Magasins
// ═══════════════════════════════════════════════════════════════════

class ConvenienceScreen extends StatefulWidget {
  const ConvenienceScreen({super.key});

  @override
  State<ConvenienceScreen> createState() => _ConvenienceScreenState();
}

class _ConvenienceScreenState extends State<ConvenienceScreen> {
  // Track favorite state by store index
  final Set<int> _favoriteIds = {};

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteIds.contains(index)) {
        _favoriteIds.remove(index);
      } else {
        _favoriteIds.add(index);
      }
    });
  }

  static const List<_FeaturedStore> _featuredStores = [
    _FeaturedStore(emoji: '🏪', name: 'Marjane Express', opens: 'Ouvre à 10:00'),
    _FeaturedStore(emoji: '🛒', name: 'Carrefour City', opens: 'Ouvre à 10:00'),
    _FeaturedStore(emoji: '🏬', name: "Label'Vie", opens: 'Ouvre à 09:00'),
  ];

  static const List<_ConvenienceStore> _regularStores = [
    _ConvenienceStore(emoji: '🥪', name: 'Hanout Express', opens: 'Ouvre à 08:00', promo: 'Dépensez 200 DH, économisez 50 DH'),
    _ConvenienceStore(emoji: '🧃', name: 'Épicerie du Coin', opens: 'Ouvre à 08:00'),
    _ConvenienceStore(emoji: '🛍️', name: 'Mini Market Amine', opens: 'Ouvre à 08:00'),
    _ConvenienceStore(emoji: '🍺', name: 'Boissons & Co', opens: 'Ouvre à 08:00', promo: 'Dépensez 200 DH, économisez 50 DH'),
    _ConvenienceStore(emoji: '🥦', name: 'Marché Bio', opens: 'Ouvre à 08:00'),
    _ConvenienceStore(emoji: '🍬', name: 'Snack & Save', opens: 'Ouvre à 08:00'),
    _ConvenienceStore(emoji: '🧺', name: 'Provisions Plus', opens: 'Ouvre à 08:00', promo: 'Dépensez 200 DH, économisez 50 DH'),
    _ConvenienceStore(emoji: '☕', name: 'Café & Petit Dej', opens: 'Ouvre à 07:00'),
    _ConvenienceStore(emoji: '🥗', name: 'Fresh Corner', opens: 'Ouvre à 08:00'),
    _ConvenienceStore(emoji: '🍷', name: 'Cave Agadir', opens: 'Ouvre à 09:00', promo: 'Dépensez 200 DH, économisez 50 DH'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ═══ Top Section: Back arrow + Title ════════════════
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),

                  // Title "Dépannage"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Dépannage',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section title "Magasins à la une"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Magasins à la une',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ═══ Featured Stores Horizontal Scroll ═══════
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _featuredStores.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final store = _featuredStores[index];
                        return _FeaturedStoreCard(store: store);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // ═══ Regular Stores List ════════════════════════════
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final store = _regularStores[index];
                  final isFav = _favoriteIds.contains(index);
                  return _ConvenienceStoreRow(
                    store: store,
                    isFavorited: isFav,
                    onToggleFavorite: () => _toggleFavorite(index),
                  );
                },
                childCount: _regularStores.length,
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Featured Store Card Widget
// ═══════════════════════════════════════════════════════════════════

class _FeaturedStoreCard extends StatelessWidget {
  final _FeaturedStore store;

  const _FeaturedStoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 120,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(store.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 6),
            Text(
              store.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              store.opens,
              style: GoogleFonts.inter(
                fontSize: 12,
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
//  Convenience Store Row Widget
// ═══════════════════════════════════════════════════════════════════

class _ConvenienceStoreRow extends StatelessWidget {
  final _ConvenienceStore store;
  final bool isFavorited;
  final VoidCallback onToggleFavorite;

  const _ConvenienceStoreRow({
    required this.store,
    required this.isFavorited,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular emoji image
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(store.emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),

          // Middle column: name, opens, promo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  store.opens,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                if (store.promo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    store.promo!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00BFA5),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Heart icon
          GestureDetector(
            onTap: onToggleFavorite,
            child: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: isFavorited ? const Color(0xFF00BFA5) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Data Models
// ═══════════════════════════════════════════════════════════════════

class _FeaturedStore {
  final String emoji;
  final String name;
  final String opens;

  const _FeaturedStore({
    required this.emoji,
    required this.name,
    required this.opens,
  });
}

class _ConvenienceStore {
  final String emoji;
  final String name;
  final String opens;
  final String? promo;

  const _ConvenienceStore({
    required this.emoji,
    required this.name,
    required this.opens,
    this.promo,
  });
}
