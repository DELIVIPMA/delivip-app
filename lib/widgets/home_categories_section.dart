import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════
//  HomeCategoriesSection — Uber Eats Style Horizontal
//  Small flat circular icons with black text underneath
// ═══════════════════════════════════════════════════════

class _HomeCategory {
  final String label;
  final IconData icon;
  const _HomeCategory({required this.label, required this.icon});
}

final _categories = [
  _HomeCategory(label: 'Pizzas', icon: Icons.local_pizza_rounded),
  _HomeCategory(label: 'Burgers', icon: Icons.lunch_dining_rounded),
  _HomeCategory(label: 'Sushis', icon: Icons.set_meal_rounded),
  _HomeCategory(label: 'Tacos', icon: Icons.takeout_dining_rounded),
  _HomeCategory(label: 'Desserts', icon: Icons.cake_rounded),
  _HomeCategory(label: 'Boissons', icon: Icons.local_cafe_rounded),
  _HomeCategory(label: 'Salades', icon: Icons.eco_rounded),
  _HomeCategory(label: 'Poulet', icon: Icons.restaurant_rounded),
];

class HomeCategoriesSection extends StatelessWidget {
  final void Function(String category)? onTap;
  const HomeCategoriesSection({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          return GestureDetector(
            onTap: () => onTap?.call(cat.label),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small rounded square icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: Icon(cat.icon, size: 26, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
