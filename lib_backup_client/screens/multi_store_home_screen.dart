import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/app_state.dart';
import '../models/store_type.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../data/stores_data.dart';
import '../theme/app_theme.dart';
import '../widgets/nine_dot_menu.dart';
import 'stores_list_screen.dart';
import 'store_detail_screen.dart';
import 'cart_screen.dart';
import 'account/profile_screen.dart';
import 'account/addresses_screen.dart';
import 'orders_screen.dart';

/// Internal model for search results (store or product)
class _SearchResultItem {
  final Store store;
  final Product? product;
  final bool isStore;

  _SearchResultItem({required this.store, this.product, required this.isStore});
}

// ═══════════════════════════════════════════════════════════════════
//  WIDGET GLASS CARD (réutilisable)
// ═══════════════════════════════════════════════════════════════════
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const _GlassCard({required this.child, this.height, this.padding})
    : margin = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  WIDGET STAGGERED ANIMATION
// ═══════════════════════════════════════════════════════════════════
class _StaggeredTile extends StatefulWidget {
  final Widget child;
  final int index;
  final AnimationController controller;

  const _StaggeredTile({
    required this.child,
    required this.index,
    required this.controller,
  });

  @override
  State<_StaggeredTile> createState() => _StaggeredTileState();
}

class _StaggeredTileState extends State<_StaggeredTile> {
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    final delay = widget.index * 0.1;

