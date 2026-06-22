import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_search_bar.dart';
import '../widgets/responsive_helper.dart';
import '../app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_CategoryItem> _categories = const [
    _CategoryItem(
      'Burgers',
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&h=200&fit=crop',
    ),
    _CategoryItem(
      'Pizza',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200&h=200&fit=crop',
    ),
    _CategoryItem(
      'Healthy',
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200&h=200&fit=crop',
    ),
    _CategoryItem(
      'Supermarket',
      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200&h=200&fit=crop',
    ),
    _CategoryItem(
      'Desserts',
      'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=200&h=200&fit=crop',
    ),
    _CategoryItem(
      'Moroccan',
      'https://images.unsplash.com/photo-1574484284002-952d92456975?w=200&h=200&fit=crop',
    ),
  ];

  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    final isTablet = ResponsiveHelper.isLargeScreen(context);
    final gridCols = ResponsiveHelper.gridColumnCount(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // ─── Glass search bar ─────────────────────
            PremiumSearchBar(controller: _searchController),
            const SizedBox(height: 28),
            // ─── Section title ────────────────────────
            Text(
              'Top Categories',
              style: AppTheme.heading.copyWith(
                fontSize: ResponsiveHelper.fontSize(context, 22),
                color: _dark,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: ResponsiveHelper.constrainWidth(
                  context,
                  SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCols,
                        crossAxisSpacing: isTablet ? 16 : 12,
                        mainAxisSpacing: isTablet ? 16 : 12,
                        childAspectRatio: ResponsiveHelper.gridAspectRatio(
                          context,
                        ),
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return _buildCategoryCard(cat.title, cat.imageUrl);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(18),
      opacity: 0.22,
      tintColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      onTap: () {},
      child: Stack(
        children: [
          // Image background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: _teal.withValues(alpha: 0.08));
                },
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
          // Title
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final String imageUrl;

  const _CategoryItem(this.title, this.imageUrl);
}
