import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/models.dart';
import '../data/address_provider.dart';
import '../app_theme.dart';
import 'restaurant_menu_screen.dart';
import 'search_screen.dart';
import 'add_new_address_screen.dart';
import 'notifications_screen.dart';
import '../pages/category_list_page.dart';
import '../widgets/home_categories_section.dart';
import '../widgets/responsive_helper.dart';

// ─── RESTAURANT LOOKUP ───────────────────────────────
final Map<String, Restaurant> _restaurantByName = {
  for (final r in sampleRestaurants) r.name: r,
};

// ═══════════════════════════════════════════════════════
//  HOME SCREEN – Uber Eats Light Mode
// ═══════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  final String? initialAddress;
  final void Function(Restaurant)? onOpenRestaurant;
  final void Function(String)? onOpenCategory;
  final VoidCallback? onOpenSearch;

  const HomeScreen({
    super.key,
    this.initialAddress,
    this.onOpenRestaurant,
    this.onOpenCategory,
    this.onOpenSearch,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openRestaurant(Restaurant r) {
    if (widget.onOpenRestaurant != null) {
      widget.onOpenRestaurant!(r);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RestaurantMenuScreen(restaurant: r)),
      );
    }
  }

  void _openCategory(String cat) {
    if (widget.onOpenCategory != null) {
      widget.onOpenCategory!(cat);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CategoryListPage(category: cat)),
      );
    }
  }

  void _openSearch() {
    if (widget.onOpenSearch != null) {
      widget.onOpenSearch!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPage()),
      );
    }
  }

  Widget _restaurantCard(Restaurant r) {
    return GestureDetector(
      onTap: () => _openRestaurant(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image - full bleed
            SizedBox(
              height: 160,
              width: double.infinity,
              child: r.imageUrl.isNotEmpty
                  ? Image.network(
                      r.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
            ),
            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFF39BCA8),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${r.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${r.reviewCount}+)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        r.time,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.delivery_dining_rounded,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        r.fee,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isLargeScreen(context);
    return SafeArea(
      child: Column(
        children: [
          _buildTopHeader(),
          const SizedBox(height: 8),
          _buildSearchBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ResponsiveHelper.constrainWidth(
                context,
                Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildCategoriesSection(),
                      const SizedBox(height: 12),
                      _buildSectionHeader('Popular near you'),
                      const SizedBox(height: 8),
                      _buildPopularHorizontal(),
                      const SizedBox(height: 16),
                      _buildSectionHeader('All restaurants'),
                      const SizedBox(height: 8),
                      _buildRestaurantsList(),
                      SizedBox(height: isTablet ? 32 : 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TOP HEADER ──────────────────────────────────
  Widget _buildTopHeader() {
    final isTablet = ResponsiveHelper.isLargeScreen(context);
    final horPad = ResponsiveHelper.horizontalPadding(context);

    return Consumer<AddressProvider>(
      builder: (context, addressProvider, _) {
        final address = addressProvider.currentAddress;
        final displayAddress = address?.streetName ?? 'Select Delivery Address';
        final hasAddress = address != null;

        IconData locationIcon;
        if (address?.addressType.toLowerCase() == 'maison') {
          locationIcon = Icons.home_rounded;
        } else if (address?.addressType.toLowerCase() == 'bureau') {
          locationIcon = Icons.work_rounded;
        } else {
          locationIcon = Icons.location_on_rounded;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horPad, vertical: 8),
          child: Row(
            children: [
              Icon(
                hasAddress ? locationIcon : Icons.location_on_rounded,
                color: AppTheme.primaryTeal,
                size: isTablet ? 22 : 18,
              ),
              SizedBox(width: isTablet ? 10 : 6),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddNewAddressScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deliver to',
                          style: GoogleFonts.poppins(
                            fontSize: ResponsiveHelper.fontSize(context, 10),
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              displayAddress,
                              style: GoogleFonts.poppins(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  13,
                                ),
                                fontWeight: FontWeight.w600,
                                color: hasAddress
                                    ? Colors.black
                                    : AppTheme.primaryTeal,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: hasAddress
                                  ? Colors.black
                                  : AppTheme.primaryTeal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                child: Badge(
                  isLabelVisible: true,
                  smallSize: 8,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.redAccent,
                  offset: const Offset(0, 2),
                  child: Container(
                    width: isTablet ? 42 : 36,
                    height: isTablet ? 42 : 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(isTablet ? 21 : 18),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: isTablet ? 22 : 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── SEARCH BAR ──────────────────────────────────
  Widget _buildSearchBar() {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horPad),
      child: GestureDetector(
        onTap: _openSearch,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 10),
              Text(
                'Search DeliVIP...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⌘K',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppTheme.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION HEADER ─────────────────────────────
  Widget _buildSectionHeader(String title) {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horPad),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Text(
              'See all',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CATEGORIES ─────────────────────────────────
  Widget _buildCategoriesSection() {
    return HomeCategoriesSection(onTap: (category) => _openCategory(category));
  }

  // ─── POPULAR HORIZONTAL ─────────────────────────
  Widget _buildPopularHorizontal() {
    final isTablet = ResponsiveHelper.isLargeScreen(context);
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return SizedBox(
      height: isTablet ? 200 : 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horPad),
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemCount: sampleRestaurants.length,
        itemBuilder: (context, index) {
          final r = sampleRestaurants[index];
          return _buildPopularCard(r);
        },
      ),
    );
  }

  Widget _buildPopularCard(Restaurant r) {
    final isTablet = ResponsiveHelper.isLargeScreen(context);
    return GestureDetector(
      onTap: () => _openRestaurant(r),
      child: Container(
        width: isTablet ? 180 : 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: isTablet ? 110 : 90,
              width: double.infinity,
              child: r.imageUrl.isNotEmpty
                  ? Image.network(
                      r.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 28,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(color: Colors.grey[200]);
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: 28,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: const Color(0xFF39BCA8),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${r.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.time,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.grey[600],
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
    );
  }

  // ─── RESTAURANTS LIST ───────────────────────────
  Widget _buildRestaurantsList() {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horPad),
      child: Column(
        children: sampleRestaurants.map((r) => _restaurantCard(r)).toList(),
      ),
    );
  }
}
