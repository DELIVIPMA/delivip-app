import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════
//  GLASS CONTAINER — Premium Glassmorphism with Real Blur
//  Frosted glass over clean dark surface.
// ═══════════════════════════════════════════════════════

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double blurIntensity;
  final double opacity;
  final Color? tintColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Clip? clipBehavior;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurIntensity = 15,
    this.opacity = 0.04,
    this.tintColor,
    this.boxShadow,
    this.border,
    this.width,
    this.height,
    this.onTap,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTint = tintColor ?? Colors.white;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final effectiveShadow =
        boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

    final borderToUse =
        border ??
        Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1.2);

    final container = ClipRRect(
      borderRadius: effectiveRadius,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          width: width,
          height: height,
          padding: effectivePadding,
          margin: margin,
          decoration: BoxDecoration(
            color: effectiveTint.withValues(alpha: opacity),
            borderRadius: effectiveRadius,
            border: borderToUse,
            boxShadow: effectiveShadow,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
