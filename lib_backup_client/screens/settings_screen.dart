import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  SETTINGS SCREEN — DeliVip Paramètres du compte
// ═══════════════════════════════════════════════════════════════════

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color _teal = Color(0xFF00BFA5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Profile section
                    _buildProfileSection(context),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Lieux enregistrés
                    _buildSavedPlacesSection(),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                    // Autres options
                    _buildOtherOptionsSection(context),
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
            'Param\u00E8tres',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ PROFILE SECTION ═══════════════════════════
  Widget _buildProfileSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 50, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 12),
          // Name
          Text(
            'Mohammed Amine',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 6),
          // Edit account
          GestureDetector(
            onTap: () {},
            child: Text(
              'MODIFIER LE COMPTE',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _teal,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ═══════════════════ SAVED PLACES SECTION ══════════════════════
  Widget _buildSavedPlacesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Lieux enregistr\u00E9s',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
          // Domicile
          _buildPlaceRow(Icons.home_outlined, 'Domicile', 'Ajouter domicile'),
          const SizedBox(height: 14),
          // Travail
          _buildPlaceRow(Icons.work_outline, 'Travail', 'Ajouter lieu de travail'),
          const SizedBox(height: 14),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPlaceRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.black),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF888888)),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════ OTHER OPTIONS SECTION ═════════════════════
  Widget _buildOtherOptionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Autres options',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          // Logout
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Text(
              'Se d\u00E9connecter',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _teal,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════ LOGOUT DIALOG ═════════════════════════════
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'D\u00E9connexion',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Voulez-vous vraiment vous d\u00E9connecter ?',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Annuler',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Logout logic here
            },
            child: Text(
              'Se d\u00E9connecter',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: _teal),
            ),
          ),
        ],
      ),
    );
  }
}
