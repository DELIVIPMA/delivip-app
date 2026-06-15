import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ORDER SELECTION SCREEN — DeliVip Personnalisation commande
// ═══════════════════════════════════════════════════════════════════

class OrderSelectionScreen extends StatefulWidget {
  const OrderSelectionScreen({super.key});

  @override
  State<OrderSelectionScreen> createState() => _OrderSelectionScreenState();
}

class _OrderSelectionScreenState extends State<OrderSelectionScreen> {
  // Sauce radio
  int _selectedSauce = 0;

  // Sauce à part checkbox
  bool _sauceApart = false;

  // Taille radio
  int _selectedSize = 0;

  // Pâte radio
  int _selectedPate = 0;

  // Suppléments checkboxes
  final Set<int> _selectedSupplements = {};

  // Souvent commandés checkboxes
  final Set<int> _selectedCombo = {};

  // Quantity
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
            // ── Top Section (not scrollable) ────────────────────
            _buildTopSection(),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Section 1: Sauce
                    _buildRadioSection(
                      title: 'Choisissez votre sauce',
                      required: true,
                      options: [
                        'Sauce Mariana',
                        'Sauce Ail',
                        'Sauce Pesto',
                        'Sauce BBQ',
                        'Sauce Buffalo',
                      ],
                      selectedIndex: _selectedSauce,
                      onChanged: (v) => setState(() => _selectedSauce = v ?? 0),

                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                    // Section 2: Sauce à part
                    _buildCheckboxSimpleSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                    // Section 3: Taille
                    _buildRadioPricedSection(
                      title: 'Choisissez votre taille',
                      required: true,
                      options: [
                        _SizeOption('Petite 25cm (6 Parts)', null),
                        _SizeOption('Moyenne 30cm (8 Parts)', '+10.00 DH ea'),
                        _SizeOption('Grande 35cm (8 Parts)', '+25.00 DH ea'),
                        _SizeOption('Tr\u00E8s grande 40cm (12 Parts)', '+37.00 DH ea'),
                        _SizeOption('Super 50cm (12 Parts)', '+45.00 DH ea'),
                        _SizeOption('60cm', '+62.00 DH ea'),
                      ],
                      selectedIndex: _selectedSize,
                      onChanged: (v) => setState(() => _selectedSize = v),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                    // Section 4: Pâte
                    _buildRadioPricedSection(
                      title: 'Choisissez votre p\u00E2te',
                      required: true,
                      options: [
                        _SizeOption('P\u00E2te classique', null),
                        _SizeOption('P\u00E2te fine croustillante', '+10.00 DH ea'),
                        _SizeOption('P\u00E2te \u00E9paisse', '+25.00 DH ea'),
                      ],
                      selectedIndex: _selectedPate,
                      onChanged: (v) => setState(() => _selectedPate = v),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                    // Section 5: Suppléments
                    _buildCheckboxPricedSection(
                      title: 'Choisissez vos suppl\u00E9ments',
                      subtitle: 'Choisir jusqu\u2019\u00E0 3',
                      options: [
                        _CheckOption('1 Sauce ranch', '+1.50 DH ea'),
                        _CheckOption('2 Sauces ranch', '+3.00 DH ea'),
                        _CheckOption('Sauce marinara', '+2.00 DH ea'),
                      ],
                      selected: _selectedSupplements,
                      onChanged: (i) {
                        setState(() {
                          if (_selectedSupplements.contains(i)) {
                            _selectedSupplements.remove(i);
                          } else if (_selectedSupplements.length < 3) {
                            _selectedSupplements.add(i);
                          }
                        });
                      },
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

                    // Section 6: Souvent commandés ensemble
                    _buildComboSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // ── Quantity Row + Bottom ──────────────────────────
            _buildBottomRow(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP SECTION ═══════════════════════════════
  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Pizza Roma Agadir',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '65.00 DH',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Base tomate, mozzarella, champignons, ricotta, thym, huile de truffe blanche. Ajouter roquette en suppl\u00E9ment.',
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
          ),
        ),
        // Promo banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Promotion appliqu\u00E9e',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Voir le panier pour la remise finale',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF00BFA5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.info_outline, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════ RADIO SECTION (text only) ═════════════════
  Widget _buildRadioSection({
    required String title,
    required bool required,
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int?> onChanged,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              if (required)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Obligatoire',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        ...List.generate(options.length, (i) {
          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Radio<int>(
                          value: i,
                          groupValue: selectedIndex,
                          onChanged: onChanged,
                          activeColor: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          options[i],
                          style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < options.length - 1)
                const Divider(height: 1, thickness: 1, indent: 52, endIndent: 20, color: Color(0xFFEBEDF0)),
            ],
          );
        }),
      ],
    );
  }

  // ═══════════════════ RADIO SECTION (with price) ════════════════
  Widget _buildRadioPricedSection({
    required String title,
    required bool required,
    required List<_SizeOption> options,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              if (required)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Obligatoire',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        ...List.generate(options.length, (i) {
          final opt = options[i];
          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Radio<int>(
                          value: i,
                          groupValue: selectedIndex,
                          onChanged: (v) => onChanged(v ?? 0),
                          activeColor: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          opt.label,

                          style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      if (opt.price != null)
                        Row(
                          children: [
                            Text(
                              opt.price!,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (i < options.length - 1)
                const Divider(height: 1, thickness: 1, indent: 52, endIndent: 20, color: Color(0xFFEBEDF0)),
            ],
          );
        }),
      ],
    );
  }

  // ═══════════════════ CHECKBOX SIMPLE ═══════════════════════════
  Widget _buildCheckboxSimpleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              Text(
                'Sauce \u00E0 part',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(width: 8),
              Text(
                'Choisir jusqu\u2019\u00E0 1',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => setState(() => _sauceApart = !_sauceApart),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _sauceApart,
                    onChanged: (v) => setState(() => _sauceApart = v ?? false),
                    activeColor: Colors.black,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sauce \u00E0 part',
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════ CHECKBOX PRICED SECTION ═══════════════════
  Widget _buildCheckboxPricedSection({
    required String title,
    required String subtitle,
    required List<_CheckOption> options,
    required Set<int> selected,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        ...List.generate(options.length, (i) {
          final opt = options[i];
          final isSelected = selected.contains(i);
          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onChanged(i),
                          activeColor: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          opt.label,
                          style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      Text(
                        opt.price,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < options.length - 1)
                const Divider(height: 1, thickness: 1, indent: 52, endIndent: 20, color: Color(0xFFEBEDF0)),
            ],
          );
        }),
      ],
    );
  }

  // ═══════════════════ COMBO SECTION ═════════════════════════════
  Widget _buildComboSection() {
    final combos = [
      {'name': 'Soda', 'price': '4.00 DH', 'sub': 'S\u00E9lectionner options'},
      {'name': 'Pizza Fromage', 'price': '32.00 DH', 'sub': 'S\u00E9lectionner options'},
      {'name': 'Pizza Hawaienne', 'price': '42.00 DH', 'sub': 'S\u00E9lectionner options'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Text(
            'Souvent command\u00E9s ensemble',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        ...List.generate(combos.length, (i) {
          final isSelected = _selectedCombo.contains(i);
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCombo.remove(i);
                    } else {
                      _selectedCombo.add(i);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            setState(() {
                              if (isSelected) {
                                _selectedCombo.remove(i);
                              } else {
                                _selectedCombo.add(i);
                              }
                            });
                          },
                          activeColor: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              combos[i]['name']!,
                              style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                            ),
                            Text(
                              '${combos[i]['price']} \u2022 ${combos[i]['sub']}',
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < combos.length - 1)
                const Divider(height: 1, thickness: 1, indent: 52, endIndent: 20, color: Color(0xFFEBEDF0)),
            ],
          );
        }),
      ],
    );
  }

  // ═══════════════════ BOTTOM ROW ════════════════════════════════
  Widget _buildBottomRow() {
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
                    '$_quantity',
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
            // Action button
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(
                  'Ajouter $_quantity \u00E0 la commande',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Data models
// ═══════════════════════════════════════════════════════════════════

class _SizeOption {
  final String label;
  final String? price;
  const _SizeOption(this.label, this.price);
}

class _CheckOption {
  final String label;
  final String price;
  const _CheckOption(this.label, this.price);
}
