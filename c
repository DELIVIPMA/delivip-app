import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cart_provider.dart';
import '../data/models.dart';

// ═══════════════════════════════════════════════════════════════════
//  CART SCREEN — Clean Light Mode (Uber Eats / Glovo Style)
// ═══════════════════════════════════════════════════════════════════

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  Color _textColor({double opacity = 1.0}) => _dark.withValues(alpha: opacity);
  Color _muted() => _textColor(opacity: 0.5);
  Color _veryMuted() => _textColor(opacity: 0.35);

  // ─── Dummy "Frequently bought together" items ────────────
  final List<MenuItem> _upsellItems = const [
    MenuItem(
      id: 'upsell_1',
      name: 'Extra Sauce',
      description: 'Sauce BBQ ou Mayo',
      price: 5.00,
      emoji: '🥫',
      category: 'Extras',
    ),
    MenuItem(
      id: 'upsell_2',
      name: 'Frites Suppl.',
      description: 'Grande portion de frites',
      price: 12.00,
      emoji: '🍟',
      category: 'Sides',
    ),
    MenuItem(
      id: 'upsell_3',
      name: 'Coca-Cola Max',
      description: '50cl glacé',
      price: 8.00,
      emoji: '🥤',
      category: 'Boissons',
    ),
    MenuItem(
      id: 'upsell_4',
      name: 'Dessert du jour',
      description: 'Cheesecake ou tiramisu',
      price: 18.00,
      emoji: '🧁',
      category: 'Desserts',
    ),
    MenuItem(
      id: 'upsell_5',
      name: 'Suppl. Fromage',
      description: 'Double portion de fromage',
      price: 7.00,
      emoji: '🧀',
      category: 'Extras',
    ),
  ];

  // ─── Image placeholders for upsells ──────────────────────
  String _upsellImage(MenuItem item) {
    final name = item.name.toLowerCase();
    if (name.contains('sauce')) {
      return 'https://images.unsplash.com/photo-1556909172-54557c7e4fb7?w=100&q=80';
    } else if (name.contains('frites')) {
      return 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=100&q=80';
    } else if (name.contains('coca') || name.contains('boisson')) {
      return 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=100&q=80';
    } else if (name.contains('dessert') || name.contains('cheesecake')) {
      return 'https://images.unsplash.com/photo-1557308536-ee475bb1e5a4?w=100&q=80';
    } else if (name.contains('fromage')) {
      return 'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=100&q=80';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100&q=80';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return _buildEmptyState(context);
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Restaurant header
              SliverToBoxAdapter(child: _buildRestaurantHeader(context, cart)),
              // Cart items
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cartItem = cart.items[index];
                  return _CartItemCard(
                    cartItem: cartItem,
                    cart: cart,
                    isLast: index == cart.items.length - 1,
                  );
                }, childCount: cart.items.length),
              ),
              // Upsell Section
              SliverToBoxAdapter(child: _buildUpsellSection(context, cart)),
              // Order Summary
              SliverToBoxAdapter(child: _buildOrderSummary(context, cart)),
              // Extra bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
      // ─── BOTTOM: Unified pill bar (no app bottom nav) ──
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) {
          return _buildPillBar(context, cart);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  APP BAR
  // ═══════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      title: Text(
        'Mon Panier',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _textColor(),
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      actions: [
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            if (cart.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () => _showClearCartDialog(context, cart),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                'Vider',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            );
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  PILL BAR — Minimaliste, exactement comme restaurant_menu
  // ═══════════════════════════════════════════════════════════

  Widget _buildPillBar(BuildContext context, CartProvider cart) {
    final hasItems = cart.items.isNotEmpty && cart.restaurantId.isNotEmpty;
    final hasContent = cart.items.isNotEmpty;

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
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
              // ← Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: _teal,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              const Spacer(),
              // Dynamic "Valider" button
              if (hasContent)
                GestureDetector(
                  onTap: () => _onCheckout(context, cart),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Valider',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Retour',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  EMPTY STATE
  // ═══════════════════════════════════════════════════════════

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 54,
                  color: _teal.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Votre panier est vide',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _textColor(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ajoutez des articles depuis un restaurant\net ils apparaîtront ici.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: _muted(), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  RESTAURANT HEADER
  // ═══════════════════════════════════════════════════════════

  Widget _buildRestaurantHeader(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.store_rounded, size: 18, color: _teal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cart.restaurantName,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textColor(opacity: 0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${cart.itemCount} article${cart.itemCount > 1 ? 's' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  UPSELL SECTION
  // ═══════════════════════════════════════════════════════════

  Widget _buildUpsellSection(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Souvent commandés ensemble',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _textColor(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ajoutez ces articles populaires à votre commande',
            style: GoogleFonts.poppins(fontSize: 12, color: _muted()),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _upsellItems.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = _upsellItems[index];
                return _UpsellCard(
                  item: item,
                  imageUrl: _upsellImage(item),
                  teal: _teal,
                  onAdd: () {
                    cart.add(item, cart.restaurantId, cart.restaurantName);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} ajouté ✓', style: GoogleFonts.poppins(fontSize: 13)),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: _teal,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ORDER SUMMARY — Clean white card with dividers
  // ═══════════════════════════════════════════════════════════

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            _summaryRow('Sous-total', '${cart.subtotal.toStringAsFixed(2)} DH'),
            const SizedBox(height: 12),
            _summaryRow(
              'Frais de livraison',
              cart.deliveryFee > 0 ? '${cart.deliveryFee.toStringAsFixed(2)} DH' : 'Gratuit',
              valueColor: cart.deliveryFee == 0 ? _teal : null,
            ),
            if (cart.deliveryFee > 0) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Livraison offerte dès 100 DH d'achat",
                  style: GoogleFonts.poppins(fontSize: 11, color: _veryMuted(), fontStyle: FontStyle.italic),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.grey.shade200),
            ),
            _summaryRow('Total', '${cart.total.toStringAsFixed(2)} DH', valueColor: _teal, isBold: true, fontSize: 17),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor, bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: fontSize - 1, fontWeight: FontWeight.w500, color: _muted()),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? _textColor(),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ACTIONS
  // ═══════════════════════════════════════════════════════════

  void _onCheckout(BuildContext context, CartProvider cart) {
    if (cart.isEmpty) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛵 Commande en cours de validation...', style: GoogleFonts.poppins(fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: _teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Vider le panier ?',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: _textColor()),
        ),
        content: Text(
          'Tous les articles seront supprimés.',
          style: GoogleFonts.poppins(fontSize: 14, color: _muted()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler', style: GoogleFonts.poppins(color: _teal, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Panier vidé', style: GoogleFonts.poppins(fontSize: 13)),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: Text('Vider', style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CART ITEM CARD — Clean white card + supplements display
// ═══════════════════════════════════════════════════════════════════

class _CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final CartProvider cart;
  final bool isLast;

  const _CartItemCard({required this.cartItem, required this.cart, this.isLast = false});

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  Color _textColor({double opacity = 1.0}) => _dark.withValues(alpha: opacity);

  String _imageForItem(MenuItem item) {
    final name = item.name.toLowerCase();
    if (name.contains('pizza') || name.contains('margherita') || name.contains('pepperoni')) {
      return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=150&q=80';
    } else if (name.contains('burger')) {
      return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150&q=80';
    } else if (name.contains('sushi') || name.contains('sashimi') || name.contains('roll')) {
      return 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=150&q=80';
    } else if (name.contains('chicken') || name.contains('poulet') || name.contains('nuggets') || name.contains('bucket')) {
      return 'https://images.unsplash.com/photo-1562967914-608f82629710?w=150&q=80';
    } else if (name.contains('frites')) {
      return 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=150&q=80';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150&q=80';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.cartItem.item;
    final isOnlyOne = widget.cart.items.length == 1 && widget.cartItem.quantity == 1;
    final extras = widget.cartItem.addonsDescription; // ← supplements text

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Dismissible(
        key: ValueKey('cart_${item.id}_${widget.cartItem.hashCode}'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
              const SizedBox(height: 4),
              Text('Supprimer', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        confirmDismiss: (_) async {
          widget.cart.removeItem(widget.cartItem);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.name} retiré du panier', style: GoogleFonts.poppins(fontSize: 13)),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFF1E1E24),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Annuler',
                textColor: _teal,
                onPressed: () => widget.cart.add(item, widget.cart.restaurantId, widget.cart.restaurantName),
              ),
            ),
          );
          return false;
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.network(
                    _imageForItem(item),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _teal.withValues(alpha: 0.08),
                      child: Center(child: Icon(Icons.restaurant, color: _teal, size: 24)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name + description + supplements + total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: _textColor(), height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.poppins(fontSize: 11, color: _textColor(opacity: 0.45), height: 1.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Supplements inline
                    if (extras.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        '+ $extras',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'Total: ${widget.cartItem.totalPrice.toStringAsFixed(2)} DH',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _teal),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isOnlyOne) {
                          widget.cart.removeItem(widget.cartItem);
                        } else {
                          widget.cart.remove(widget.cartItem);
                        }
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _teal.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                        ),
                        child: const Icon(Icons.remove_rounded, color: _teal, size: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${widget.cartItem.quantity}',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: _textColor()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.cart.add(item, widget.cart.restaurantId, widget.cart.restaurantName),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  UPSELL CARD — Compact Horizontal (white card + real image)
// ═══════════════════════════════════════════════════════════════════

class _UpsellCard extends StatelessWidget {
  static const _dark = Color(0xFF1E1E24);
  final MenuItem item;
  final String imageUrl;
  final Color teal;
  final VoidCallback onAdd;

  const _UpsellCard({required this.item, required this.imageUrl, required this.teal, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: teal.withValues(alpha: 0.1),
                      child: Center(child: Icon(Icons.fastfood, color: teal, size: 16)),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(color: teal, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.name,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _dark, height: 1.1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '+${item.price.toStringAsFixed(2)} DH',
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: teal),
          ),
        ],
      ),
    );
  }
}
