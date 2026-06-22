import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

// ═══════════════════════════════════════════════════════════════════
//  ORDER TRACKING SCREEN — "Suivi de commande" (Uber Eats / Glovo Style)
//  Pure Light Mode | White backgrounds | Success + Timeline
// ═══════════════════════════════════════════════════════════════════

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  // ─── Timeline steps ────────────────────────────────
  final List<_TimelineStep> _steps = const [
    _TimelineStep(
      icon: Icons.check_circle_rounded,
      label: 'Commande acceptée',
      subtitle: 'Le restaurant a reçu votre commande',
      isActive: true,
    ),
    _TimelineStep(
      icon: Icons.restaurant_rounded,
      label: 'En cours de préparation',
      subtitle: 'Votre commande est en train d\'être préparée',
      isActive: true,
    ),
    _TimelineStep(
      icon: Icons.delivery_dining_rounded,
      label: 'En route vers vous',
      subtitle: 'Le livreur a quitté le restaurant',
      isActive: false,
    ),
    _TimelineStep(
      icon: Icons.home_rounded,
      label: 'Livrée',
      subtitle: 'Bon appétit !',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildSuccessHeader(),
                _buildThinDivider(),
                const SizedBox(height: 16),
                _buildTimelineSection(),
              ],
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: _dark, size: 24),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  // ─── THIN DIVIDER ────────────────────────────────────
  Widget _buildThinDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 0,
      endIndent: 0,
    );
  }

  // ─── SUCCESS HEADER ──────────────────────────────────
  Widget _buildSuccessHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          // Large check icon
          Icon(Icons.check_circle, color: _teal, size: 80),
          const SizedBox(height: 20),

          // Title
          Text(
            'Commande Confirmée !',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Estimated delivery time
          Text(
            'Arrivée estimée : 20-30 min',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ─── TIMELINE SECTION ────────────────────────────────
  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 20),
            child: Text(
              'Suivi de commande',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
          ),

          // Timeline items
          ...List.generate(_steps.length, (index) {
            final step = _steps[index];
            final isLast = index == _steps.length - 1;
            return _buildTimelineItem(step, isLast: isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TimelineStep step, {bool isLast = false}) {
    final activeColor = step.isActive ? _teal : Colors.grey.shade400;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon column with connecting line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: step.isActive
                        ? _teal.withOpacity(0.1)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(step.icon, color: activeColor, size: 18),
                ),
                // Vertical connector line (skip for last item)
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: step.isActive ? _teal : Colors.grey.shade300,
                  ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Label & subtitle
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    step.label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: step.isActive ? _dark : Colors.grey[500],
                    ),
                  ),
                  if (step.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM BUTTON ────────────────────────────────────
  Widget _buildBottomButton(BuildContext context) {
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
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Retour à l\'accueil',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  TIMELINE STEP MODEL
// ═══════════════════════════════════════════════════════════════════

class _TimelineStep {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isActive;

  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isActive,
  });
}
