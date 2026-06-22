import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/store_model.dart';
import '../widgets/three_d_icon.dart';
import '../widgets/store_card.dart';
import '../screens/address_picker_screen.dart';
import 'category_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<StoreModel> _popularStores = MockData.popularStores;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildPromoBanner(),
              _buildCategoriesSection(),
              _buildPopularSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Icon(AppIcons.location, color: AppTheme.primary, size: 20),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressPickerScreen()),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Agadir, Souss',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  AppIcons.arrowDown,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
          const Spacer(),
          Icon(AppIcons.notifications, color: AppTheme.textPrimary, size: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Search DeliVIP...',
            prefixIcon: Icon(
              AppIcons.search,
              color: AppTheme.textSecondary,
              size: 22,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: AppTheme.cardBg,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Free delivery\nthis weekend',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Orders over 80 MAD',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ThreeDIcon(
              icon: AppIcons.truck,
              size: 70,
              backgroundColor: AppTheme.accent.withValues(alpha: 0.2),
              iconColor: AppTheme.accent,
              borderRadius: 16,
              padding: const EdgeInsets.all(14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {
        'icon': AppIcons.restaurants,
        'name': 'Restaurants',
        'subtitle': '50+ places',
        'category': 'restaurants',
        'bgColor': const Color(0xFFFFF3E0),
        'iconColor': const Color(0xFFFF7043),
      },
      {
        'icon': AppIcons.boutiques,
        'name': 'Boutiques',
        'subtitle': '30+ shops',
        'category': 'boutiques',
        'bgColor': const Color(0xFFFCE4EC),
        'iconColor': const Color(0xFFEC407A),
      },
      {
        'icon': AppIcons.supermarkets,
        'name': 'Supermarkets',
        'subtitle': '15+ stores',
        'category': 'supermarkets',
        'bgColor': const Color(0xFFE0F2F1),
        'iconColor': const Color(0xFF26A69A),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Browse categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: categories.map((cat) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, _, _) => CategoryListPage(
                        category: cat['category'] as String,
                        emoji: cat['name'] as String,
                        title: cat['name'] as String,
                      ),
                      transitionsBuilder: (_, anim, _, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: const Duration(milliseconds: 280),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ThreeDIcon(
                          icon: cat['icon'] as IconData,
                          size: 56,
                          backgroundColor: cat['bgColor'] as Color,
                          iconColor: cat['iconColor'] as Color,
                          borderRadius: 14,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['name'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular near you',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_popularStores.length, (index) {
            final store = _popularStores[index];
            return StoreCard(
              store: store,
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, _, _) => CategoryListPage(
                    category: store.category,
                    emoji: store.emoji,
                    title: store.name,
                  ),
                  transitionsBuilder: (_, anim, _, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 280),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
