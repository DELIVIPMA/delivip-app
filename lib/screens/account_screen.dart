import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'admin_dashboard_screen.dart';

// ═══════════════════════════════════════════════════════════════
//  ACCOUNT SCREEN — DeliVip Compte utilisateur
// ═══════════════════════════════════════════════════════════════

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const Color _teal = Color(0xFF00BFA5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // User Profile Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: const BoxDecoration(color: _teal, shape: BoxShape.circle),
                          child: const Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Text('Mohammed Amine', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                  const SizedBox(height: 8),

                  // Menu items
                  _MenuItemRow(icon: '🗂', title: 'Mes commandes'),
                  _menuDivider(),
                  _MenuItemRow(icon: '♥', title: 'Mes favoris'),
                  _menuDivider(),
                  _MenuItemRow(icon: '⭐', title: 'Récompenses restaurants'),
                  _menuDivider(),
                  _MenuItemRow(icon: '👛', title: 'Portefeuille'),
                  _menuDivider(),
                  _MenuItemRow(icon: '🎁', title: 'Envoyer un cadeau'),
                  _menuDivider(),
                  _MenuItemRow(icon: '💼', title: 'Préférences pro', subtitle: 'Rendez vos repas de travail plus faciles', subtitleColor: _teal),
                  _menuDivider(),
                  _MenuItemRow(icon: '❓', title: 'Aide'),
                  _menuDivider(),
                  _MenuItemRow(icon: '🏷', title: 'Promotions'),
                  _menuDivider(),
                  _MenuItemRow(icon: '🎟', title: 'DeliVip Pass', subtitle: 'Rejoignez gratuitement pendant 1 mois', subtitleColor: _teal),
                  _menuDivider(),
                  _MenuItemRow(icon: '🛵', title: 'Livrer avec DeliVip'),
                  _menuDivider(),
                  _MenuItemRow(icon: '⚙', title: 'Paramètres'),
                  const SizedBox(height: 8),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
                  const SizedBox(height: 20),

                  // Admin button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF00BFA5), Color(0xFF00897B)]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Panneau Admin', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                  Text('Gérer stores, commandes, catégories', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // À propos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('À propos', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _menuDivider() {
    return const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20, color: Color(0xFFF0F1F3));
  }
}

// ═══════════════════════════════════════════════════════════════
//  Menu Item Row Widget
// ═══════════════════════════════════════════════════════════════

class _MenuItemRow extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;

  const _MenuItemRow({required this.icon, required this.title, this.subtitle, this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          SizedBox(width: 28, child: Text(icon, style: const TextStyle(fontSize: 20))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: subtitleColor ?? Colors.grey)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
