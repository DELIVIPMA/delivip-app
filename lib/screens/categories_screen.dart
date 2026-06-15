import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_categories_screen.dart';

// ═══════════════════════════════════════════════════════════════════
//  CATEGORIES SCREEN — DeliVip Épicerie / Catégories
// ═══════════════════════════════════════════════════════════════════

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<_Category> _categories = [
    _Category(emoji: '🍌', name: 'Fruits & légumes'),
    _Category(emoji: '🥤', name: 'Boissons'),
    _Category(emoji: '🧊', name: 'Surgelés'),
    _Category(emoji: '🛒', name: 'Épicerie & Garde-manger'),
    _Category(emoji: '🍿', name: 'Snacks'),
    _Category(emoji: '🥩', name: 'Viandes, Poissons & Végétal'),
    _Category(emoji: '🧀', name: 'Fromages'),
    _Category(emoji: '🍞', name: 'Pain & Viennoiseries'),
    _Category(emoji: '🥛', name: 'Lait & Produits laitiers'),
    _Category(emoji: '🥫', name: 'Conserves'),
    _Category(emoji: '🏠', name: 'Maison & Entretien'),
    _Category(emoji: '🥣', name: 'Petit-déjeuner'),
    _Category(emoji: '🍫', name: 'Sucreries & Chocolats'),
    _Category(emoji: '🫙', name: 'Yaourts'),
    _Category(emoji: '🍱', name: 'Plats préparés'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ═══ Custom AppBar ══════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Back arrow + store name
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SuperMarché Agadir',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // Person icon
                  const Icon(
                    Icons.person_outline,
                    size: 24,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 16),
                  // Cart icon
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 24,
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            // ═══ Search Bar ════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Rechercher produits...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ═══ Info Row ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time info
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'En 60 minutes',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Price info
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Prix et frais',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ═══ Custom Tab Bar ════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // "À la une" tab (inactive)
                  _TabChip(label: 'À la une', isActive: false),
                  const SizedBox(width: 8),
                  // "Catégories" tab (active)
                  _TabChip(label: 'Catégories', isActive: true),
                  const SizedBox(width: 8),
                  // "Commandes" tab (inactive)
                  _TabChip(label: 'Commandes', isActive: false),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ═══ Divider below tabs ════════════════════════════
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

            // ═══ Categories List + "Toutes les catégories" ═════
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _categories.length + 1,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFF0F1F3),
                ),
                itemBuilder: (context, index) {
                  if (index < _categories.length) {
                    final cat = _categories[index];
                    return _CategoryRow(category: cat);
                  } else {
                    // Last item: "Toutes les catégories" link
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllCategoriesScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text('📂', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Toutes les catégories',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00BFA5),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Tab Chip Widget
// ═══════════════════════════════════════════════════════════════════

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Category Row Widget
// ═══════════════════════════════════════════════════════════════════

class _CategoryRow extends StatelessWidget {
  final _Category category;

  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Square image placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Category name
          Expanded(
            child: Text(
              category.name,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Right chevron
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Category Data Model
// ═══════════════════════════════════════════════════════════════════

class _Category {
  final String emoji;
  final String name;

  const _Category({required this.emoji, required this.name});
}
