import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../widgets/responsive_helper.dart';
import '../app_theme.dart';

// -------------------------------------------------------------------
// CategoryType Enum – Add new categories here
// -------------------------------------------------------------------
enum CategoryType { restaurant, boutique, supermarket }

// -------------------------------------------------------------------
// Generic Hero Card Item – works for any category
// -------------------------------------------------------------------
class HeroCardItem {
  final String name;
  final String rating;
  final String subtitle;
  final String description;
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
// DynamicListingPage – Reusable, Premium Glassmorphism listing page
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

class _DynamicListingPageState extends State<DynamicListingPage>
    with SingleTickerProviderStateMixin {
  static const _teal = Color(0xFF39BCA8);

  late final AnimationController _staggerCtrl;
  late final List<Animation<double>> _fadeAnims = [];
  late final List<Animation<double>> _slideAnims = [];
  List<HeroCardItem> _items = [];

  // -------------------------------------------------------------------
  // Dummy data
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
  void initState() {
    super.initState();
    _initItems();
    _initStaggerAnim();
  }

  void _initItems() {
    switch (widget.categoryType) {
      case CategoryType.restaurant:
        _items = _restaurants;
      case CategoryType.boutique:
        _items = _boutiques;
      case CategoryType.supermarket:
        _items = _supermarkets;
    }
  }

  void _initStaggerAnim() {
    final count = _items.length;
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 + count * 120),
    );
    for (int i = 0; i < count; i++) {
      final start = i * 0.12;
      final end = (start + 0.3).clamp(0.0, 1.0);
      _fadeAnims.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _staggerCtrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
      _slideAnims.add(
        Tween<double>(begin: 40.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _staggerCtrl,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }
    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ResponsiveHelper.constrainWidth(
            context,
            SizedBox(
              width: double.infinity,
              child: CustomScrollView(
                slivers: [
                  _buildHeroHeader(context),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horPad),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = _items[index];
                        return AnimatedBuilder(
                          animation: _staggerCtrl,
                          builder: (context, _) {
                            return Opacity(
                              opacity: _fadeAnims[index].value,
                              child: Transform.translate(
                                offset: Offset(0, _slideAnims[index].value),
                                child: _HeroGlassCard(
                                  item: item,
                                  categoryType: widget.categoryType,
                                  onTap: widget.onStoreTap != null
                                      ? () => widget.onStoreTap!(item)
                                      : null,
                                ),
                              ),
                            );
                          },
                        );
                      }, childCount: _items.length),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================================================================
  //  Hero Header
  // ===================================================================
  Widget _buildHeroHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GlassContainer(
          width: 42,
          height: 42,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(21),
          opacity: 0.25,
          tintColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1E1E24),
              size: 22,
            ),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                final rootNav = Navigator.of(context, rootNavigator: true);
                if (rootNav.canPop()) {
                  rootNav.pop();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 24),
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
                color: _teal,
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
}

// =====================================================================
//  Hero Glass Card – Premium listing card (no white flash)
// =====================================================================
class _HeroGlassCard extends StatelessWidget {
  final HeroCardItem item;
  final CategoryType categoryType;
  final VoidCallback? onTap;

  const _HeroGlassCard({
    required this.item,
    required this.categoryType,
    this.onTap,
  });

  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: _teal.withValues(alpha: 0.08),
            highlightColor: _teal.withValues(alpha: 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Hero image ----
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: _teal.withValues(alpha: 0.08),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: _teal.withValues(alpha: 0.04),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _teal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Badge on image
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _teal.withValues(alpha: 0.85),
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
                                color: Colors.white,
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
                // ---- Info row ----
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
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
                                color: Color(0xFF1E1E24),
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
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(
                                      0xFF1E1E24,
                                    ).withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '\u2022 ${item.description}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: const Color(
                                        0xFF1E1E24,
                                      ).withValues(alpha: 0.45),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
