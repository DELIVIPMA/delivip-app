import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
//  RESPONSIVE HELPER — Universal sizing for DeliVIP
//  Use everywhere to ensure pixel-perfect layouts across all devices.
// ═══════════════════════════════════════════════════════════════════

class ResponsiveHelper {
  /// Tablet / iPad breakpoint (≥ 600px logical width)
  static const double tabletBreakpoint = 600;

  /// Desktop breakpoint (≥ 1024px logical width)
  static const double desktopBreakpoint = 1024;

  /// Max width for containers on large screens (floating card look)
  static const double maxContainerWidth = 600;

  // ─── Screen size info ─────────────────────────────────

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tabletBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= tabletBreakpoint && w < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Returns true for iPad / large Android tablets
  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  // ─── Scale factor for typography ──────────────────────

  /// Scale font size smoothly between phone and tablet
  /// Base size is for phone; tablet gets up to [tabletScale] × bigger.
  static double fontSize(
    BuildContext context,
    double phoneSize, {
    double tabletScale = 1.15,
  }) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return phoneSize;
    // Clamp so it doesn't grow comically huge
    final scale = (w / tabletBreakpoint).clamp(1.0, tabletScale);
    return phoneSize * scale;
  }

  // ─── Dynamic spacing scale ──────────────────────────

  /// Returns a responsive horizontal padding based on screen width.
  /// Phones: 16-18px, Tablets/iPad: larger scaled padding
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 16.0;
    return (w * 0.05).clamp(24.0, 48.0);
  }

  /// Returns a responsive vertical spacing value
  static double verticalSpacing(BuildContext context, {double base = 8.0}) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return base;
    return base * (w / tabletBreakpoint).clamp(1.0, 1.5);
  }

  /// Returns a scalable edge insets based on screen width
  static EdgeInsets screenPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final horizontal = w < tabletBreakpoint
        ? 16.0
        : (w * 0.05).clamp(24.0, 48.0);
    final vertical = w < tabletBreakpoint ? 10.0 : (h * 0.02).clamp(16.0, 32.0);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  // ─── Container width constraints ──────────────────────

  /// On tablets, wrap UI in a centered container with [maxContainerWidth].
  /// Returns `null` for phones (use full width).
  static double? maxWidth(BuildContext context) {
    if (isLargeScreen(context)) return maxContainerWidth;
    return null;
  }

  /// Wrap a widget in a centered, width‑constrained container on large screens.
  static Widget constrainWidth(BuildContext context, Widget child) {
    if (!isLargeScreen(context)) return child;
    return Center(
      child: SizedBox(width: maxContainerWidth, child: child),
    );
  }

  /// Wrap child in a centered container if tablet+, otherwise return as‑is.
  static Widget wrapIfTablet(BuildContext context, Widget child) {
    if (!isLargeScreen(context)) return child;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContainerWidth),
        child: child,
      ),
    );
  }

  /// Wraps a Sliver in tablet mode with centered maxWidth constraint.
  /// For use inside CustomScrollView sliver lists.
  static Widget sliverConstrainWidth(BuildContext context, Widget sliverChild) {
    if (!isLargeScreen(context)) return sliverChild;
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.05,
      ),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: SizedBox(width: maxContainerWidth, child: sliverChild),
        ),
      ),
    );
  }

  // ─── Dynamic grid cross-axis count ───────────────────

  /// Returns optimal number of grid columns based on screen width.
  /// - Phones: 2 columns
  /// - Small tablets: 3 columns
  /// - Large tablets / iPad: 4 columns
  static int gridColumnCount(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 2;
    if (w < desktopBreakpoint) return 3;
    return 4;
  }

  /// Returns optimal grid child aspect ratio (inverse of width/height)
  static double gridAspectRatio(BuildContext context) {
    if (isLargeScreen(context)) return 1.4;
    return 1.3;
  }

  // ─── Responsive values ────────────────────────────────

  /// Returns a value scaled by screen width ratio to a reference (375 = iPhone)
  static double scale(BuildContext context, double value) {
    final w = MediaQuery.sizeOf(context).width;
    return value * (w / 375).clamp(0.8, 1.6);
  }

  // ─── Bottom nav bar specific ──────────────────────────

  /// Safe bottom padding that accounts for both system nav and iOS home indicator
  static EdgeInsets bottomNavPadding(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return EdgeInsets.only(
      left: isLargeScreen(context) ? 48 : 16,
      right: isLargeScreen(context) ? 48 : 16,
      bottom: bottomInset > 0 ? bottomInset : 14,
    );
  }

  // ─── Text form field sizing ──────────────────────────

  /// Scaled vertical padding for buttons / form fields
  static double fieldHeight(BuildContext context) {
    if (isLargeScreen(context)) return 56.0;
    return 48.0;
  }

  // ─── Dynamic list item sizing ────────────────────────

  /// Returns a scaled card height based on screen
  static double cardHeight(BuildContext context, {double phoneHeight = 88}) {
    if (isLargeScreen(context)) return phoneHeight * 1.2;
    return phoneHeight;
  }

  /// Returns a scaled image height for hero sections
  static double heroImageHeight(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 160.0;
    return 220.0;
  }

  /// Returns expanded height for SliverAppBar
  static double sliverAppBarHeight(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 240.0;
    return 300.0;
  }

  /// Returns responsive horizontal card width for horizontal ListView
  static double horizontalCardWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 156.0;
    return 200.0;
  }

  /// Returns responsive card height for horizontal ListView
  static double horizontalCardHeight(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < tabletBreakpoint) return 180.0;
    return 220.0;
  }
}
