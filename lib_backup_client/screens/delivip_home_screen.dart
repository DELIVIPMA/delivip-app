import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  WIDGET D'ANIMATION STAGGERED (ENTRÉE EN CASCADE)
// ═══════════════════════════════════════════════════════════════════
class _StaggeredCardAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final AnimationController controller;

  const _StaggeredCardAnimation({
    required this.child,
    required this.index,
    required this.controller,
  });

  @override
  State<_StaggeredCardAnimation> createState() =>
      _StaggeredCardAnimationState();
}

class _StaggeredCardAnimationState extends State<_StaggeredCardAnimation> {
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    final delay = widget.index * 0.12; // 0.0, 0.12, 0.24, 0.36, ...

    _fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: Interval(delay, delay + 0.6, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CARTE GLASSMORPHISM
// ═══════════════════════════════════════════════════════════════════
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const _GlassCard({required this.child, this.height, this.padding})
    : margin = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  ÉCRAN D'ACCUEIL DELIVIP — REFONTE PREMIUM
// ═══════════════════════════════════════════════════════════════════
class DeliVIPHomeScreen extends StatefulWidget {
  const DeliVIPHomeScreen({super.key});

  @override
  State<DeliVIPHomeScreen> createState() => _DeliVIPHomeScreenState();
}

class _DeliVIPHomeScreenState extends State<DeliVIPHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Color _turquoise = Color(0xFF00BFA5);
  static const Color _darkNavy = Color(0xFF1A1A2E);
  static const Color _accentYellow = Color(0xFFFFC107);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          // ── DÉCORATIONS DE FOND (cercles flous) ──
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _turquoise.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentYellow.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _turquoise.withValues(alpha: 0.08),
              ),
            ),
          ),

          // ── CONTENU PRINCIPAL ──
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ═══ 1. HEADER MINIMALISTE ═══
                  _buildHeader(),

                  const SizedBox(height: 12),

                  // ═══ 2. BENTO GRID PREMIUM ═══
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Découvrir',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _darkNavy,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Explorez nos services exclusifs',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── BENTO GRID ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Colonne gauche : Restaurants (grande)
                            Expanded(
                              flex: 5,
                              child: _StaggeredCardAnimation(
                                index: 0,
                                controller: _controller,
                                child: _GlassCard(
                                  height: 260,
                                  padding: const EdgeInsets.all(20),
                                  child: _buildLargeCard(
                                    icon: Icons.restaurant_outlined,
                                    title: 'Restaurants',
                                    subtitle:
                                        'Découvrez les meilleurs plats\nlivrés chez vous',
                                    tags: ['Populaire', '-25%'],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Colonne droite : Épiceries + Boutiques
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _StaggeredCardAnimation(
                                    index: 1,
                                    controller: _controller,
                                    child: _GlassCard(
                                      height: 120,
                                      padding: const EdgeInsets.all(16),
                                      child: _buildSmallCard(
                                        icon:
                                            Icons.local_grocery_store_outlined,
                                        title: 'Épiceries',
                                        subtitle: 'Courses\nrapides',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _StaggeredCardAnimation(
                                    index: 2,
                                    controller: _controller,
                                    child: _GlassCard(
                                      height: 126,
                                      padding: const EdgeInsets.all(16),
                                      child: _buildSmallCard(
                                        icon: Icons.shopping_bag_outlined,
                                        title: 'Boutiques',
                                        subtitle: 'Shopping\ntendance',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ── CARTE COURSIER (pleine largeur) ──
                        _StaggeredCardAnimation(
                          index: 3,
                          controller: _controller,
                          child: _GlassCard(
                            padding: const EdgeInsets.all(18),
                            child: _buildCoursierCard(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── PROMO BANNER ──
                        _StaggeredCardAnimation(
                          index: 4,
                          controller: _controller,
                          child: _buildPromoBanner(),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ═══ 3. BOTTOM NAV BAR ═══
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  HEADER
  // ──────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: _turquoise,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: _turquoise.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ligne supérieure : Logo + Localisation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'DeliVIP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: _accentYellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Agadir',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Barre de recherche
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un service...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  GRANDE CARTE (Restaurants)
  // ──────────────────────────────────────────────────────────────
  Widget _buildLargeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> tags,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        Wrap(
          spacing: 6,
          children: tags.map((tag) {
            final isPopular = tag == 'Populaire';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isPopular
                    ? const Color(0xFFFF6B6B).withValues(alpha: 0.15)
                    : _turquoise.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isPopular ? const Color(0xFFFF6B6B) : _turquoise,
                  letterSpacing: 0.3,
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        // Icône Line Art
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _turquoise.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: _turquoise, size: 28),
        ),
        const SizedBox(height: 14),
        // Texte
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkNavy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey.shade500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  PETITE CARTE (Épiceries, Boutiques)
  // ──────────────────────────────────────────────────────────────
  Widget _buildSmallCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _turquoise.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _turquoise, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _darkNavy,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  CARTE COURSIER
  // ──────────────────────────────────────────────────────────────
  Widget _buildCoursierCard() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.delivery_dining_outlined,
            color: Color(0xFFFFC107),
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Coursier',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _darkNavy,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Envoyez ou recevez un colis en un clic',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _turquoise.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Voir',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _turquoise,
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  BANNIÈRE PROMO
  // ──────────────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _turquoise.withValues(alpha: 0.08),
            const Color(0xFFFFC107).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _turquoise.withValues(alpha: 0.12), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _turquoise.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on_rounded,
              color: _turquoise,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fort afflux à Agadir',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _darkNavy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Nos livreurs VIP sont mobilisés ✨',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  BOTTOM NAVIGATION
  // ──────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: _turquoise,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: 'Explorer',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: 'Commandes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Compte',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
