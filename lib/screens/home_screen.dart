import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'restaurant_details_screen.dart';
import 'change_address_screen.dart';

// ═══════════════════════════════════════════════════════════════════
//  HOME SCREEN — DeliVip Accueil
// ═══════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _currentBannerPage = 0;
  late PageController _bannerController;
  final List<String> _categories = [
    'Tous', 'Burgers', 'Pizza', 'Sushi', 'Tacos', 'Poulet', 'Desserts',
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final nextPage = (_currentBannerPage + 1) % 2;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(),
            // ── Search Bar ──────────────────────────────────────
            _buildSearchBar(),
            // ── Category Chips ──────────────────────────────────
            _buildCategoryChips(),
            // ── Scrollable Content ──────────────────────────────
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildFeaturedBanner()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Populaires près de vous')),
                  SliverToBoxAdapter(child: _buildPopularRestaurants()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Offres du jour')),
                  SliverToBoxAdapter(child: _buildDailyOffers()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Rapides (moins de 20 min)')),
                  SliverToBoxAdapter(child: _buildFastRestaurants()),
                  SliverToBoxAdapter(child: _buildRewardsCard()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Épicerie fraîche')),
                  SliverToBoxAdapter(child: _buildGrocerySection()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Sucreries')),
                  SliverToBoxAdapter(child: _buildSweetsSection()),
                  SliverToBoxAdapter(child: _buildSectionHeader('À retirer gratuitement')),
                  SliverToBoxAdapter(child: _buildFreePickupSection()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Dernières actualités')),
                  SliverToBoxAdapter(child: _buildNewsSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangeAddressScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Agadir ▾',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SEARCH BAR ════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.search, size: 20, color: Colors.grey),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Restaurants et plats...',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.tune, size: 20, color: Color(0xFF00BFA5)),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ CATEGORY CHIPS ════════════════════════════
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isActive ? Border.all(color: Colors.black) : Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════ FEATURED BANNER ═══════════════════════════
  Widget _buildFeaturedBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 180,
        child: PageView(
          controller: _bannerController,
          onPageChanged: (page) => _currentBannerPage = page,
          children: [
            // Banner 1: Purple - Free delivery
            _bannerCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF3D2C8D), Color(0xFF2A1B5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              emoji: '\u{1F354}',
              title: 'Livraison gratuite',
              subtitle: 'Sur votre 1ère commande',
              buttonText: 'Commander',
            ),
            // Banner 2: Teal - -50% tonight
            _bannerCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              emoji: '\u{1F355}',
              title: '-50% ce soir',
              subtitle: 'Offre limitée restaurants',
              buttonText: 'Voir',
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerCard({
    required LinearGradient gradient,
    required String emoji,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 56)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ SECTION HEADER ════════════════════════════
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Voir tout',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF00BFA5)),
                ),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF00BFA5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ RESTAURANT CARD (reusable) ═══════════════
  Widget _buildRestaurantCard({
    required String emoji,
    required Color bgColor,
    required String name,
    required double rating,
    required String time,
    required String fee,
    String? badge,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 120,
                color: bgColor,
                child: Stack(
                  children: [
                    Center(child: Text(emoji, style: const TextStyle(fontSize: 40))),
                    // Rating badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 11, color: Color(0xFFF5C518)),
                            const SizedBox(width: 3),
                            Text(
                              rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Promo badge
                    if (badge != null)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 11, color: Color(0xFFF5C518)),
                      const SizedBox(width: 3),
                      Text(
                        rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.access_time, size: 11, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        time,
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.moped, size: 11, color: Color(0xFF00BFA5)),
                      const SizedBox(width: 2),
                      Text(
                        fee,
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF00BFA5), fontWeight: FontWeight.w500),
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

  // ═══════════════════ POPULAR RESTAURANTS ═══════════════════════
  Widget _buildPopularRestaurants() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildRestaurantCard(
            emoji: '\u{1F354}',
            bgColor: const Color(0xFFFFF3E0),
            name: 'Burger Palace',
            rating: 4.8,
            time: '20-30min',
            fee: 'Gratuit',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F355}',
            bgColor: const Color(0xFFFFEBEE),
            name: 'Pizza Roma',
            rating: 4.6,
            time: '25-35min',
            fee: '5DH',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F363}',
            bgColor: const Color(0xFFE8F5E9),
            name: 'Sushi Shop',
            rating: 4.7,
            time: '30-40min',
            fee: '8DH',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F32E}',
            bgColor: const Color(0xFFFFF8E1),
            name: 'Taco House',
            rating: 4.5,
            time: '20-30min',
            fee: 'Gratuit',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DAILY OFFERS ══════════════════════════════
  Widget _buildDailyOffers() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildRestaurantCard(
            emoji: '\u{1F957}',
            bgColor: const Color(0xFFE8F5E9),
            name: 'Green Bowl',
            rating: 4.6,
            time: '15-25min',
            fee: 'Gratuit',
            badge: '\u{1F525} -30%',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F35C}',
            bgColor: const Color(0xFFFFF3E0),
            name: 'Noodle Bar',
            rating: 4.4,
            time: '20-30min',
            fee: '5DH',
            badge: '\u{1F525} -30%',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F357}',
            bgColor: const Color(0xFFFFEBEE),
            name: 'Poulet Rôti+',
            rating: 4.7,
            time: '25min',
            fee: 'Gratuit',
            badge: '\u{1F525} -30%',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ FAST RESTAURANTS ══════════════════════════
  Widget _buildFastRestaurants() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildRestaurantCard(
            emoji: '\u{1F959}',
            bgColor: const Color(0xFFE3F2FD),
            name: 'Wrap & Go',
            rating: 4.3,
            time: '10-15min',
            fee: '3DH',
            badge: '\u{26A1} Rapide',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F354}',
            bgColor: const Color(0xFFFFF3E0),
            name: 'Fast Burger',
            rating: 4.2,
            time: '15min',
            fee: 'Gratuit',
            badge: '\u{26A1} Rapide',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
          _buildRestaurantCard(
            emoji: '\u{1F96A}',
            bgColor: const Color(0xFFFCE4EC),
            name: 'Sandwich Co.',
            rating: 4.5,
            time: '12min',
            fee: 'Gratuit',
            badge: '\u{26A1} Rapide',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailsScreen())),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ REWARDS CARD ══════════════════════════════
  Widget _buildRewardsCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF00BFA5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('\u{1F381}', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Gagnez des points à chaque commande!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'En savoir plus',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ GROCERY SECTION ═══════════════════════════
  Widget _buildGrocerySection() {
    final items = [
      {'emoji': '\u{1F34A}', 'name': 'Oranges', 'price': '15DH'},
      {'emoji': '\u{1F34D}', 'name': 'Ananas', 'price': '25DH'},
      {'emoji': '\u{1F353}', 'name': 'Fraises', 'price': '20DH'},
      {'emoji': '\u{1F966}', 'name': 'Brocoli', 'price': '12DH'},
    ];

    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: items.map((item) => _buildMiniCard(item['emoji']!, item['name']!, item['price']!)).toList(),
      ),
    );
  }

  // ═══════════════════ SWEETS SECTION ════════════════════════════
  Widget _buildSweetsSection() {
    final items = [
      {'emoji': '\u{1F370}', 'name': 'Gâteau', 'price': '35DH'},
      {'emoji': '\u{1F369}', 'name': 'Donuts', 'price': '18DH'},
      {'emoji': '\u{1F36B}', 'name': 'Chocolat', 'price': '22DH'},
    ];

    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: items.map((item) => _buildMiniCard(item['emoji']!, item['name']!, item['price']!)).toList(),
      ),
    );
  }

  Widget _buildMiniCard(String emoji, String name, String price) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF00BFA5)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ FREE PICKUP SECTION ═══════════════════════
  Widget _buildFreePickupSection() {
    final items = [
      {'emoji': '\u{1F964}', 'name': 'Boisson offerte', 'resto': 'chez Burger Palace'},
      {'emoji': '\u{1F35F}', 'name': 'Frites offertes', 'resto': 'chez Pizza Roma'},
    ];

    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: items.map((item) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(item['emoji']!, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['name']!,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['resto']!,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Gratuit',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════ NEWS SECTION ══════════════════════════════
  Widget _buildNewsSection() {
    final news = [
      {'title': 'Nouveau: Livraison en 15min à Agadir', 'color': const Color(0xFF3D2C8D)},
      {'title': 'Top restaurants cette semaine', 'color': const Color(0xFFE65100)},
      {'title': 'DeliVip Pass: 1 mois gratuit', 'color': const Color(0xFF00BFA5)},
    ];

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: news.map((item) {
          return Container(
            width: 160,
            height: 100,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: item['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
