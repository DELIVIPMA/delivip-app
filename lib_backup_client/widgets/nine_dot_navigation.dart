import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ACTION BUTTON DATA MODEL
/// ═══════════════════════════════════════════════════════════════════
class NavAction {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const NavAction({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });
}

/// ═══════════════════════════════════════════════════════════════════
///  9-DOT NAVIGATION WIDGET
///
///  A reusable radial navigation menu. Place it inside a [Stack] to
///  cover the parent area. The center button expands 8 surrounding
///  buttons with a staggered animation.
///
///  Example usage:
///  ```dart
///  Stack(
///    children: [
///      yourContent,
///      const NineDotNavigation(actions: [...]),
///    ],
///  )
///  ```
/// ═══════════════════════════════════════════════════════════════════
class NineDotNavigation extends StatefulWidget {
  /// The 8 actions to display around the center button.
  final List<NavAction> actions;

  /// Icon for the center button when collapsed.
  final IconData centerIcon;

  /// Icon shown when the menu is open (e.g. close icon).
  final IconData centerOpenIcon;

  /// Foreground (icon) color of the center button.
  final Color centerIconColor;

  /// Radius of the circle where surrounding buttons are placed.
  final double spreadRadius;

  /// Diameter of each surrounding button.
  final double buttonSize;

  /// Duration of the expand/collapse animation.
  final Duration animationDuration;

  /// The curve to use for the expansion animation.
  final Curve animationCurve;

  /// Whether to show labels next to surrounding buttons.
  final bool showLabels;

  /// The style for the labels.
  final TextStyle? labelStyle;

  /// A semi-transparent overlay behind the menu when expanded.
  final bool showOverlay;

  /// Color of the overlay.
  final Color? overlayColor;

  /// Alignment of the center button within the available space.
  /// Use [Alignment.bottomRight] for a FAB-style placement.
  final Alignment centerAlignment;

  /// Padding around the outer edge of the expanding circle.
  final EdgeInsets margin;

  const NineDotNavigation({
    super.key,
    required this.actions,
    this.centerIcon = Icons.grid_view_rounded,
    this.centerOpenIcon = Icons.close,
    this.centerIconColor = Colors.white,
    this.spreadRadius = 120.0,
    this.buttonSize = 54.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutBack,
    this.showLabels = true,
    this.labelStyle,
    this.showOverlay = true,
    this.overlayColor,
    this.centerAlignment = Alignment.center,
    this.margin = EdgeInsets.zero,
  }) : assert(
         actions.length <= 8,
         'NineDotNavigation supports at most 8 actions.',
       );

  @override
  State<NineDotNavigation> createState() => _NineDotNavigationState();
}

class _NineDotNavigationState extends State<NineDotNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _overlayAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggle the menu open/closed.
  void toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  /// Close the menu programmatically.
  void close() {
    if (_isOpen) {
      setState(() => _isOpen = false);
      _controller.reverse();
    }
  }

  /// Handle a surrounding button tap.
  void _onActionTap(int index, NavAction action) {
    close();
    // Tiny delay so the close animation starts before navigation
    Future.delayed(const Duration(milliseconds: 50), action.onTap);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ═══ OVERLAY ═══
        if (widget.showOverlay)
          FadeTransition(
            opacity: _overlayAnimation,
            child: GestureDetector(
              onTap: close,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color:
                    widget.overlayColor ??
                    (isDark
                        ? Colors.black.withValues(alpha: 0.45)
                        : Colors.black.withValues(alpha: 0.25)),
              ),
            ),
          ),

        // ═══ SURROUNDING BUTTONS ═══
        for (int i = 0; i < widget.actions.length; i++)
          _buildExpandingButton(i, widget.actions[i]),

        // ═══ CENTER BUTTON ═══
        Align(
          alignment: widget.centerAlignment,
          child: Padding(padding: widget.margin, child: _buildCenterButton()),
        ),
      ],
    );
  }

  /// ═══════════════════════════════════════════════════════════════
  ///  CENTER BUTTON — Toggles the menu
  /// ═══════════════════════════════════════════════════════════════
  Widget _buildCenterButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rotation = Tween<double>(begin: 0.0, end: math.pi / 4).evaluate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

        return GestureDetector(
          onTap: toggle,
          child: Container(
            width: widget.buttonSize + 10,
            height: widget.buttonSize + 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryCyan, Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: rotation,
              child: Icon(
                _isOpen ? widget.centerOpenIcon : widget.centerIcon,
                color: widget.centerIconColor,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ═══════════════════════════════════════════════════════════════
  ///  EXPANDING BUTTON — Individually animated
  /// ═══════════════════════════════════════════════════════════════
  Widget _buildExpandingButton(int index, NavAction action) {
    // 8 positions evenly spaced at 45° intervals, starting at top (-90°)
    final angleStep = (2 * math.pi) / 8;
    final angle = -math.pi / 2 + index * angleStep;

    final double finalDx = widget.spreadRadius * math.cos(angle);
    final double finalDy = widget.spreadRadius * math.sin(angle);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Staggered delay: each button appears progressively
        final staggerDelay = index * 0.04;
        final localAnim = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            staggerDelay,
            staggerDelay + 0.7,
            curve: Curves.easeOut,
          ),
        );

        // Interpolated offset (0,0 → finalDx, finalDy)
        final dx = finalDx * localAnim.value;
        final dy = finalDy * localAnim.value;

        // Opacity + scale
        final opacity = localAnim.value.clamp(0.0, 1.0);
        final scale = 0.3 + (0.7 * localAnim.value);

        return Align(
          alignment: widget.centerAlignment,
          child: Padding(
            padding: widget.margin,
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: _buildActionButton(action),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ═══════════════════════════════════════════════════════════════
  ///  SINGLE ACTION BUTTON
  /// ═══════════════════════════════════════════════════════════════
  Widget _buildActionButton(NavAction action) {
    final actionColor = action.color ?? AppTheme.primaryCyan;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Circular button ──
        GestureDetector(
          onTap: () => _onActionTap(widget.actions.indexOf(action), action),
          child: Container(
            width: widget.buttonSize,
            height: widget.buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: actionColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: actionColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              action.icon,
              color: actionColor,
              size: widget.buttonSize * 0.5,
            ),
          ),
        ),

        // ── Label ──
        if (widget.showLabels) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Text(
              action.label,
              style:
                  widget.labelStyle ??
                  TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                    letterSpacing: 0.2,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
