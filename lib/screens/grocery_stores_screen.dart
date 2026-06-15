import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  GROCERY STORES SCREEN — DeliVip Magasins d'épicerie
// ═══════════════════════════════════════════════════════════════════

class GroceryStoresScreen extends StatelessWidget {
  const GroceryStoresScreen({super.key});

  static const _stores = [
    _Store('Marjane', '\u{1F3EA}', 'https://picsum.photos/seed/marjane/400/200', Color(0xFFC8102E), 'En 60 minutes', false),
    _Store('Carrefour', '\u{1F6D2}', 'https://picsum.photos/seed/carrefour/400/200', Color(0xFF2E7D32), 'En 60 minutes', false),
    _Store("Label'Vie", '\u{1F3EC}', 'https://picsum.photos/seed/labelvie/400/200', Color(0xFFF9A825), 'En 60 minutes', false),
    _Store('BIM Maroc', '\u{1F6CD}\uFE0F', 'https://picsum.photos/seed/bim/400/200', Color(0xFFB71C1C), 'En 60 minutes', false),
    _Store('Atacadão', '\u{1F4E6}', 'https://picsum.photos/seed/atacadao/400/200', Color(0xFFE53935), 'En 60 minutes', false),
    _Store('Souk Express', '\u{1F966}', 'https://picsum.photos/seed/soukexpress/400/200', Color(0xFFD32F2F), 'Actuellement indisponible', true),
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
            // ── Search Bar ──────────────────────────────────────
            _buildSearchBar(),
            // ── Location Row ────────────────────────────────────
            _buildLocationRow(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Stores Grid ─────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0,
                  physics: const BouncingScrollPhysics(),
                  children: _stores.map((store) => _buildStoreCard(store)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Text(
            'Magasins',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 22, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher magasins et produits...',
            hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildLocationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.location_on_outlined, size: 20, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agadir Marina',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Ma liste DeliVip',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStoreCard(_Store store) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image (like Glovo)
            Image.network(
              store.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: store.color),
            ),
            // Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            // Dimmed overlay if unavailable
            if (store.isUnavailable)
              Container(color: Colors.black.withValues(alpha: 0.45)),
            // Store content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(store.emoji, style: const TextStyle(fontSize: 40, shadows: [
                    Shadow(color: Colors.black38, blurRadius: 8),
                  ])),
                  const SizedBox(height: 8),
                  Text(
                    store.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom badge
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  store.badge,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Store data model
// ═══════════════════════════════════════════════════════════════════
class _Store {
  final String name;
  final String emoji;
  final String imageUrl;
  final Color color;
  final String badge;
  final bool isUnavailable;

  const _Store(this.name, this.emoji, this.imageUrl, this.color, this.badge, this.isUnavailable);
}
