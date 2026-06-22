import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';
import '../screens/cart_screen.dart';

// ═══════════════════════════════════════════════════════
//  RESTAURANT MENU SCREEN — Liste Style (comme avant)
// ═══════════════════════════════════════════════════════

class RestaurantMenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback? onBack;
  final VoidCallback? onNavigateToCart;
  final VoidCallback? onNavigateToSearch;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurant,
    this.onBack,
    this.onNavigateToCart,
    this.onNavigateToSearch,
  });

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  String _selectedCategory = '';
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    final r = widget.restaurant;
    final catSet = <String>{};
    for (final item in r.menu) {
      if (item.category.isNotEmpty) {
        catSet.add(item.category);
      }
    }
    _categories = catSet.toList()..sort();
    if (_categories.isEmpty) {
      _categories = ['Plats All'];
    }
    _selectedCategory = _categories.first;
    for (final cat in _categories) {
      _sectionKeys[cat] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<MenuItem> _itemsForCategory(String category) {
    final r = widget.restaurant;
    return r.menu
        .where(
          (item) =>
              item.category == category ||
              (category == 'Plats All' && item.category.isEmpty),
        )
        .toList();
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    final ctx = _sectionKeys[cat]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
  }

  Widget _buildFallbackHeader(Restaurant r) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text(
          r.emoji,
          style: GoogleFonts.poppins(fontSize: 64, color: Colors.grey[400]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final r = widget.restaurant;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollCtrl,
            slivers: [
              // ─── SliverAppBar with cover ─────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                surfaceTintColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 22,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          final rootNav = Navigator.of(
                            context,
                            rootNavigator: true,
                          );
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search_rounded,
                          size: 22,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          if (widget.onNavigateToSearch != null) {
                            widget.onNavigateToSearch!();
                          } else {
                            context.go('/search');
                          }
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: r.imageUrl.isNotEmpty
                      ? Image.network(
                          r.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildFallbackHeader(r),
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : _buildFallbackHeader(r),
                        )
                      : _buildFallbackHeader(r),
                ),
              ),

              // ─── Restaurant Info ─────────────────────────
              SliverToBoxAdapter(
                key: _sectionKeys[_selectedCategory],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF39BCA8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Color(0xFF39BCA8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  r.rating.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF39BCA8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${r.reviewCount}+)',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            r.time,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.delivery_dining_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            r.fee,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Category Tabs ──────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryTabDelegate(
                  categories: _categories,
                  selected: _selectedCategory,
                  onChanged: _onCategoryChanged,
                ),
              ),

              // ─── Menu Items in List ─────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final items = _itemsForCategory(_selectedCategory);
                    if (index >= items.length) return null;
                    return _MenuItemListCard(
                      item: items[index],
                      restaurantId: r.id,
                      restaurantName: r.name,
                      cart: cart,
                    );
                  }, childCount: _itemsForCategory(_selectedCategory).length),
                ),
              ),
            ],
          ),

          // ─── Bottom Bar (positioned au-dessus du contenu) ─
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _UnifiedBottomBar(
              cart: cart,
              restaurantId: r.id,
              onNavigateToCart: widget.onNavigateToCart,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  CATEGORY TAB DELEGATE
// ═══════════════════════════════════════════════════════

class _CategoryTabDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onChanged;

  _CategoryTabDelegate({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isActive = cat == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onChanged(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF39BCA8) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF39BCA8)
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _categoryIcon(cat, isActive),
                    const SizedBox(width: 6),
                    Text(
                      cat,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _categoryIcon(String cat, bool isActive) {
    IconData icon;
    switch (cat.toLowerCase()) {
      case 'plats':
      case 'burgers':
        icon = Icons.lunch_dining_rounded;
        break;
      case 'pizza':
        icon = Icons.local_pizza_rounded;
        break;
      case 'drinks':
      case 'boissons':
        icon = Icons.local_cafe_rounded;
        break;
      case 'desserts':
        icon = Icons.cake_rounded;
        break;
      case 'sides':
      case 'accompagnements':
        icon = Icons.food_bank_rounded;
        break;
      case 'salades':
      case 'healthy':
        icon = Icons.eco_rounded;
        break;
      case 'tacos':
        icon = Icons.takeout_dining_rounded;
        break;
      default:
        icon = Icons.restaurant_rounded;
    }
    return Icon(
      icon,
      size: 18,
      color: isActive ? Colors.white : Colors.black54,
    );
  }

  @override
  double get maxExtent => 56;
  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _CategoryTabDelegate old) =>
      old.selected != selected || old.categories != categories;
}

// ═══════════════════════════════════════════════════════
//  MENU ITEM LIST CARD — Premium style (comme Uber Eats)
//  ✅ Image réelle | ✅ Carte cliquable | ✅ Compteur
// ═══════════════════════════════════════════════════════

class _MenuItemListCard extends StatefulWidget {
  final MenuItem item;
  final String restaurantId;
  final String restaurantName;
  final CartProvider cart;

  const _MenuItemListCard({
    required this.item,
    required this.restaurantId,
    required this.restaurantName,
    required this.cart,
  });

  @override
  State<_MenuItemListCard> createState() => _MenuItemListCardState();
}

class _MenuItemListCardState extends State<_MenuItemListCard> {
  bool _isExpanded = false;
  final Set<String> _selectedAddonIds = {};

  static const _teal = Color(0xFF39BCA8);

  // Network placeholder food images par type
  static const String _pizzaPic =
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200&q=80';
  static const String _burgerPic =
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&q=80';
  static const String _sushiPic =
      'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=200&q=80';
  static const String _chickenPic =
      'https://images.unsplash.com/photo-1562967914-608f82629710?w=200&q=80';
  static const String _defaultPic =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80';

  String get _placeholderImage {
    final name = widget.item.name.toLowerCase();
    if (name.contains('pizza') ||
        name.contains('margherita') ||
        name.contains('pepperoni') ||
        name.contains('fromage')) {
      return _pizzaPic;
    } else if (name.contains('burger') || name.contains('frites')) {
      return _burgerPic;
    } else if (name.contains('sushi') ||
        name.contains('sashimi') ||
        name.contains('roll') ||
        name.contains('california')) {
      return _sushiPic;
    } else if (name.contains('chicken') ||
        name.contains('poulet') ||
        name.contains('nuggets') ||
        name.contains('bucket') ||
        name.contains('wings')) {
      return _chickenPic;
    }
    return _defaultPic;
  }

  List<AddonOption> get _addons => widget.item.defaultAddons;

  List<AddonOption> get _selectedAddons =>
      _addons.where((a) => _selectedAddonIds.contains(a.id)).toList();

  /// Noms des suppléments sélectionnés pour l'affichage inline (style Glovo)
  String get _selectedExtrasDisplay {
    final names = _selectedAddons.map((a) => a.name).toList();
    if (names.isEmpty) return '';
    return '+ ${names.join(', ')}';
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.cart.items
        .where((c) => c.item.id == widget.item.id)
        .firstOrNull;
    if (existing != null) {
      _selectedAddonIds.addAll(existing.selectedAddons.map((a) => a.id));
    }
  }

  void _addToCart() {
    widget.cart.add(widget.item, widget.restaurantId, widget.restaurantName);
  }

  void _removeFromCart() {
    widget.cart.decrementQuantity(widget.item.id);
    if (widget.cart.itemQuantity(widget.item.id) == 0) {
      setState(() => _isExpanded = false);
    }
  }

  void _onTapCard() {
    final qty = widget.cart.itemQuantity(widget.item.id);
    if (qty > 0) {
      // Déjà dans le panier → ouvrir/fermer la section suppléments
      setState(() => _isExpanded = !_isExpanded);
    } else {
      // Pas encore dans le panier → ajouter + ouvrir suppléments
      widget.cart.add(widget.item, widget.restaurantId, widget.restaurantName);
      setState(() => _isExpanded = true);
    }
  }

  void _onValidate() {
    widget.cart.updateAddons(widget.item.id, _selectedAddons);
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final quantity = widget.cart.itemQuantity(widget.item.id);
    final imageUrl = widget.item.imageUrl.isNotEmpty
        ? widget.item.imageUrl
        : _placeholderImage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Carte cliquable (InkWell) ─────────────────
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _onTapCard,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black.withOpacity(0.06),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Image Réelle ─────────────────
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.network(
                            imageUrl,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    widget.item.emoji,
                                    style: GoogleFonts.poppins(fontSize: 32),
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey[100],
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _teal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ─── Infos ─────────────────────────
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.item.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '${widget.item.price.toStringAsFixed(2)} DH',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: _teal,
                                    ),
                                  ),
                                  const Spacer(),
                                  // ── Compteur (visible si qty > 0) ──
                                  if (quantity > 0) _buildCounterPill(quantity),
                                ],
                              ),
                              // ─── Suppléments inline (style Glovo) ──
                              if (quantity > 0 &&
                                  _selectedExtrasDisplay.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _selectedExtrasDisplay,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ─── Suppléments inline (AnimatedSize) ──
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.topCenter,
                    child: _isExpanded
                        ? _buildSupplementsPanel()
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupplementsPanel() {
    if (_addons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Section title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
              child: Row(
                children: [
                  Text(
                    'Accompagnements',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Facultatif',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            // ── Add‑on checkboxes ──
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _addons.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Colors.grey.shade100,
              ),
              itemBuilder: (_, i) {
                final addon = _addons[i];
                final isSelected = _selectedAddonIds.contains(addon.id);
                return _InlineAddonTile(
                  addon: addon,
                  isSelected: isSelected,
                  onToggle: () {
                    setState(() {
                      if (isSelected) {
                        _selectedAddonIds.remove(addon.id);
                      } else {
                        _selectedAddonIds.add(addon.id);
                      }
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 4),
            // ── "Valider" button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _onValidate,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Valider',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(widget.item.price + _selectedAddons.fold<double>(0.0, (s, a) => s + a.price)).toStringAsFixed(2)} DH',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  Widget _buildCounterPill(int quantity) {
    return Container(
      key: ValueKey('counter_pill_${widget.item.id}'),
      width: 80,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _removeFromCart,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.remove, color: _teal, size: 14),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$quantity',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _teal,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _addToCart,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: _teal, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  INLINE ADD-ON TILE
// ═══════════════════════════════════════════════════════

class _InlineAddonTile extends StatelessWidget {
  final AddonOption addon;
  final bool isSelected;
  final VoidCallback onToggle;

  const _InlineAddonTile({
    required this.addon,
    required this.isSelected,
    required this.onToggle,
  });

  static const _teal = Color(0xFF39BCA8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Text(addon.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                addon.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              '+${addon.price.toStringAsFixed(2)} DH',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _teal : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _teal : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 11,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  UNIFIED BOTTOM BAR — réactif, lié au CartProvider
// ═══════════════════════════════════════════════════════

class _UnifiedBottomBar extends StatelessWidget {
  final CartProvider cart;
  final String restaurantId;
  final VoidCallback? onNavigateToCart;

  const _UnifiedBottomBar({
    required this.cart,
    required this.restaurantId,
    this.onNavigateToCart,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = cart.items.isNotEmpty && cart.restaurantId == restaurantId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              final rootNav = Navigator.of(context, rootNavigator: true);
              if (rootNav.canPop()) {
                rootNav.pop();
              } else if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Color(0xFF39BCA8),
                ),
                const SizedBox(width: 4),
                Text(
                  'Back',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF39BCA8),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: Container()),
          if (hasItems)
            GestureDetector(
              onTap: () {
                if (onNavigateToCart != null) {
                  onNavigateToCart!();
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Continuer',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39BCA8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF39BCA8),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
