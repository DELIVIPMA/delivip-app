import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ALL CATEGORIES SCREEN — DeliVip Toutes les catégories
// ═══════════════════════════════════════════════════════════════════

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  static const List<_CategoryItem> _categories = [
    _CategoryItem(emoji: '🏪', name: 'Dépannage'),
    _CategoryItem(emoji: '🍷', name: 'Alcool'),
    _CategoryItem(emoji: '🐾', name: 'Animaux'),
    _CategoryItem(emoji: '💐', name: 'Fleurs'),
    _CategoryItem(emoji: '🛒', name: 'Épicerie'),
    _CategoryItem(emoji: '🌭', name: 'Américain'),
    _CategoryItem(emoji: '⭐', name: 'Spécialités'),
    _CategoryItem(emoji: '📦', name: 'À emporter'),
    _CategoryItem(emoji: '🍜', name: 'Asiatique'),
    _CategoryItem(emoji: '🍦', name: 'Glaces'),
    _CategoryItem(emoji: '🥩', name: 'Halal'),
    _CategoryItem(emoji: '🛍️', name: 'Retail'),
    _CategoryItem(emoji: '🌴', name: 'Caribéen'),
    _CategoryItem(emoji: '🍛', name: 'Indien'),
    _CategoryItem(emoji: '🥐', name: 'Français'),
    _CategoryItem(emoji: '🍟', name: 'Fast Food'),
    _CategoryItem(emoji: '🍔', name: 'Burger'),
    _CategoryItem(emoji: '🚗', name: 'Courses'),
    _CategoryItem(emoji: '🥟', name: 'Chinois'),
    _CategoryItem(emoji: '🍰', name: 'Desserts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ═══ Title ═════════════════════════════════════════
            Text(
              'Toutes les catégories',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // ═══ Categories Grid ═══════════════════════════════
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: _categories.map((cat) {
                    return _CategoryCell(category: cat);
                  }).toList(),
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
//  Category Cell Widget
// ═══════════════════════════════════════════════════════════════════

class _CategoryCell extends StatelessWidget {
  final _CategoryItem category;

  const _CategoryCell({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Square container with emoji
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: Text(
                category.emoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Category name below
        Text(
          category.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Category Item Data Model
// ═══════════════════════════════════════════════════════════════════

class _CategoryItem {
  final String emoji;
  final String name;

  const _CategoryItem({required this.emoji, required this.name});
}
