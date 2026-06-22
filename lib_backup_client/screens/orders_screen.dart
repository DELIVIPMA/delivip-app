import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/models.dart';

// ═══════════════════════════════════════════════════════
//  ORDERS SCREEN — type UberEats commandes
// ═══════════════════════════════════════════════════════

class OrdersScreen extends StatelessWidget {
  final List<Order> orders;
  const OrdersScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: DeliVipColors.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune commande',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: DeliVipColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vos commandes apparaîtront ici',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: DeliVipColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes Commandes',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: DeliVipShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.restaurantName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: DeliVipColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: order.status == 'En cours'
                            ? DeliVipColors.gold.withValues(alpha: 0.15)
                            : DeliVipColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: order.status == 'En cours'
                              ? DeliVipColors.gold
                              : DeliVipColors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${order.items.length} article(s) · ${order.total.toStringAsFixed(2)} DH',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: DeliVipColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${order.date.day}/${order.date.month}/${order.date.year} à ${order.date.hour}:${order.date.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: DeliVipColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
