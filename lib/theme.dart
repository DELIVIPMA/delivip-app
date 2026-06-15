import 'package:flutter/material.dart';

// ─── BRAND COLORS 2025/2026 ─────────────────────────
// #00BFA5 (teal), #3D2C8D (deep purple), #F5C518 (gold)

class DeliVipColors {
  // Brand
  static const Color teal = Color(0xFF00BFA5);
  static const Color tealLight = Color(0xFF64FFDA);
  static const Color tealDark = Color(0xFF00897B);
  static const Color purple = Color(0xFF3D2C8D);
  static const Color purpleLight = Color(0xFF7C4DFF);
  static const Color purpleDark = Color(0xFF2A1B5E);
  static const Color gold = Color(0xFFF5C518);
  static const Color goldLight = Color(0xFFFFD54F);

  // Modern surfaces
  static const Color surface = Color(0xFFF7F8FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEBEDF0);
  static const Color borderLight = Color(0xFFF0F1F3);

  // Text
  static const Color textPrimary = Color(0xFF1A1D21);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Modern gradients
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment(0.0, -1.0),
    end: Alignment(0.0, 1.0),
    colors: [teal, tealDark],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, purpleDark],
  );

  static const LinearGradient goldAccent = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gold, goldLight],
  );

  static const LinearGradient tealToPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, Color(0xFF2E7D6F), purple],
  );
}

// ─── MODERN SHADOWS 2025 ────────────────────────────
class DeliVipShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const glass = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const elevated = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];
}

// ─── MODERN DECORATIONS ─────────────────────────────
class DeliVipDecoration {
  static BoxDecoration get glassCard => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: DeliVipColors.border),
    boxShadow: DeliVipShadows.soft,
  );

  static BoxDecoration get elevatedCard => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: DeliVipShadows.medium,
  );

  static BoxDecoration get categoryCircle => BoxDecoration(
    color: Color(0xFFF5F7FA),
    borderRadius: BorderRadius.circular(16),
    boxShadow: DeliVipShadows.soft,
  );
}
