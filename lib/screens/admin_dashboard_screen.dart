import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADMIN DASHBOARD SCREEN — DeliVip Backoffice (style startup)
// ═══════════════════════════════════════════════════════════════════

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    // Revenue Chart Card
                    _buildRevenueCard(),
                    const SizedBox(height: 16),
                    // Recent Orders / Activity
                    _buildRecentOrdersSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFEBEDF0), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: DeliVipColors.headerGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('DV', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Text('Admin DeliVip', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_outlined, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: DeliVipColors.teal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('A', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: DeliVipColors.teal)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      _StatCard(icon: Icons.shopping_bag_outlined, label: 'Commandes', value: '1,284', change: '+12%', color: DeliVipColors.teal),
      _StatCard(icon: Icons.trending_up_rounded, label: 'Revenus', value: '48.2K DH', change: '+23%', color: DeliVipColors.gold),
      _StatCard(icon: Icons.people_outline, label: 'Clients', value: '892', change: '+8%', color: DeliVipColors.purple),
      _StatCard(icon: Icons.store_outlined, label: 'Restaurants', value: '64', change: '+4', color: const Color(0xFFE65100)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: stats,
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Revenus du jour', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DeliVipColors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('+23%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: DeliVipColors.teal)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('3,420 DH', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black)),
            const SizedBox(height: 16),
            // Mini bar chart
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar(30, const Color(0xFF00BFA5)),
                _bar(45, const Color(0xFF00BFA5)),
                _bar(25, const Color(0xFF00BFA5)),
                _bar(60, const Color(0xFF00BFA5)),
                _bar(40, const Color(0xFF00BFA5)),
                _bar(75, const Color(0xFF00BFA5)),
                _bar(55, const Color(0xFF00BFA5)),
                _bar(35, const Color(0xFF00BFA5)),
                _bar(80, const Color(0xFF009688)),
                _bar(65, const Color(0xFF009688)),
                _bar(50, const Color(0xFF00BFA5)),
                _bar(70, const Color(0xFF00BFA5)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lun', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Mar', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Mer', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Jeu', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Ven', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Sam', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Dim', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Lun', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Mar', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Mer', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Jeu', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                Text('Ven', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double heightPercent, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60 * (heightPercent / 100),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    final orders = [
      {'id': '#1245', 'restaurant': 'Burger Palace', 'client': 'Ahmed B.', 'total': '85 DH', 'status': 'En cours', 'time': 'Il y a 5min'},
      {'id': '#1244', 'restaurant': 'Pizza Roma', 'client': 'Sara M.', 'total': '120 DH', 'status': 'Prête', 'time': 'Il y a 12min'},
      {'id': '#1243', 'restaurant': 'Sushi Shop', 'client': 'Omar K.', 'total': '95 DH', 'status': 'Livrée', 'time': 'Il y a 35min'},
      {'id': '#1242', 'restaurant': 'Taco House', 'client': 'Imane R.', 'total': '65 DH', 'status': 'Livrée', 'time': 'Il y a 1h'},
      {'id': '#1241', 'restaurant': 'Green Bowl', 'client': 'Youssef A.', 'total': '110 DH', 'status': 'Annulée', 'time': 'Il y a 2h'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dernières commandes', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
              TextButton(
                onPressed: () {},
                child: Text('Voir tout →', style: GoogleFonts.inter(fontSize: 13, color: DeliVipColors.teal, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: orders.map((o) => _buildOrderRow(o)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(Map<String, String> order) {
    Color statusColor;
    switch (order['status']) {
      case 'En cours':
        statusColor = const Color(0xFFFFA000);
        break;
      case 'Prête':
        statusColor = DeliVipColors.teal;
        break;
      case 'Livrée':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'Annulée':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFF0F0F0), width: 1)),
      ),
      child: Row(
        children: [
          Text(order['id']!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(order['restaurant']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text(order['client']!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
          ),
          Text(order['total']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(order['status']!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STAT CARD
// ═══════════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(change, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
