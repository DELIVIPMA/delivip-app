import 'package:flutter/material.dart';

// -------------------------------------------------------------------
// CategoryType Enum – Add new categories here
// -------------------------------------------------------------------
enum CategoryType { restaurant, boutique, supermarket }

// -------------------------------------------------------------------
// Color Constants – Uber Eats inspired
// -------------------------------------------------------------------
const Color _accentTeal = Color(0xFF0E6B56);
const Color _textPrimary = Color(0xFF1A1A1A);
const Color _textSecondary = Color(0xFF8E8E93);
const Color _textTertiary = Color(0xFF6B6B6B);
const Color _bgLight = Color(0xFFF6F6F6);
const Color _dividerColor = Color(0xFFE5E5EA);

// -------------------------------------------------------------------
// Generic Hero Card Item – works for any category
// -------------------------------------------------------------------
class HeroCardItem {
  final String name;
  final String rating;
  final String subtitle; // e.g. delivery time or category label
  final String description; // e.g. "Tacos • Chicken • Moroccan"
  final String imageUrl;

  const HeroCardItem({
    required this.name,
    required this.rating,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
  });
}

// -------------------------------------------------------------------
// DynamicListingPage – Reusable, Uber Eats inspired listing page
// -------------------------------------------------------------------
class DynamicListingPage extends StatefulWidget {
  final String categoryName;
  final CategoryType categoryType;
  final String heroImageUrl;
  final VoidCallback? onBack;
  final void Function(HeroCardItem item)? onStoreTap;

  const DynamicListingPage({
    super.key,
    required this.categoryName,
    required this.categoryType,
    required this.heroImageUrl,
    this.onBack,
    this.onStoreTap,
  });

  @override
  State<DynamicListingPage> createState() => _DynamicListingPageState();
}

class _DynamicListingPageState extends State<DynamicListingPage> {
  // -------------------------------------------------------------------
  // Dummy data – Restaurants
  // -------------------------------------------------------------------
  static const List<HeroCardItem> _restaurants = [
    HeroCardItem(
      name: 'First Tacos Agadir',
      rating: '4.8',
      subtitle: '20-30 min',
      description: 'Tacos \u2022 Chicken \u2022 Moroccan',
      imageUrl:
          'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=600',
    ),
    HeroCardItem(
      name: 'KFC',
      rating: '4.5',
      subtitle: '15-25 min',
      description: 'Chicken \u2022 Burgers \u2022 Fries',
      imageUrl:
          'https://images.unsplash.com/photo-1562967914-608f82629710?w=600',
    ),
    HeroCardItem(
      name: 'Burger Station',
      rating: '4.7',
      subtitle: '20-40 min',
      description: 'Burgers \u2022 Steak \u2022 Fries',
      imageUrl:
          'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600',
    ),
    HeroCardItem(
      name: 'Pizza Roma Agadir',
      rating: '4.6',
      subtitle: '25-35 min',
      description: 'Pizza \u2022 Pasta \u2022 Italian',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600',
    ),
    HeroCardItem(
      name: 'Chez Ali Mama',
      rating: '4.9',
      subtitle: '30-45 min',
      description: 'Tagine \u2022 Couscous \u2022 Moroccan',
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600',
    ),
    HeroCardItem(
      name: 'Sushi Palace',
      rating: '4.4',
      subtitle: '20-30 min',
      description: 'Sushi \u2022 Ramen \u2022 Asian',
      imageUrl:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600',
    ),
  ];

  // -------------------------------------------------------------------
  // Dummy data – Boutiques
  // -------------------------------------------------------------------
  static const List<HeroCardItem> _boutiques = [
    HeroCardItem(
      name: 'Zara Agadir',
      rating: '4.6',
      subtitle: 'Fashion',
      description: 'Women \u2022 Men \u2022 Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=600',
    ),
    HeroCardItem(
      name: 'JD Sports',
      rating: '4.5',
      subtitle: 'Sportswear',
      description: 'Sneakers \u2022 Streetwear \u2022 Sport',
      imageUrl:
          'https://images.unsplash.com/photo-1556906781-9a4126f8e5f4?w=600',
    ),
    HeroCardItem(
      name: 'Marwa Fashion',
      rating: '4.8',
      subtitle: 'Traditional',
      description: 'Moroccan Caftans \u2022 Handmade',
      imageUrl:
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600',
    ),
    HeroCardItem(
      name: 'Electro Plus',
      rating: '4.3',
      subtitle: 'Electronics',
      description: 'Phones \u2022 Gadgets \u2022 Repairs',
      imageUrl:
          'https://images.unsplash.com/photo-1468495244123-6c6c332eeece?w=600',
    ),
    HeroCardItem(
      name: 'Maktaba Al Oumma',
      rating: '4.7',
      subtitle: 'Books',
      description: 'Stationery \u2022 Gifts \u2022 Islamic',
      imageUrl:
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=600',
    ),
    HeroCardItem(
      name: 'Bijouterie Lalla',
      rating: '4.9',
      subtitle: 'Jewelry',
      description: 'Silver \u2022 Gold \u2022 Handicrafts',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141589-77d0f1f1b4e1?w=600',
    ),
  ];

