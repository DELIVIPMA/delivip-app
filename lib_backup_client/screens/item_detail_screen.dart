import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ITEM DETAIL SCREEN — DeliVip Détail d'article
// ═══════════════════════════════════════════════════════════════════

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(),
                    _buildProductName(),
                    _buildInfoSection(),
                    _buildNutritionSection(),
                    _buildSimilarProducts(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // ── Bottom Bar ──────────────────────────────────────
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 22, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ PRODUCT IMAGE ═════════════════════════════
  Widget _buildProductImage() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.white,
      child: const Center(
        child: Text('\u{1F34C}', style: TextStyle(fontSize: 120)),
      ),
    );
  }

  // ═══════════════════ PRODUCT NAME ══════════════════════════════
  Widget _buildProductName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Text(
        'Banane Bio',
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // ═══════════════════ INFO SECTION ══════════════════════════════
  Widget _buildInfoSection() {
    final infos = [
      {'label': 'Prix', 'value': '2.70 DH/pc'},
      {'label': 'Prix au kilo', 'value': '10.90 DH/kg'},
      {'label': 'Conditionnement', 'value': '1 banane'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Informations',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        ...infos.map((info) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        info['label']!,
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        info['value']!,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20, color: Color(0xFFEBEDF0)),
              ],
            )),
      ],
    );
  }

  // ═══════════════════ NUTRITION SECTION ═════════════════════════
  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Valeurs nutritionnelles',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Portion : 1 banane environ',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                const Divider(height: 16, thickness: 1, color: Color(0xFFDDDDDD)),
                // Calories row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calories 110',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      '% Valeur Quotidienne',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 14, thickness: 2, color: Color(0xFFCCCCCC)),
                // Nutrition rows
                _nutrientRow('Lipides totaux', '0g', '0%'),
                _nutrientRow('Graisses satur\u00E9es', '0g', '0%'),
                _nutrientRow('Graisses trans', '0g', '0%'),
                const Divider(height: 12, thickness: 1.5, color: Color(0xFFCCCCCC)),
                _nutrientRow('Sodium', '0mg', '0%'),
                const Divider(height: 12, thickness: 1.5, color: Color(0xFFCCCCCC)),
                _nutrientRow('Glucides totaux', '30g', '10%'),
                _nutrientRow('Fibres alimentaires', '3g', '10%'),
                _nutrientRow('Sucres', '19g', '\u2014'),
                const Divider(height: 12, thickness: 1.5, color: Color(0xFFCCCCCC)),
                _nutrientRow('Prot\u00E9ines', '1g', '\u2014'),
                const Divider(height: 12, thickness: 2, color: Color(0xFFCCCCCC)),
                // Grey section (lighter text)
                _nutrientRowGrey('Potassium', '15%'),
                const Divider(height: 10, thickness: 1, color: Color(0xFFDDDDDD)),
                _nutrientRowGrey('Calcium', '0%'),
                const Divider(height: 10, thickness: 1, color: Color(0xFFDDDDDD)),
                _nutrientRowGrey('Fer', '2%'),
                const Divider(height: 10, thickness: 1, color: Color(0xFFDDDDDD)),
                _nutrientRowGrey('Vitamine A', '2%'),
                const Divider(height: 10, thickness: 1, color: Color(0xFFDDDDDD)),
                _nutrientRowGrey('Vitamine C', '15%'),
                // Footer note
                const SizedBox(height: 10),
                Text(
                  '* Le % de la valeur quotidienne indique la contribution d\u2019un nutriment \u00E0 un r\u00E9gime alimentaire journalier. 2 000 calories par jour sont utilis\u00E9es \u00E0 titre indicatif.',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _nutrientRow(String label, String value, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          Text(
            percent,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _nutrientRowGrey(String label, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Text(
            percent,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SIMILAR PRODUCTS ══════════════════════════
  Widget _buildSimilarProducts() {
    final products = [
      '\u{1F34B}', '\u{1F34C}', '\u{1F951}', '\u{1F34E}', '\u{1F347}', '\u{1F34A}',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            'Produits similaires',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: products.map((emoji) {
              return Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 36)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ═══════════════════ BOTTOM BAR ════════════════════════════════
  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Quantity controls
            Row(
              children: [
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove, size: 18, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$_quantity pc',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            // Note button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Ajouter une note'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 18, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    'Laisser une note',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
