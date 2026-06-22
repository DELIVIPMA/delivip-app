import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ═══════════════════════════════════════════════════════
//  PROFILE SCREEN — type UberEats profil
// ═══════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    _MenuItem(Icons.person_outline, 'Informations personnelles'),
    _MenuItem(Icons.location_on_outlined, 'Adresses de livraison'),
    _MenuItem(Icons.payment_outlined, 'Moyens de paiement'),
    _MenuItem(Icons.favorite_border, 'Favoris'),
    _MenuItem(Icons.notifications_outlined, 'Notifications'),
    _MenuItem(Icons.help_outline, 'Aide & Support'),
    _MenuItem(Icons.info_outline, 'À propos'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white, elevation: 0, centerTitle: false,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Avatar + Name
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: DeliVipColors.headerGradient, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white30, width: 2)),
              child: const Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Utilisateur DeliVip', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('utilisateur@email.com', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
            ]),
          ]),
        ),
        const SizedBox(height: 24),
        // Menu
        ..._menuItems.map((item) => _ProfileMenuItem(item: item)),
      ]),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final _MenuItem item;
  const _ProfileMenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(item.icon, color: DeliVipColors.textSecondary),
        title: Text(item.label, style: GoogleFonts.inter(fontSize: 14, color: DeliVipColors.textPrimary)),
        trailing: const Icon(Icons.chevron_right, color: DeliVipColors.textMuted, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {},
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}
