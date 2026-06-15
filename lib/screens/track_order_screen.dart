import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  TRACK ORDER SCREEN — DeliVip Suivi de livraison
// ═══════════════════════════════════════════════════════════════════

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  bool _showItemDetails = false;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status section
                    _buildStatusSection(),
                    // Animation card
                    _buildAnimationCard(),
                    // Drag handle below card
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Livraison details
                    _buildDeliveryDetailsSection(),
                    // Share row
                    _buildShareRow(),
                    // Order summary
                    _buildOrderSummarySection(),
                    // Invite friends
                    _buildInviteFriendsRow(),
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

  // ═══════════════════ TOP BAR ═══════════════════════════════════
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 22, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.ios_share, size: 22, color: Colors.black),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Aide',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════ STATUS SECTION ════════════════════════════
  Widget _buildStatusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pr\u00E9paration de votre commande\u2026',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
              children: [
                const TextSpan(text: 'Arriv\u00E9e pr\u00E9vue \u00E0  '),
                TextSpan(
                  text: '10:15',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Progress bar (5 segments)
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index < 2;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF00BFA5) : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF888888)),
              const SizedBox(width: 4),
              Text(
                'Arriv\u00E9e au plus tard \u00E0 10:40',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF888888)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════ ANIMATION CARD ════════════════════════════
  Widget _buildAnimationCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Steam dots (top)
            Positioned(
              top: 30,
              child: Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            // Cooking emoji
            const Text('\u{1F373}', style: TextStyle(fontSize: 80)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ DELIVERY DETAILS ══════════════════════════
  Widget _buildDeliveryDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Text(
            'D\u00E9tails de livraison',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        _buildDetailRow('Adresse', 'Agadir Marina, Agadir, Maroc'),
        _buildDetailRow('Type', 'D\u00E9poser \u00E0 la porte'),
        _buildDetailRow(
          'Instructions',
          'Veuillez sonner pour m\'avertir de l\'arriv\u00E9e puis laisser la commande devant la porte',
        ),
        _buildDetailRow('Service', 'Standard'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF888888)),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
      ],
    );
  }

  // ═══════════════════ SHARE ROW ═════════════════════════════════
  Widget _buildShareRow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partager cette livraison',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Permettre \u00E0 quelqu\u2019un de suivre',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ios_share, size: 16, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      'Partager',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
      ],
    );
  }

  // ═══════════════════ ORDER SUMMARY ═════════════════════════════
  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\u00E9sum\u00E9 de commande',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'voir le re\u00E7u',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF00BFA5)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Pizza Roma, Agadir Marina',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
          ),
        ),
        // Order item
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poulet Crispy',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showItemDetails = !_showItemDetails),
                          child: Row(
                            children: [
                              Text(
                                'Voir plus',
                                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                              ),
                              Icon(
                                _showItemDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 16,
                                color: const Color(0xFF00BFA5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_showItemDetails) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    '6 ailes \u2022 Sauce ranch',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
        // Total row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
              ),
              Text(
                '65.00 DH',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),
      ],
    );
  }

  // ═══════════════════ INVITE FRIENDS ════════════════════════════
  Widget _buildInviteFriendsRow() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const Text('\u{1F354}', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Invitez un ami, obtenez 25 DH de r\u00E9duction',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00BFA5),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
