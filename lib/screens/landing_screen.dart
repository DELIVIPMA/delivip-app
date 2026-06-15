import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/google_auth_service.dart';
import '../main.dart';

// ═══════════════════════════════════════════════════════════════════
//  LANDING SCREEN — DeliVip Connexion
// ═══════════════════════════════════════════════════════════════════

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _hasPhone = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _hasPhone = _phoneController.text.length > 8;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Section (55%) ───────────────────────────────
            Expanded(
              flex: 55,
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: Stack(
                  children: [
                    // Logo
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deli',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'Vip',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00BFA5),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Food plates
                    Center(
                      child: SizedBox(
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Bottom right: Pizza
                            Positioned(
                              bottom: 0,
                              right: 20,
                              child: _buildPlate(
                                diameter: 120,
                                emoji: '\u{1F355}',
                                bgColor: const Color(0xFFF0F0F0),
                                offsetX: 10,
                                offsetY: 10,
                              ),
                            ),
                            // Top right: Salad
                            Positioned(
                              top: 0,
                              right: 60,
                              child: _buildPlate(
                                diameter: 140,
                                emoji: '\u{1F957}',
                                bgColor: const Color(0xFFF0F0F0),
                                offsetX: -5,
                                offsetY: 5,
                              ),
                            ),
                            // Center left: Burger (largest)
                            Positioned(
                              left: 10,
                              top: 40,
                              child: _buildPlate(
                                diameter: 160,
                                emoji: '\u{1F354}',
                                bgColor: const Color(0xFFF5F5F5),
                                offsetX: 0,
                                offsetY: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Bottom Section (45%) ────────────────────────────
            Expanded(
              flex: 45,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Text(
                        'Utilisez votre compte DeliVip pour commencer',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Phone input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Country code
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  const Text('\u{1F1F2}\u{1F1E6}', style: TextStyle(fontSize: 22)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '+212',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                                ],
                              ),
                            ),
                            // Divider
                            Container(
                              width: 1.5,
                              height: 30,
                              color: const Color(0xFFE0E0E0),
                            ),
                            // Phone input
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: '06 12 34 56 78',
                                    hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Continue button
                    if (_hasPhone)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const MainShell()),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Continuer',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // OR divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'ou',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
                        ],
                      ),
                    ),
                    // Social buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildGoogleButton(),
                          const SizedBox(height: 8),
                          _buildAppleButton(),
                        ],
                      ),
                    ),
                    // Footer
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'En continuant, vous acceptez les ',
                            ),
                            TextSpan(
                              text: 'Conditions d\u2019utilisation',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF00BFA5),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text: ' de DeliVip. Consultez notre ',
                            ),
                            TextSpan(
                              text: 'Politique de confidentialit\u00E9',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF00BFA5),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ PLATE BUILDER ═════════════════════════════
  Widget _buildPlate({
    required double diameter,
    required String emoji,
    required Color bgColor,
    required double offsetX,
    required double offsetY,
  }) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Text(emoji, style: TextStyle(fontSize: diameter * 0.45)),
        ),
      ),
    );
  }

  // ═══════════════════ GOOGLE BUTTON ═════════════════════════════
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () async {
          final result = await GoogleAuthService.signIn();
          if (!mounted) return;

          if (result.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Bienvenue ${result.displayName ?? ''}'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainShell()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.errorMessage ?? 'Erreur de connexion'),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google logo officiel avec les 4 couleurs
            SizedBox(
              width: 20,
              height: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // G extérieur - bleu
                  Text(
                    'G',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4285F4),
                      letterSpacing: 0,
                      height: 1.0,
                    ),
                  ),
                  // O intérieur avec couleurs (cercle rouge/jaune/vert superposé)
                  Positioned(
                    left: 12,
                    top: 1,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA4335),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continuer avec Google',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ APPLE BUTTON ═════════════════════════════
  Widget _buildAppleButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Intégrer Apple Sign-In
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔜 Connexion Apple bientôt disponible'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Apple officiel (FontAwesome)
            const FaIcon(
              FontAwesomeIcons.apple,
              size: 22,
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Text(
              'Continuer avec Apple',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

