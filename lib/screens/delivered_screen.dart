import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  DELIVERED SCREEN — DeliVip Commande livrée
// ═══════════════════════════════════════════════════════════════════

class DeliveredScreen extends StatelessWidget {
  const DeliveredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ═══ Top Bar ═══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close, size: 24, color: Colors.black),
                    onPressed: () => Navigator.of(context).maybePop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  // "Aide" pill button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Aide',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ═══ Spacing ═══════════════════════════════════════
            const SizedBox(height: 20),

            // ═══ Title ═════════════════════════════════════════
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profitez de votre commande',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ═══ Subtitle ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Mohammed et Pizza Hut (Agadir Marina) ont fait leur magie pour vous. Prenez un moment pour noter, laisser un pourboire et dire merci.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF444444),
                  height: 1.5,
                ),
              ),
            ),

            // ═══ Illustration (expanded to fill space) ═════════
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Large delivery bag
                      Text('\u{1F6CD}', style: TextStyle(fontSize: 100)),
                      // Stars around the bag
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Text('\u{1F31F}', style: TextStyle(fontSize: 24)),
                      ),
                      Positioned(
                        top: 20,
                        left: -20,
                        child: Text('\u2728', style: TextStyle(fontSize: 20)),
                      ),
                      Positioned(
                        bottom: 10,
                        right: -5,
                        child: Text('\u{1F49A}', style: TextStyle(fontSize: 22)),
                      ),
                      Positioned(
                        bottom: -15,
                        left: 10,
                        child: Text('\u{2B50}', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ═══ Bottom Button ═════════════════════════════════
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  'Fermer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
