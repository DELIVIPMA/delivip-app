import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ORDER DETAIL SCREEN — DeliVip Votre commande
// ═══════════════════════════════════════════════════════════════════

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _selectedService = 1; // 0 = Prioritaire, 1 = Standard, 2 = Planifier

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Address Row ─────────────────────────────────────
            _buildAddressRow(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Store Row ───────────────────────────────────────
            _buildStoreRow(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Order Item Row ──────────────────────────────────
            _buildOrderItemRow(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Delivery Options (Planifier) ────────────────────
            _buildDeliveryOptions(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Minimum Order Warning ───────────────────────────
            _buildMinimumOrderWarning(),
            // ── Spacer ──────────────────────────────────────────
            const Expanded(child: SizedBox()),
            // ── Bottom Button ───────────────────────────────────
            _buildBottomButton(context),
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
            icon: const Icon(Icons.close, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Votre commande',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Modifier',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ ADDRESS ROW ═══════════════════════════════
  Widget _buildAddressRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.location_pin, size: 22, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agadir Marina',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ma liste DeliVip',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  // ═══════════════════ STORE ROW ═════════════════════════════════
  Widget _buildStoreRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: const Color(0xFFF5F5F5),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFC8102E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                'DV',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Marjane Express',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Text(
            '2.70 DH',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ ORDER ITEM ROW ════════════════════════════
  Widget _buildOrderItemRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            '1 pc',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          const Text('\u{1F34C}', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Banane Bio',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  '2.70 DH/pc',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DELIVERY OPTIONS ══════════════════════════
  Widget _buildDeliveryOptions() {
    final options = [
      {'label': 'Prioritaire', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': '+10.00 DH'},
      {'label': 'Standard', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': null},
      {'label': 'Planifier', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: List.generate(options.length, (i) {
          final isSelected = _selectedService == i;
          final opt = options[i];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: () => setState(() => _selectedService = i),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt['label']!,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opt['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (opt['price'] != null)
                    Text(
                      opt['price']!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ MINIMUM ORDER WARNING ═════════════════════
  Widget _buildMinimumOrderWarning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                'Le montant minimum de commande est de 50.00 DH',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Ajoutez encore 47.30 DH \u00E0 votre commande et b\u00E9n\u00E9ficiez d\u2019une livraison gratuite',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ BOTTOM BUTTON ═════════════════════════════
  Widget _buildBottomButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
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
          'Passer \u00E0 la caisse',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
