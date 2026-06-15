import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  FILTERS SCREEN — DeliVip Tous les filtres
// ═══════════════════════════════════════════════════════════════════

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  int _selectedSortIndex = 0; // 0 = Sélectionné pour vous (default)
  bool _offersToggle = false;
  bool _valueToggle = false;
  int? _selectedPriceIndex;
  double _deliveryFeeSlider = 25;
  final Set<int> _selectedDiets = {};

  void _toggleDiet(int index) {
    setState(() {
      if (_selectedDiets.contains(index)) {
        _selectedDiets.remove(index);
      } else {
        _selectedDiets.add(index);
      }
    });
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
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSortSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    _buildExclusiveSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    _buildPriceRangeSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    _buildDeliveryFeeSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    _buildDietSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // ── Bottom Fixed Button ────────────────────────────
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Tous les filtres',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSortIndex = 0;
                  _offersToggle = false;
                  _valueToggle = false;
                  _selectedPriceIndex = null;
                  _deliveryFeeSlider = 25;
                  _selectedDiets.clear();
                });
              },
              child: Center(
                child: Text(
                  'Réinitialiser',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SORT SECTION ═════════════════════════════
  Widget _buildSortSection() {
    final sortOptions = [
      {'icon': '\u{1F3AF}', 'label': 'Sélectionné pour vous (défaut)'},
      {'icon': '\u{1F525}', 'label': 'Les plus populaires'},
      {'icon': '\u{2B50}', 'label': 'Note'},
      {'icon': '\u{1F550}', 'label': 'Temps de livraison'},
    ];

    return _sectionContainer(
      title: 'Trier par',
      marginTop: 16,
      child: Column(
        children: List.generate(sortOptions.length, (index) {
          final opt = sortOptions[index];
          final isSelected = _selectedSortIndex == index;
          return Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedSortIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text(opt['icon']!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          opt['label']!,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, size: 20, color: Color(0xFF00BFA5)),
                    ],
                  ),
                ),
              ),
              if (index < sortOptions.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Divider(height: 1, thickness: 1, color: const Color(0xFFEBEDF0).withValues(alpha: 0.7)),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ═══════════════════ EXCLUSIVE SECTION ════════════════════════
  Widget _buildExclusiveSection() {
    return _sectionContainer(
      title: 'DeliVip Exclusif',
      marginTop: 20,
      child: Column(
        children: [
          _toggleRow('\u{1F48E}', 'Offres', _offersToggle, (v) => setState(() => _offersToggle = v)),
          const Divider(height: 1, thickness: 1, indent: 52, color: Color(0xFFEBEDF0)),
          _toggleRow('\u{1F3C6}', 'Meilleur rapport qualité-prix', _valueToggle, (v) => setState(() => _valueToggle = v)),
        ],
      ),
    );
  }

  Widget _toggleRow(String icon, String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF00BFA5),
            activeTrackColor: const Color(0xFF00BFA5).withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ═══════════════════ PRICE RANGE SECTION ══════════════════════
  Widget _buildPriceRangeSection() {
    final priceOptions = ['DH', 'DH DH', 'DH DH DH', 'DH DH DH DH+'];

    return _sectionContainer(
      title: 'Gamme de prix',
      marginTop: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(priceOptions.length, (index) {
            final isSelected = _selectedPriceIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedPriceIndex = index),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : const Color(0xFFCCCCCC),
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    priceOptions[index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey,
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

  // ═══════════════════ DELIVERY FEE SECTION ═════════════════════
  Widget _buildDeliveryFeeSection() {
    final labels = ['5 DH', '15 DH', '25 DH', '25+ DH'];

    return _sectionContainer(
      title: 'Frais de livraison max.',
      marginTop: 20,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((l) {
                return Text(
                  l,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
                );
              }).toList(),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.black,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              thumbColor: Colors.black,
              trackHeight: 3,
              overlayColor: Colors.black.withValues(alpha: 0.08),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
              value: _deliveryFeeSlider,
              min: 5,
              max: 50,
              divisions: 3,
              label: '${_deliveryFeeSlider.toInt()} DH',
              onChanged: (v) => setState(() => _deliveryFeeSlider = v),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ DIET SECTION ═════════════════════════════
  Widget _buildDietSection() {
    final dietOptions = [
      {'icon': '\u{1F33F}', 'label': 'Végétarien'},
      {'icon': '\u{1F49A}', 'label': 'Végétalien'},
      {'icon': '\u{1F33E}', 'label': 'Sans gluten'},
      {'icon': '\u{262A}\uFE0F', 'label': 'Halal'},
      {'icon': '\u{1F6E1}\uFE0F', 'label': 'Adapté aux allergies'},
    ];

    return _sectionContainer(
      title: 'Régime alimentaire',
      marginTop: 20,
      child: Column(
        children: List.generate(dietOptions.length, (index) {
          final opt = dietOptions[index];
          final isSelected = _selectedDiets.contains(index);
          return Column(
            children: [
              GestureDetector(
                onTap: () => _toggleDiet(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text(opt['icon']!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          opt['label']!,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.bold,
                            color: isSelected ? const Color(0xFF00BFA5) : Colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA5),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (index < dietOptions.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Divider(height: 1, thickness: 1, color: const Color(0xFFEBEDF0).withValues(alpha: 0.7)),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ═══════════════════ BOTTOM BUTTON ════════════════════════════
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Appliquer les filtres',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ═══════════════════ HELPERS ══════════════════════════════════
  Widget _sectionContainer({required String title, required double marginTop, required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
