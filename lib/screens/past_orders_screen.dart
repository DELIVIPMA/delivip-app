import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  PAST ORDERS SCREEN — DeliVip Commandes passées
// ═══════════════════════════════════════════════════════════════════

class PastOrdersScreen extends StatefulWidget {
  const PastOrdersScreen({super.key});

  @override
  State<PastOrdersScreen> createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  int _selectedTab = 2; // 0=À la une, 1=Catégories, 2=Commandes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),
            // ── Search Bar ──────────────────────────────────────
            _buildSearchBar(),
            // ── Info Row ────────────────────────────────────────
            _buildInfoRow(),
            // ── Tab Bar ─────────────────────────────────────────
            _buildTabBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
            // ── Empty State ─────────────────────────────────────
            Expanded(
              child: _buildEmptyState(),
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
          Expanded(
            child: Text(
              'Marjane Express',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 24, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 24, color: Colors.black),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ SEARCH BAR ════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.search, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Rechercher produits et magasins...',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════ INFO ROW ══════════════════════════════════
  Widget _buildInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'En 60 minutes',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
          const Spacer(),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'DH',
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Prix et frais',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ TAB BAR ═══════════════════════════════════
  Widget _buildTabBar() {
    final tabs = ['\u00C0 la une', 'Cat\u00E9gories', 'Commandes'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabs[i],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════ EMPTY STATE ═══════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Aucune commande r\u00E9cente',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Vos commandes r\u00E9centes appara\u00EEtront ici.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF888888),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
