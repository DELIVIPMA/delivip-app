import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADDRESS SELECTION SCREEN — "Détails de livraison"
//  Premium full‑page (Uber Eats style) with map placeholder,
//  current location button, and saved addresses list.
// ═══════════════════════════════════════════════════════════════════

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  int _selectedIndex = 0;

  static const List<_SavedAddress> _addresses = [
    _SavedAddress(
      icon: Icons.home_rounded,
      label: 'Maison',
      detail: 'Rue des Orangers, Rés. Al Wafa, Agadir',
    ),
    _SavedAddress(
      icon: Icons.business_rounded,
      label: 'Travail',
      detail: 'Centre ville, Agadir',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildMapPlaceholder(),
                _buildCurrentLocationTile(),
                const Divider(height: 1, color: _dark, indent: 0, endIndent: 0),
                _buildSavedAddressesSection(),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _dark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Détails de livraison',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _dark,
        ),
      ),
      centerTitle: false,
    );
  }

  // ─── MAP PLACEHOLDER ─────────────────────────────────────
  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Map Integration Here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── CURRENT LOCATION TILE ───────────────────────────────
  Widget _buildCurrentLocationTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.my_location, color: _teal, size: 22),
        ),
        title: Text(
          'Utiliser ma position actuelle',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF1E1E24),
        ),
        onTap: () {
          // Future: Geolocator integration
        },
      ),
    );
  }

  // ─── SAVED ADDRESSES SECTION ────────────────────────────
  Widget _buildSavedAddressesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adresses enregistrées',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 12),
          ..._addresses.asMap().entries.map((entry) {
            final idx = entry.key;
            final addr = entry.value;
            final isSelected = idx == _selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: isSelected
                    ? _teal.withOpacity(0.06)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _selectedIndex = idx),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(addr.icon, color: _teal, size: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addr.label,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _dark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                addr.detail,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: _teal,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── BOTTOM ACTION ──────────────────────────────────────
  Widget _buildBottomAction() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              // Future: Navigate to Add Address screen
            },
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              'Ajouter une nouvelle adresse',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Private model for saved addresses ─────────────────────
class _SavedAddress {
  final IconData icon;
  final String label;
  final String detail;
  const _SavedAddress({
    required this.icon,
    required this.label,
    required this.detail,
  });
}
