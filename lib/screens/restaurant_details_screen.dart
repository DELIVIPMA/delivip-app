import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';
import '../data/address_provider.dart';
import '../services/order_service.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurant;
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late Restaurant _restaurant;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _restaurant = sampleRestaurants.firstWhere(
        (r) => r.name == widget.restaurant,
        orElse: () => sampleRestaurants.first,
      );
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final r = _restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF00BFA5),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        r.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFF5C518),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${r.rating} (${r.reviewCount})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                r.time,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.moped,
                                size: 14,
                                color: Color(0xFFFCD033),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                r.fee,
                                style: const TextStyle(
                                  color: Color(0xFFFCD033),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                final rootNav = Navigator.of(context, rootNavigator: true);
                if (rootNav.canPop()) {
                  rootNav.pop();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),

          // Menu
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = r.menu[index];
                return _MenuItemCard(
                  item: item,
                  restaurantId: r.id,
                  restaurantName: r.name,
                  cart: cart,
                );
              }, childCount: r.menu.length),
            ),
          ),
        ],
      ),
      // Panier flottant
      bottomNavigationBar: cart.isEmpty
          ? null
          : _CartBottomBar(cart: cart, restaurantName: r.name),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final String restaurantId;
  final String restaurantName;
  final CartProvider cart;

  const _MenuItemCard({
    required this.item,
    required this.restaurantId,
    required this.restaurantName,
    required this.cart,
  });

  int get _cartQty {
    final existing = cart.items.where((c) => c.item.id == item.id).firstOrNull;
    return existing?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final qty = _cartQty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6B6B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.price.toStringAsFixed(2)} DH',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                  ],
                ),
              ),
              // Boutons +/- quantités
              if (qty == 0)
                GestureDetector(
                  onTap: () => cart.add(item, restaurantId, restaurantName),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00BFA5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final existing = cart.items
                              .where((c) => c.item.id == item.id)
                              .firstOrNull;
                          if (existing != null) cart.remove(existing);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.remove,
                            size: 18,
                            color: Color(0xFF00BFA5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$qty',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            cart.add(item, restaurantId, restaurantName),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: Color(0xFF00BFA5),
                          ),
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

class _CartBottomBar extends StatelessWidget {
  final CartProvider cart;
  final String restaurantName;

  const _CartBottomBar({required this.cart, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cart.itemCount} article${cart.itemCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                  Text(
                    '${cart.total.toStringAsFixed(2)} DH',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Aller à la confirmation de commande
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _CheckoutScreen(
                      cart: cart,
                      restaurantName: restaurantName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Commander',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  CHECKOUT SCREEN — Finalisation de la commande
// ═══════════════════════════════════════════════════════

class _CheckoutScreen extends StatelessWidget {
  final CartProvider cart;
  final String restaurantName;

  const _CheckoutScreen({required this.cart, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finaliser la commande'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Résumé de la commande
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé de la commande',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  restaurantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00BFA5),
                  ),
                ),
                const SizedBox(height: 12),
                ...cart.items.map(
                  (ci) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          '${ci.quantity}x',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00BFA5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ci.item.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '${ci.totalPrice.toStringAsFixed(2)} DH',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                if (cart.deliveryFee > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Livraison',
                          style: TextStyle(color: Color(0xFF6B6B6B)),
                        ),
                        Text('${cart.deliveryFee.toStringAsFixed(2)} DH'),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${cart.total.toStringAsFixed(2)} DH',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Paiement à la livraison
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.money, color: Color(0xFF4CAF50), size: 32),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paiement à la livraison',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Vous paierez en espèces à la réception de votre commande',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Adresse de livraison
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF00BFA5),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adresse de livraison',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Consumer<AddressProvider>(
                        builder: (context, addressProvider, _) {
                          final addr = addressProvider.currentAddress;
                          return Text(
                            addr?.streetName ?? 'Non définie',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B6B6B),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bouton Confirmer la commande
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _placeOrder(context),
              icon: const Icon(Icons.shopping_bag, color: Colors.white),
              label: const Text(
                'Confirmer la commande',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'En confirmant, vous acceptez de payer ${cart.total.toStringAsFixed(2)} DH à la livraison',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) async {
    final orderId = OrderService.generateOrderId();
    final addressProvider = context.read<AddressProvider>();
    final deliveryAddr =
        addressProvider.currentAddress?.streetName ?? 'Adresse non définie';

    // Envoyer vers WhatsApp
    try {
      await OrderService.sendToWhatsApp(
        orderId: orderId,
        restaurantName: restaurantName,
        restaurantPhone: '+212600000000', // À remplacer par le vrai numéro
        items: cart.items,
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        total: cart.total,
        deliveryAddress: deliveryAddr,
      );

      // Ajouter l'ordre aux commandes globales
      final order = Order(
        id: orderId,
        restaurantName: restaurantName,
        restaurantId: cart.restaurantId,
        items: List.from(cart.items),
        total: cart.total,
        deliveryAddress: deliveryAddr,
        status: 'pending',
      );
      globalOrders.insert(0, order);

      // Vider le panier
      cart.clear();

      if (!context.mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande envoyée ! Vérifiez WhatsApp 🛵'),
          backgroundColor: Color(0xFF00BFA5),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

// Liste globale des commandes (partagée avec orders_screen)
final List<Order> globalOrders = [];
