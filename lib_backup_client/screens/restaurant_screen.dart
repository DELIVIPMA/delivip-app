import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';

// ═══════════════════════════════════════════════════════
//  RESTAURANT SCREEN — type UberEats detail
// ═══════════════════════════════════════════════════════

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  final CartProvider cart;
  const RestaurantScreen({super.key, required this.restaurant, required this.cart});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: DeliVipColors.teal,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: DeliVipColors.headerGradient),
                child: Stack(children: [
                  Center(child: Text(r.emoji, style: const TextStyle(fontSize: 80))),
                  Positioned(
                    bottom: 60, left: 20,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.star, size: 16, color: Color(0xFFF5C518)),
                        const SizedBox(width: 4),
                        Text('${r.rating} (${r.reviewCount})', style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(r.time, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 12),
                        Icon(Icons.moped, size: 14, color: DeliVipColors.gold),
                        const SizedBox(width: 4),
                        Text(r.fee, style: GoogleFonts.inter(color: DeliVipColors.gold, fontSize: 13, fontWeight: FontWeight.w600)),
                      ]),
                    ]),
                  ),
                ]),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Menu
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = r.menu[index];
                  return _MenuItemCard(item: item, cart: widget.cart);
                },
                childCount: r.menu.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final CartProvider cart;
  const _MenuItemCard({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: DeliVipShadows.soft),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 32))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: DeliVipColors.textPrimary)),
              const SizedBox(height: 4),
              Text(item.description, style: GoogleFonts.inter(fontSize: 12, color: DeliVipColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text('${item.price.toStringAsFixed(2)} DH', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: DeliVipColors.teal)),
            ])),
            GestureDetector(
              onTap: () {
                cart.add(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} ajouté au panier'), duration: const Duration(seconds: 1), backgroundColor: DeliVipColors.teal),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: DeliVipColors.teal, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
