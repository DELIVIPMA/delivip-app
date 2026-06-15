import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ORDER CANCELLED SCREEN — DeliVip Commande annulée
// ═══════════════════════════════════════════════════════════════════

class OrderCancelledScreen extends StatelessWidget {
  const OrderCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Scrollable Content ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(),
                    _buildContent(),
                  ],
                ),
              ),
            ),
            // ── Bottom Buttons ──────────────────────────────────
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Commande #2AED2',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Aide',
              style: GoogleFonts.inter(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ BANNER ════════════════════════════════════
  Widget _buildBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD4A373), Color(0xFF8B5E3C), Color(0xFF5D4037)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Scattered emojis
          Positioned(top: 20, left: 30, child: const Text('\u{1F355}', style: TextStyle(fontSize: 50))),
          Positioned(top: 60, right: 40, child: const Text('\u{1F957}', style: TextStyle(fontSize: 45))),
          Positioned(bottom: 30, left: 60, child: const Text('\u{1F9C6}', style: TextStyle(fontSize: 55))),
          Positioned(top: 30, right: 80, child: const Text('\u{1F354}', style: TextStyle(fontSize: 40))),
          Positioned(bottom: 40, right: 30, child: const Text('\u{1F372}', style: TextStyle(fontSize: 50))),
          // View store button
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Voir le magasin',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ CONTENT ═══════════════════════════════════
  Widget _buildContent() {
    final items = [
      {'qty': '1', 'name': 'Poulet Crispy'},
      {'qty': '1', 'name': 'Cookies Chocolat'},
      {'qty': '1', 'name': 'Coca-Cola 1.5L'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant name
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Pizza Roma Agadir',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          // Status row
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Text(
                  'Commande annul\u00E9e',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF5252),
                  ),
                ),
                Text(
                  ' \u2022 23 Ao\u00FBt \u00E0 15:43',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Section title
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Text(
              'Votre commande',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          // Order items
          ...items.map((item) => _buildOrderItem(item['qty']!, item['name']!)),
          // Total row
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt, size: 22, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(
                        'Total : 125.00 DH',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String qty, String name) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    qty,
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
      ],
    );
  }

  // ═══════════════════ BOTTOM BUTTONS ════════════════════════════
  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'Recommander',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              side: const BorderSide(color: Color(0xFFE0E0E0), width: 0),
            ),
            child: Text(
              'Voir le re\u00E7u',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