  // -------------------------------------------------------------------
  // Dummy data – Supermarkets (now same card style!)
  // -------------------------------------------------------------------
  static const List<HeroCardItem> _supermarkets = [
    HeroCardItem(
      name: 'Carrefour Market',
      rating: '4.5',
      subtitle: 'Hypermarket',
      description: 'Groceries \u2022 Fresh \u2022 Household',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600',
    ),
    HeroCardItem(
      name: 'Mini Market Al Amal',
      rating: '4.7',
      subtitle: 'Convenience Store',
      description: 'Dairy \u2022 Drinks \u2022 Snacks',
      imageUrl:
          'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=600',
    ),
    HeroCardItem(
      name: 'BIM',
      rating: '4.2',
      subtitle: 'Discount Store',
      description: 'Groceries \u2022 Household \u2022 Best Price',
      imageUrl:
          'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=600',
    ),
    HeroCardItem(
      name: 'Superette Assalam',
      rating: '4.8',
      subtitle: 'Local Market',
      description: 'Fresh Produce \u2022 Couscous \u2022 Spices',
      imageUrl:
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600',
    ),
    HeroCardItem(
      name: 'Epicerie du Coin',
      rating: '4.6',
      subtitle: 'Corner Store',
      description: 'Oil \u2022 Rice \u2022 Daily Essentials',
      imageUrl:
          'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=600',
    ),
    HeroCardItem(
      name: 'Marjane Market',
      rating: '4.4',
      subtitle: 'Supermarket Chain',
      description: 'Food \u2022 Electronics \u2022 Clothing',
      imageUrl:
          'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=600',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: CustomScrollView(
        slivers: [
          _buildHeroHeader(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(delegate: SliverChildListDelegate(_buildBody())),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  // ===================================================================
  //  Hero Header - Uber Eats style SliverAppBar
  // ===================================================================
  Widget _buildHeroHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.black87,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.heroImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: _accentTeal,
                child: const Center(
                  child: Icon(Icons.image, size: 48, color: Colors.white38),
                ),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 140,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================================
  //  Dynamic Body – Add new categories here
  // ===================================================================
  List<Widget> _buildBody() {
    List<HeroCardItem> items;

    switch (widget.categoryType) {
      case CategoryType.restaurant:
        items = _restaurants;
      case CategoryType.boutique:
        items = _boutiques;
      case CategoryType.supermarket:
        items = _supermarkets;
    }

    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      widgets.add(
        _HeroCard(
          item: items[i],
          categoryType: widget.categoryType,
          onTap: widget.onStoreTap != null
              ? () => widget.onStoreTap!(items[i])
              : null,
        ),
      );
      if (i < items.length - 1) {
        widgets.add(const Divider(color: _dividerColor, height: 1, indent: 0));
      }
    }
    return widgets;
  }
}

// =====================================================================
//  Hero Card – Reusable Uber Eats style card for any category
// =====================================================================
class _HeroCard extends StatelessWidget {
  final HeroCardItem item;
  final CategoryType categoryType;
  final VoidCallback? onTap;

  const _HeroCard({required this.item, required this.categoryType, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Hero image ----
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _accentTeal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Badge on image (delivery time or category)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryType == CategoryType.restaurant
                                  ? Icons.access_time_rounded
                                  : Icons.star,
                              size: 14,
                              color: categoryType == CategoryType.restaurant
                                  ? Colors.white
                                  : const Color(0xFFFFC107),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ---- Info row ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textTertiary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '\u2022 ${item.description}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: _textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
