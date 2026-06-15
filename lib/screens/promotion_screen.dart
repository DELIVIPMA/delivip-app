import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  PROMOTION SCREEN — DeliVip Promotion unique
// ═══════════════════════════════════════════════════════════════════

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Promo code input
                    _buildPromoCodeInput(),
                    const SizedBox(height: 16),
                    // Promo card
                    _buildPromoCard(context),
                    const SizedBox(height: 16),
                    // Deals banner
                    _buildDealsBanner(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
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
          const SizedBox(width: 8),
          Text(
            'Promotion',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ PROMO CODE INPUT ═════════════════════════
  Widget _buildPromoCodeInput() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.local_offer, size: 18, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Entrer un code promo',
                hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFAAAAAA)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ PROMO CARD ════════════════════════════════
  Widget _buildPromoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                '50 DH de r\u00E9duction',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              // Expiry
              Text(
                '\u00C0 utiliser avant le 29 Juil 2025 15h00',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF666666)),
              ),
              const SizedBox(height: 6),
              // Conditions
              Text(
                'Pour votre 1\u00E8re commande   Commande min. 100 DH \u2022 Livraison uniquement',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF666666), height: 1.5),
              ),
              const SizedBox(height: 16),
              // Buttons row
              Row(
                children: [
                  // Commander button
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Commander',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Detail text
                  GestureDetector(
                    onTap: () => _showDetailSheet(context),
                    child: Text(
                      'D\u00E9tail',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Right side — discount tag
          Positioned(
            top: 0,
            right: 0,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // "%" text
                    const Center(
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Tag hole
                    Positioned(
                      top: -4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DEALS BANNER ══════════════════════════════
  Widget _buildDealsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Left content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  'Obtenez les meilleures offres de votre ville en quelques secondes',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // See deals button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF333333), width: 1.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir les offres',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Right decorative illustration
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Bottom shape
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Top shape
                  Positioned(
                    top: 0,
                    right: 5,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A7A4A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Emoji on top
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Text('\u{1F4B0}', style: TextStyle(fontSize: 28)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DETAIL SHEET ══════════════════════════════
  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '50 DH de r\u00E9duction',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              Text(
                'Conditions\u00a0:',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              _detailRow('Premi\u00E8re commande uniquement'),
              _detailRow('Commande minimale de 100 DH'),
              _detailRow('Livraison uniquement'),
              _detailRow('Valable jusqu\u2019au 29 Juil 2025 \u00E0 15h00'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Fermer',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 5, color: Colors.black),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
