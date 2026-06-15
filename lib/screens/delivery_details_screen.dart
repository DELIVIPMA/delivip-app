import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'change_address_screen.dart';

// ═══════════════════════════════════════════════════════════════════
//  DELIVERY DETAILS SCREEN — DeliVip Détails de livraison
// ═══════════════════════════════════════════════════════════════════

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  // ── State ──────────────────────────────────────────────────────
  int _selectedDeliveryOption = 0; // 0 = Livraison, 1 = Retrait
  int _selectedService = 1; // 0 = Prioritaire, 1 = Standard, 2 = Planifier
  bool _utensilsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Section (not scrollable) ────────────────────
            _buildTopSection(),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    // 1. Delivery/Pickup toggle
                    _buildDeliveryToggle(),
                    const SizedBox(height: 8),
                    // 2. Address row
                    _buildAddressRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 3. Delivery instruction row
                    _buildDeliveryInstructionRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 4. Delivery time row
                    _buildDeliveryTimeRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    const SizedBox(height: 8),
                    // 5. Delivery options
                    _buildDeliveryOptions(),
                    const SizedBox(height: 12),
                    // 6. Vos articles
                    _buildYourItemsSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 7. Promo items
                    _buildPromoItemsSection(),
                    // 8. + Ajouter des articles
                    _buildAddItemsButton(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 9. Options row
                    _buildOptionsRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 10. Gift row
                    _buildGiftRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 11. Promotion row
                    _buildPromotionRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    const SizedBox(height: 8),
                    // 12. Price summary
                    _buildPriceSummary(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 13. Payment method row
                    _buildPaymentMethodRow(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // 14. Disclaimer text
                    _buildDisclaimer(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // ── Bottom Button (fixed) ──────────────────────────
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  TOP SECTION
  // ═════════════════════════════════════════════════════════════════
  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back arrow
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'D\u00E9tails de livraison',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  1. DELIVERY / PICKUP TOGGLE
  // ═════════════════════════════════════════════════════════════════
  Widget _buildDeliveryToggle() {
    const options = ['Livraison', 'Retrait'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: List.generate(options.length, (i) {
            final isActive = _selectedDeliveryOption == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDeliveryOption = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    options[i],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  2. ADDRESS ROW (tappable → change address)
  // ═════════════════════════════════════════════════════════════════
  Widget _buildAddressRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ChangeAddressScreen(),
            ),
          );
        },
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 22, color: Color(0xFF00BFA5)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agadir Marina',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Agadir, Maroc',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  3. DELIVERY INSTRUCTION ROW
  // ═════════════════════════════════════════════════════════════════
  Widget _buildDeliveryInstructionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.person, size: 22, color: Color(0xFF00BFA5)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'D\u00E9poser \u00E0 la porte',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ajouter une note',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  4. DELIVERY TIME ROW
  // ═════════════════════════════════════════════════════════════════
  Widget _buildDeliveryTimeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            'Heure de livraison',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            '15-30 min(s)',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  5. DELIVERY OPTIONS
  // ═════════════════════════════════════════════════════════════════
  Widget _buildDeliveryOptions() {
    final options = [
      {'label': 'Prioritaire', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': '+10.00 DH'},
      {'label': 'Standard', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': null},
      {'label': 'Planifier', 'subtitle': 'Livr\u00E9 directement chez vous', 'price': null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  // ═════════════════════════════════════════════════════════════════
  //  6. VOS ARTICLES
  // ═════════════════════════════════════════════════════════════════
  Widget _buildYourItemsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title + link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vos articles',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'voir le menu',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF00BFA5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Item row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quantity circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '1',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poulet Crispy',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '6 ailes \u2022 Sauce ranch',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Price column
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
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '65.00 DH',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  7. PROMO ITEMS
  // ═════════════════════════════════════════════════════════════════
  Widget _buildPromoItemsSection() {
    final promoItems = [
      {'name': 'Poulet Crispy', 'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)'},
      {'name': 'Double Fromage \u00C9pic\u00E9', 'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)'},
      {'name': 'Mango Freeze', 'promo': 'Achetez 1, obtenez 1 gratuit (ajoutez 2 au panier)'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: List.generate(promoItems.length, (i) {
          final item = promoItems[i];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['promo']!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF00BFA5),
                        ),
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
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  8. + AJOUTER DES ARTICLES
  // ═════════════════════════════════════════════════════════════════
  Widget _buildAddItemsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 18, color: Colors.black),
            const SizedBox(width: 6),
            Text(
              'Ajouter des articles',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  9. OPTIONS ROW (Couverts + Note)
  // ═════════════════════════════════════════════════════════════════
  Widget _buildOptionsRow() {
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
              const SizedBox(width: 8),
              Text(
                'Demander des couverts, etc.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Note button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ajouter une note',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  10. GIFT ROW
  // ═════════════════════════════════════════════════════════════════
  Widget _buildGiftRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Text('\u{1F381}', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'En faire un cadeau',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ajouter info destinataire',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  11. PROMOTION ROW
  // ═════════════════════════════════════════════════════════════════
  Widget _buildPromotionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.local_offer, size: 22, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promotion appliqu\u00E9e',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Vous \u00E9conomisez 25 DH',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  12. PRICE SUMMARY
  // ═════════════════════════════════════════════════════════════════
  Widget _buildPriceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildPriceRow('Sous-total', '65.00 DH', null),
          _buildPriceRow('Promotion', '\u201365.00 DH', const Color(0xFF00BFA5)),
          _buildPriceRow('Frais de livraison \u2139\ufe0f', '5.00 DH', null),
          _buildPriceRow('Taxes et frais \u2139\ufe0f', '3.50 DH', null),
          const Divider(height: 16, thickness: 1, color: Color(0xFFEBEDF0)),
          _buildPriceRow('Total', '8.50 DH', null, bold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, Color? valueColor, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  13. PAYMENT METHOD ROW
  // ═════════════════════════════════════════════════════════════════
  Widget _buildPaymentMethodRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.credit_card, size: 22, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moyen de paiement',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  14. DISCLAIMER TEXT
  // ═════════════════════════════════════════════════════════════════
  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Si vous n\u2019\u00EAtes pas disponible \u00E0 la livraison, le livreur d\u00E9posera votre commande \u00E0 la porte. En passant commande, vous acceptez d\u2019en assumer la responsabilit\u00E9.',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.grey,
          height: 1.4,
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════
  //  BOTTOM BUTTON (fixed)
  // ═════════════════════════════════════════════════════════════════
  Widget _buildBottomButton() {
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
          padding: EdgeInsets.zero,
        ),
        child: Text(
          'Suivant \u2022 8.50 DH',
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
