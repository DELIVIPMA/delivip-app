import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  STORE SCREEN — DeliVip Épicerie / Store
// ═══════════════════════════════════════════════════════════════════

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedTab = 0; // 0 = À la une
  int _cartCount = 0;

  final Set<String> _cartItems = {};

  // ═════════════════════════════════════════════════════════════════
  //  Product data — sections
  // ═════════════════════════════════════════════════════════════════
  static const List<ProductSection> _sections = [
    ProductSection(
      name: 'Fruits & L\u00E9gumes',
      items: [
        Product(emoji: '\u{1F34C}', name: 'Banane Bio', price: '2.70 DH', unit: '1 banane'),
        Product(emoji: '\u{1F951}', name: 'Avocat Hass Moyen', price: '5.50 DH', unit: '1 avocat'),
        Product(emoji: '\u{1F345}', name: 'Grande Tomate', price: '2.60 DH', unit: '1 tomate'),
        Product(emoji: '\u{1F34A}', name: 'Orange', price: '3.50 DH', unit: '1 kg'),
      ],
    ),
    ProductSection(
      name: 'Boissons',
      items: [
        Product(emoji: '\u{1F964}', name: 'Coca-Cola Zero', price: '24.75 DH', unit: '12 x 33cl'),
        Product(emoji: '\u{1F34A}', name: 'Jus d\u2019Orange Pulpe', price: '13.50 DH', unit: '1.5L'),
        Product(emoji: '\u{1F4A7}', name: 'Eau Min\u00E9rale', price: '10.75 DH', unit: '6 x 1.5L'),
        Product(emoji: '\u{1F9CB}', name: 'Jus Multifruits', price: '11.00 DH', unit: '1L'),
      ],
    ),
    ProductSection(
      name: 'Surgel\u00E9s',
      items: [
        Product(emoji: '\u{1F357}', name: 'Nuggets de Poulet', price: '26.00 DH', unit: '500g'),
        Product(emoji: '\u{1F95E}', name: 'Pancakes \u00C9rable', price: '19.25 DH', unit: '350g'),
        Product(emoji: '\u{1F355}', name: 'Pizza Surgel\u00E9e', price: '21.00 DH', unit: '400g'),
        Product(emoji: '\u{1F32E}', name: 'Wraps Surgel\u00E9s', price: '13.50 DH', unit: '300g'),
      ],
    ),
    ProductSection(
      name: '\u00C9picerie & Garde-manger',
      items: [
        Product(emoji: '\u{1FAD6}', name: 'Th\u00E9 Chai Curcuma', price: '13.50 DH', unit: '16 sachets'),
        Product(emoji: '\u{1F36B}', name: 'Chocolat Sans Sucre', price: '13.50 DH', unit: '200g'),
        Product(emoji: '\u{1F95B}', name: 'Lait Demi-\u00E9cr\u00E9m\u00E9', price: '6.75 DH', unit: '1L'),
        Product(emoji: '\u{1FAD9}', name: 'Confiture Fraise', price: '15.00 DH', unit: '370g'),
      ],
    ),
    ProductSection(
      name: 'Snacks',
      items: [
        Product(emoji: '\u{1F33D}', name: 'Chips Nacho Fromage', price: '15.25 DH', unit: '250g'),
        Product(emoji: '\u{1F33E}', name: 'Crackers Tomate', price: '13.50 DH', unit: '200g'),
        Product(emoji: '\u{1F95C}', name: 'Mix de Noix', price: '22.00 DH', unit: '300g'),
        Product(emoji: '\u{1F37F}', name: 'Popcorn Caramel', price: '11.00 DH', unit: '150g'),
      ],
    ),
    ProductSection(
      name: 'Viandes, Poissons & V\u00E9g\u00E9tal',
      items: [
        Product(emoji: '\u{1F357}', name: 'Blanc de Poulet', price: '28.50 DH', unit: '500g env.'),
        Product(emoji: '\u{1F356}', name: 'Dinde R\u00F4tie', price: '19.25 DH', unit: '300g'),
        Product(emoji: '\u{1F41F}', name: 'Saumon Fum\u00E9', price: '17.50 DH', unit: '150g'),
        Product(emoji: '\u{1F331}', name: 'Steak V\u00E9g\u00E9tal', price: '18.00 DH', unit: '200g'),
      ],
    ),
    ProductSection(
      name: 'Fromages',
      items: [
        Product(emoji: '\u{1F9C0}', name: 'Fromage Vegan', price: '13.50 DH', unit: '200g'),
        Product(emoji: '\u{1F9C0}', name: 'Brie \u00E0 l\u2019Ail', price: '19.25 DH', unit: 'env. 250g'),
        Product(emoji: '\u{1F9C0}', name: 'Cheddar Affin\u00E9', price: '13.50 DH', unit: '200g'),
        Product(emoji: '\u{1F9C0}', name: 'Mozzarella', price: '12.00 DH', unit: '125g'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Cover Image Header (like Glovo) ────────────────
            _buildCoverHeader(context),
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Search Bar ──────────────────────────────────────
            _buildSearchBar(),
            // ── Info Row ────────────────────────────────────────
            _buildInfoRow(),
            // ── Tab Bar ─────────────────────────────────────────
            _buildTabBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Promo banner
                    _buildPromoBanner(),
                    // Product sections
                    ..._sections.map((section) => _buildProductSection(section)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ COVER HEADER ══════════════════════════════
  Widget _buildCoverHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFC8102E),
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/seed/marjane-express/800/300'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Dark gradient overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          // Store logo + name at bottom
          Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('\u{1F3EA}', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Marjane Express',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                      ),
                    ),
                    Text(
                      'Hypermarché • 2.7km',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
              'Marjane Express',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 22, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.black),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 6,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA5),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SEARCH BAR ════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.search, size: 20, color: Colors.grey),
            ),
            Text(
              'Rechercher produits...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ INFO ROW ══════════════════════════════════
  Widget _buildInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'En 60 minutes',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.info_outline, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'Prix et frais',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ TAB BAR ═══════════════════════════════════
  Widget _buildTabBar() {
    final tabs = ['\u00C0 la une', 'Cat\u00E9gories', 'Commandes'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ PROMO BANNER ══════════════════════════════
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF009688)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '0 DH de frais de livraison\nsur les produits s\u00E9lectionn\u00E9s',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════ PRODUCT SECTION ═══════════════════════════
  Widget _buildProductSection(ProductSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section.name,
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'voir tout \u203A',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF00BFA5)),
              ),
            ],
          ),
        ),
        // Horizontal product scroll
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: section.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = section.items[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════ PRODUCT CARD ═══════════════════════════════
  Widget _buildProductCard(Product product) {
    final productKey = '${product.name}_${product.price}';
    final inCart = _cartItems.contains(productKey);

    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area with + button
          Stack(
            children: [
              Container(
                width: 130,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(product.emoji, style: const TextStyle(fontSize: 40)),
                ),
              ),
              // Add button
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (inCart) {
                        _cartItems.remove(productKey);
                        _cartCount = _cartItems.length;
                      } else {
                        _cartItems.add(productKey);
                        _cartCount = _cartItems.length;
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: inCart ? const Color(0xFF00BFA5) : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      inCart ? Icons.check : Icons.add,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Name
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          // Price
          Text(
            product.price,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          // Unit/weight
          Text(
            product.unit,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Supporting models
// ═══════════════════════════════════════════════════════════════════

class ProductSection {
  final String name;
  final List<Product> items;

  const ProductSection({required this.name, required this.items});
}

class Product {
  final String emoji;
  final String name;
  final String price;
  final String unit;

  const Product({
    required this.emoji,
    required this.name,
    required this.price,
    required this.unit,
  });
}
