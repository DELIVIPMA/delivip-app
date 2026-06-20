import 'package:flutter/material.dart';
import 'dynamic_listing_page.dart';

class CategoryListPage extends StatelessWidget {
  final String category;
  final VoidCallback? onBack;
  final void Function(HeroCardItem item)? onStoreTap;
  const CategoryListPage({
    super.key,
    required this.category,
    this.onBack,
    this.onStoreTap,
  });

  CategoryType _mapCategoryType() {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return CategoryType.restaurant;
      case 'boutiques':
        return CategoryType.boutique;
      case 'supermarkets':
      case 'stores':
        return CategoryType.supermarket;
      default:
        return CategoryType.restaurant;
    }
  }

  String _heroImageForCategory() {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200';
      case 'supermarkets':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200';
      case 'boutiques':
        return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1200';
      default:
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicListingPage(
      categoryName: category,
      categoryType: _mapCategoryType(),
      heroImageUrl: _heroImageForCategory(),
      onBack: onBack,
      onStoreTap: onStoreTap,
    );
  }
}