    _fade = CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        delay,
        (delay + 0.5).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    );
    _slide = Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: Interval(delay, delay + 0.6, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════
class MultiStoreHomeScreen extends StatefulWidget {
  final AppState appState;

  const MultiStoreHomeScreen({super.key, required this.appState});

  @override
  State<MultiStoreHomeScreen> createState() => _MultiStoreHomeScreenState();
}

class _MultiStoreHomeScreenState extends State<MultiStoreHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Store> _allStores = [];
  List<Store> _searchStoreResults = [];
  List<_SearchResultItem> _searchResults = [];
  bool _isSearching = false;

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _allStores = StoresData.getAllStores();
    _searchController.addListener(_onSearchChanged);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _searchStoreResults = [];
        _searchResults = [];
        return;
      }
      _isSearching = true;
      _searchStoreResults = _allStores
          .where(
            (store) =>
                store.name.toLowerCase().contains(query) ||
                store.description.toLowerCase().contains(query) ||
                store.category.toLowerCase().contains(query),
          )
          .toList();

      _searchResults = [];
      for (final store in _searchStoreResults) {
        _searchResults.add(_SearchResultItem(store: store, isStore: true));
      }
      for (final store in _allStores) {
        for (final product in store.products) {
          if (product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query)) {
            _searchResults.add(
              _SearchResultItem(store: store, product: product, isStore: false),
            );
          }
        }
      }
      if (_searchResults.length > 20) {
        _searchResults = _searchResults.sublist(0, 20);
      }
    });
  }

  void _navigateToStore(Store store) {
    _searchController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StoreDetailScreen(store: store, appState: widget.appState),
      ),
    );
  }

  void _navigateToProduct(Store store, Product product) {
    _searchController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StoreDetailScreen(store: store, appState: widget.appState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final screens = [
      _buildHomePage(context, loc),
      OrdersScreen(appState: widget.appState),
      AccountHomeScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, _) {
          return Stack(
            children: [
              // Main content
              Positioned.fill(
                child: IndexedStack(index: _currentNavIndex, children: screens),
              ),

              // 9-Dot Navigation (only on home page)
              if (_currentNavIndex == 0)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: NineDotMenu(
                    centerAlignment: Alignment.center,
                    margin: EdgeInsets.zero,
                    spreadRadius: 110,
                    buttonSize: 50,
                    showLabels: true,
                    actions: [
                      NavAction(
                        icon: Icons.add_shopping_cart,
                        label: 'Nouvelle\ncommande',
                        color: Color(0xFF00BFA5),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.account_balance_wallet,
                        label: 'Wallet',
                        color: Color(0xFFFFC107),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.motorcycle,
                        label: 'Riders',
                        color: Color(0xFF7C4DFF),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.map,
                        label: 'Map',
                        color: Color(0xFFFF5252),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.receipt_long,
                        label: 'Mes\ncommandes',
                        color: Color(0xFF448AFF),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.favorite,
                        label: 'Favoris',
                        color: Color(0xFFFF4081),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.local_offer,
                        label: 'Promos',
                        color: Color(0xFFFF6D00),
                        onTap: _dummyNav,
                      ),
                      NavAction(
                        icon: Icons.headset_mic,
                        label: 'Support',
                        color: Color(0xFF00BCD4),
                        onTap: _dummyNav,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(loc),
      floatingActionButton:
          _currentNavIndex == 0 && widget.appState.cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(appState: widget.appState),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryCyan,
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                '${widget.appState.cartItemCount} ${loc.panier}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  /// Temporary dummy navigation callback (replace with real routes)
  static void _dummyNav() {
    // Will be replaced with actual navigation logic
  }

  // ══════════════════════════════════════════════════════════════
  //  HOME PAGE LAYOUT (AVEC STAGGERED + STORES UBER-EATS STYLE)
  // ══════════════════════════════════════════════════════════════
  Widget _buildHomePage(BuildContext context, AppLocalizations loc) {
    if (_isSearching) {
      return Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, loc),
              SliverToBoxAdapter(child: _buildLocationBar(context, loc)),
              SliverToBoxAdapter(child: _buildSearchBar(context, loc)),
              SliverToBoxAdapter(child: _buildSearchResults(context)),
            ],
          ),
        ],
      );
    }
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, loc),
        SliverToBoxAdapter(child: _buildLocationBar(context, loc)),
        SliverToBoxAdapter(child: _buildSearchBar(context, loc)),
        // Grille Bento des catégories (avec staggered)
        SliverToBoxAdapter(child: _buildStoreTypes(context, loc)),
        // Stores à la UberEats
        SliverToBoxAdapter(child: _buildStoresRow(context)),
        // Bannière Livraison Gratuite VIP
        SliverToBoxAdapter(child: _buildPromoBanner()),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  BOTTOM NAV
  // ══════════════════════════════════════════════════════════════
  Widget _buildBottomNav(AppLocalizations loc) {
    return NavigationBar(
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentNavIndex = index;
          if (index == 0) {
            _animController.forward(from: 0);
          }
        });
      },
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      indicatorColor: AppTheme.primaryCyan.withValues(alpha: 0.15),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home, color: AppTheme.primaryCyan),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(
            Icons.receipt_long,
            color: AppTheme.primaryCyan,
          ),
          label: loc.mesCommandes,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person, color: AppTheme.primaryCyan),
          label: loc.monCompte,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  APP BAR
  // ══════════════════════════════════════════════════════════════
  Widget _buildAppBar(BuildContext context, AppLocalizations loc) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 100,
      backgroundColor: AppTheme.primaryCyan,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          'DeliVIP',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  widget.appState.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Switch(
                value: widget.appState.isDarkMode,
                onChanged: (value) {
                  widget.appState.toggleTheme();
                },
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.white38,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  LOCATION BAR
  // ══════════════════════════════════════════════════════════════
  Widget _buildLocationBar(BuildContext context, AppLocalizations loc) {
    final user = widget.appState.currentUser;
    final address = user?.deliveryAddress ?? 'Avenue Hassan II';
    final city = user?.deliveryCity ?? 'Agadir';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressesScreen(appState: widget.appState),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: _StaggeredTile(
          index: 0,
          controller: _animController,
          child: _GlassCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppTheme.primaryCyan,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.livrerA,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$address, $city',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  SEARCH BAR
  // ══════════════════════════════════════════════════════════════
  Widget _buildSearchBar(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _StaggeredTile(
        index: 1,
        controller: _animController,
        child: _GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: loc.rechercher,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppTheme.primaryCyan,
              ),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  SEARCH RESULTS
  // ══════════════════════════════════════════════════════════════
  Widget _buildSearchResults(BuildContext context) {
    final storeResults = _searchResults.where((r) => r.isStore).toList();
    final productResults = _searchResults.where((r) => !r.isStore).toList();

    if (_searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucun résultat trouvé',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (storeResults.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.store, size: 20, color: AppTheme.primaryCyan),
                const SizedBox(width: 8),
                Text(
                  'Magasins (${storeResults.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...storeResults.map((r) => _buildSearchResultCard(r)),
            const SizedBox(height: 24),
          ],
          if (productResults.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.shopping_bag, size: 20, color: AppTheme.primaryCyan),
                const SizedBox(width: 8),
                Text(
                  'Produits (${productResults.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...productResults.map((r) => _buildSearchResultCard(r)),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(_SearchResultItem result) {
    final storeTypeInfo = StoreTypeInfo.get(result.store.storeType);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (result.isStore) {
            _navigateToStore(result.store);
          } else if (result.product != null) {
            _navigateToProduct(result.store, result.product!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: storeTypeInfo.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  result.isStore ? storeTypeInfo.icon : Icons.shopping_bag,
                  color: storeTypeInfo.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.isStore
                          ? result.store.name
                          : (result.product?.name ?? ''),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.isStore
                          ? result.store.description
                          : '${result.product?.description ?? ''} — ${result.store.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!result.isStore && result.product != null)
                Text(
                  '${result.product!.finalPrice.toStringAsFixed(0)} MAD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: storeTypeInfo.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  BENTO GRID — STORE TYPES (glass + staggered)
  // ══════════════════════════════════════════════════════════════
  Widget _buildStoreTypes(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StaggeredTile(
            index: 2,
            controller: _animController,
            child: Text(
              loc.queSouhaitezVous,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _StaggeredTile(
            index: 3,
            controller: _animController,
            child: _buildBentoGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne gauche — Restaurants (grande carte)
        Expanded(
          flex: 5,
          child: _GlassCard(
            height: 240,
            padding: const EdgeInsets.all(18),
            child: _buildBentoLargeCard(
              StoreType.restaurant,
              StoreTypeInfo.get(StoreType.restaurant),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Colonne droite — Épiceries + Boutiques
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _GlassCard(
                height: 110,
                padding: const EdgeInsets.all(14),
                child: _buildBentoSmallCard(
                  StoreType.grocery,
                  StoreTypeInfo.get(StoreType.grocery),
                ),
              ),
              const SizedBox(height: 14),
              _GlassCard(
                height: 116,
                padding: const EdgeInsets.all(14),
                child: _buildBentoSmallCard(
                  StoreType.shop,
                  StoreTypeInfo.get(StoreType.shop),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBentoLargeCard(StoreType type, StoreTypeInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: info.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Populaire',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: info.color,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: info.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(info.icon, color: info.color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          info.namePlural,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info.description,
          style: TextStyle(fontSize: 11, color: Colors.grey[500], height: 1.3),
        ),
      ],
    );
  }

  Widget _buildBentoSmallCard(StoreType type, StoreTypeInfo info) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: info.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(info.icon, color: info.color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                info.namePlural,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                info.description,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, size: 18, color: Colors.grey[300]),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  STORES ROW — STYLE UBER EATS
  // ══════════════════════════════════════════════════════════════
  Widget _buildStoresRow(BuildContext context) {
    // Prendre les 8 premiers stores (un mix de restaurants, epiceries, etc.)
    final featured = _allStores.take(8).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StaggeredTile(
            index: 4,
            controller: _animController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Magasins près de chez vous',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoresListScreen(
                            storeType: StoreType.restaurant,
                            appState: widget.appState,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Voir tout',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 190,
            child: _StaggeredTile(
              index: 5,
              controller: _animController,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final store = featured[i];
                  return _buildStoreCard(store);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Store store) {
    final typeInfo = StoreTypeInfo.get(store.storeType);
    return GestureDetector(
      onTap: () => _navigateToStore(store),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Icon placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: typeInfo.color.withValues(alpha: 0.08),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        typeInfo.icon,
                        size: 70,
                        color: typeInfo.color.withValues(alpha: 0.12),
                      ),
                    ),
                    if (store.isVIP)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.vipGold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    Center(
                      child: Icon(
                        typeInfo.icon,
                        size: 36,
                        color: typeInfo.color.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[600]),
                      const SizedBox(width: 3),
                      Text(
                        store.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${store.deliveryTime} min',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (store.deliveryFee == 0)
                    Text(
                      'Livraison gratuite',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  PROMO BANNER — LIVRAISON GRATUITE VIP
  // ══════════════════════════════════════════════════════════════
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: _StaggeredTile(
        index: 6,
        controller: _animController,
        child: _GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.vipGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'VIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Livraison gratuite',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sur tous les magasins VIP',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.vipGold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: AppTheme.vipGold,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
