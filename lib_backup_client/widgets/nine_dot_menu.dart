import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ═══════════════════════════════════════════════════════════════════
///  NavAction — Data model for a single menu item
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
///  NineDotMenu — A reusable radial navigation menu widget
///
///  Place inside a [Stack] to overlay the screen. The center button
///  expands 8 surrounding buttons in a circular pattern with staggered
///  animations. Dark-theme friendly.
///
///  Example:
///  ```dart
///  Stack(
///    children: [
///      // Your main content
///      const NineDotMenu(
///        actions: [
///          NavAction(icon: Icons.home, label: 'Home', onTap: () {}),
///          // ... up to 8 actions
///        ],
///      ),
///    ],
///  )
///  ```
/// ═══════════════════════════════════════════════════════════════════
class NineDotMenu extends StatefulWidget {
  /// List of 1–8 actions to show as surrounding buttons.
  final List<NavAction> actions;

  /// Icon when collapsed.
  final IconData centerIcon;

  /// Icon when expanded.
  final IconData centerOpenIcon;

  /// Radius of the circle where buttons are placed (in logical pixels).
  final double spreadRadius;

  /// Diameter of each surrounding button.
  final double buttonSize;

  /// Duration of the expand / collapse tween.
  final Duration animationDuration;

  /// Whether to show labels beneath each button.
  final bool showLabels;

  /// Whether to show a semi-transparent overlay behind the menu.
  final bool showOverlay;

  /// Alignment of the center button (default: bottom-right).
  final Alignment centerAlignment;

  /// Outer margin around the expanding circle.
  final EdgeInsets margin;

  const NineDotMenu({
    super.key,
    required this.actions,
    this.centerIcon = Icons.grid_view_rounded,
    this.centerOpenIcon = Icons.close,
    this.spreadRadius = 120.0,
    this.buttonSize = 54.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.showLabels = true,
    this.showOverlay = true,
    this.centerAlignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.only(right: 20, bottom: 20),
  }) : assert(
         actions.length >= 1 && actions.length <= 8,
         'NineDotMenu supports 1 to 8 actions.',
       );

  @override
  State<NineDotMenu> createState() => _NineDotMenuState();
}

class _NineDotMenuState extends State<NineDotMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final CurvedAnimation _overlayAnim;
  late final List<_ButtonAnimData> _buttonAnims;
  bool _open = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _overlayAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    // Pre‑compute each button's staggered animation data.
    _buttonAnims = List.generate(widget.actions.length, (i) {
      final angle = -math.pi / 2 + i * (2 * math.pi) / 8;
      return _ButtonAnimData(
        dx: widget.spreadRadius * math.cos(angle),
        dy: widget.spreadRadius * math.sin(angle),
        anim: CurvedAnimation(
          parent: _ctrl,
          curve: Interval(i * 0.04, (i * 0.04 + 0.7).clamp(0.0, 1.0)),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (final ba in _buttonAnims) {
      ba.anim.dispose();
    }
    _overlayAnim.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      _open ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  void _close() {
    if (_open) {
      setState(() => _open = false);
      _ctrl.reverse();
    }
  }

  void _onActionTap(int index, NavAction action) {
    _close();
    Future.delayed(const Duration(milliseconds: 60), action.onTap);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Overlay ──
        if (widget.showOverlay)
          FadeTransition(
            opacity: _overlayAnim,
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),

        // ── Expanding buttons ──
        for (int i = 0; i < widget.actions.length; i++)
          _buildExpandingButton(i),

        // ── Center button ──
        Align(
          alignment: widget.centerAlignment,
          child: Padding(padding: widget.margin, child: _buildCenter()),
        ),
      ],
    );
  }

  /// ─── Center toggle button ──────────────────────────────────────
  Widget _buildCenter() {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final rotation = Tween<double>(
          begin: 0.0,
          end: math.pi / 4,
        ).evaluate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

        return GestureDetector(
          onTap: _toggle,
          child: Container(
            width: widget.buttonSize + 10,
            height: widget.buttonSize + 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryCyan, Color(0xFF00796B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: rotation,
              child: Icon(
                _open ? widget.centerOpenIcon : widget.centerIcon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ─── One expanding button ─────────────────────────────────────
  Widget _buildExpandingButton(int index) {
    final ba = _buttonAnims[index];
    final action = widget.actions[index];
    final actionColor = action.color ?? AppTheme.primaryCyan;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = ba.anim.value; // 0..1 with stagger
        final dx = ba.dx * t;
        final dy = ba.dy * t;
        final opacity = t.clamp(0.0, 1.0);
        final scale = 0.3 + 0.7 * t;

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Button ──
                      GestureDetector(
                        onTap: () => _onActionTap(index, action),
                        child: Container(
                          width: widget.buttonSize,
                          height: widget.buttonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: actionColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.7)
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Internal helper holding pre‑computed animation data per button.
class _ButtonAnimData {
  final double dx, dy;
  final CurvedAnimation anim;
  _ButtonAnimData({required this.dx, required this.dy, required this.anim});
}
