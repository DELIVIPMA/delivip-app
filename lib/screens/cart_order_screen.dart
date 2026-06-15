import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';

// ═══════════════════════════════════════════════════════════════════
//  CART ORDER SCREEN — DeliVip Paniers avec commandes en cours
// ═══════════════════════════════════════════════════════════════════

class CartOrderScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartOrderScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ═══ Top Row: Title left + Button right ═════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title "Paniers"
                  Text(
                    'Paniers',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Rounded grey button with bookmark icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          size: 18,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mes commandes',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ═══ Divider after header ═══════════════════════════
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

            // ═══ Restaurant Cart List ═══════════════════════════
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: cartItems.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Color(0xFFF0F1F3),
                ),
                itemBuilder: (context, index) {
                  final ci = cartItems[index];
                  return _CartRestaurantRow(
                    emoji: ci.item.emoji,
                    name: ci.item.name,
                    items: '${ci.quantity} article${ci.quantity > 1 ? 's' : ''} • ${(ci.item.price * ci.quantity).toStringAsFixed(2)} DH',
                    delivery: 'Livrer à Agadir, Maroc',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Restaurant Row Widget
// ═══════════════════════════════════════════════════════════════════

class _CartRestaurantRow extends StatelessWidget {
  final String emoji;
  final String name;
  final String items;
  final String delivery;

  const _CartRestaurantRow({
    required this.emoji,
    required this.name,
    required this.items,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Circular placeholder image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Middle column: name, items, delivery
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  items,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  delivery,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Right chevron arrow
          const Icon(
            Icons.chevron_right,
            size: 22,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
