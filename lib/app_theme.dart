import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════
//  DELIVIP APP THEME — Premium Brand Identity (Teal)
// ═══════════════════════════════════════════════════════

class AppTheme {
  AppTheme._();

  /// Base font scale factor (phone = 1.0, tablet = ~1.15)
  static double _fontScale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 900) return 1.20;
    if (width > 600) return 1.12;
    return 1.0;
  }

  /// Responsive font size: baseSize is the phone size, scales up on tablet
  static double fontSize(BuildContext context, double baseSize) {
    return baseSize * _fontScale(context);
  }

  // ─── Premium Brand Colors ──────────────────────────
  /// Primary brand color — DeliVIP Teal
  static const Color primaryTeal = Color(0xFF39BCA8);
  static const Color primaryTealLight = Color(0xFF6ED4C2);
  static const Color darkCharcoal = Color(0xFF1E1E24);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFB0B0B5);
  static const Color cardShadow = Color(0x1A000000);
  static const Color starGold = Color(0xFFFFC107);

  /// Backward-compatible alias for convenience
  static Color get primaryOrange => primaryTeal;
  static Color get primaryOrangeLight => primaryTealLight;

  // ─── Premium Shadows ───────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get raisedShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ─── Typography ────────────────────────────────────
  /// Helper: applies [fn] with responsive font scaling
  static TextStyle _res(TextStyle style, BuildContext context) {
    return style.copyWith(fontSize: fontSize(context, style.fontSize ?? 14));
  }

  /// Get responsive heading for given context
  static TextStyle headingOf(BuildContext context) => _res(heading, context);
  static TextStyle subheadingOf(BuildContext context) =>
      _res(subheading, context);

  static TextStyle get heading => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: darkCharcoal,
    letterSpacing: -0.3,
  );

  static TextStyle get subheading => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkCharcoal,
  );

  static TextStyle get bodyText => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: textTertiary,
  );

  static TextStyle get priceText => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: primaryTeal,
  );

  // ─── ThemeData ─────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: pureWhite,
      fontFamily: GoogleFonts.poppins().fontFamily,

      colorScheme: const ColorScheme.light(
        primary: primaryTeal,
        secondary: darkCharcoal,
        surface: pureWhite,
        onPrimary: pureWhite,
        onSecondary: pureWhite,
        onSurface: darkCharcoal,
      ),

      // ─── Elevated Button ─────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: pureWhite,
          iconColor: pureWhite,
          elevation: 2,
          shadowColor: primaryTeal.withValues(alpha: 0.3),
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ─── Text Button ─────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTeal,
          iconColor: primaryTeal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  DARK THEME — Deep Midnight with Teal Accents
  // ═══════════════════════════════════════════════════════════

  /// Deep dark background (Material 3 default dark surface)
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF2C2C2E);
  static const Color darkTextPrimary = Color(0xFFF5F5F7);
  static const Color darkTextSecondary = Color(0xFFA8A8AD);
  static const Color darkTextTertiary = Color(0xFF7C7C82);

  /// Premium dark glass overlay (for the bottom nav bar etc.)
  static Color get darkGlassColor => Colors.white.withValues(alpha: 0.08);
  static Color get darkGlassBorder => Colors.white.withValues(alpha: 0.15);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      fontFamily: GoogleFonts.poppins().fontFamily,

      colorScheme: const ColorScheme.dark(
        primary: primaryTeal,
        secondary: Color(0xFF6ED4C2),
        surface: darkSurface,
        onPrimary: Color(0xFF00332C),
        onSecondary: Color(0xFF00332C),
        onSurface: darkTextPrimary,
      ),

      // ─── Elevated Button ─────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: pureWhite,
          iconColor: pureWhite,
          elevation: 2,
          shadowColor: primaryTeal.withValues(alpha: 0.3),
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ─── Text Button ─────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTeal,
          iconColor: primaryTeal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Card Theme ──────────────────────────────
      cardTheme: CardThemeData(
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ─── AppBar Theme ────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
