import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  RECOMMENDATIONS SCREEN — DeliVip Articles recommandés
// ═══════════════════════════════════════════════════════════════════

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  bool _utensilsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Drag Handle ─────────────────────────────────────
            _buildDragHandle(),
            // ── Scrollable Content ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 4),
                    // Savings
                    _buildSavings(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Order item
                    _buildOrderItem(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Recommended items
                    _buildRecommendedSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Subtotal
                    _buildSubtotal(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Utensils row
                    _buildUtensilsRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // ── Bottom Buttons ─────────────────────────────────
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ DRAG HANDLE ═══════════════════════════════
  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // ═══════════════════ HEADER ════════════════════════════════════
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            child: Text(
              'Pizza Roma Agadir',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add, size: 24, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SAVINGS ═══════════════════════════════════
  Widget _buildSavings() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Text(
          'Vous \u00E9conomisez 25 DH',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00BFA5),
          ),
        ),
      ),
    );
  }

  // ═══════════════════ ORDER ITEM ════════════════════════════════
  Widget _buildOrderItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Quantity box
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '1',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Middle: name + details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Poulet Crispy',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  '6 ailes \u2022 Sauce c\u00E9leri \u2022 Sauce ranch',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          ),
          // Right: price column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '65.00 DH',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF00BFA5)),
                  ),
                ],
              ),
              Text(
                '65.00 DH',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════ RECOMMENDED SECTION ═══════════════════════
  Widget _buildRecommendedSection() {
    final items = [
      {
        'name': 'Poulet Crispy',
        'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)',
      },
      {
        'name': 'Double Fromage \u00C9pic\u00E9',
        'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)',
      },
      {
        'name': 'Mango Freeze',
        'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(items.length, (i) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i]['name']!,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i]['promo']!,
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF00BFA5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════ SUBTOTAL ══════════════════════════════════
  Widget _buildSubtotal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sous-total',
            style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
          ),
          Text(
            '65.00 DH',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ UTENSILS ROW ══════════════════════════════
  Widget _buildUtensilsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Checkbox + label
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _utensilsChecked,
                  onChanged: (v) => setState(() => _utensilsChecked = v ?? false),
                  activeColor: Colors.black,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Demander des couverts, etc.',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          const Spacer(),
          // Note button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ajouter une note',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ BOTTOM BUTTONS ════════════════════════════
  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        // Primary button
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
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Passer \u00E0 la caisse',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        // Secondary button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Ajouter des articles',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
