import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════════════
///  DeliVIPRadialMenu — Radial navigation menu for DeliVIP
///
///  A floating radial menu anchored at the bottom‑center of the screen.
///  Tap the center 🛵 button to expand 8 action buttons in a circle.
///
///  Usage:
///  ```dart
///  Stack(
///    children: [
///      YourContent(),
///      const Positioned(
///        bottom: 0, left: 0, right: 0,
///        child: DeliVIPRadialMenu(),
///      ),
///    ],
///  )
///  ```
/// ═══════════════════════════════════════════════════════════════════

/// ─── Data model for a radial menu action ─────────────────────────
class RadialAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const RadialAction({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF09C4B8),
    required this.onTap,
  });
}

/// ─── The radial menu widget ──────────────────────────────────────
class DeliVIPRadialMenu extends StatefulWidget {
  /// Custom list of actions (max 8). If omitted, defaults are used.
  final List<RadialAction>? actions;

  /// The radius of the circle the buttons sit on.
  final double spreadRadius;

  /// Diameter of each satellite button.
  final double buttonSize;

  /// Whether to show labels under satellite buttons.
  final bool showLabels;

  const DeliVIPRadialMenu({
    super.key,
    this.actions,
    this.spreadRadius = 110,
    this.buttonSize = 50,
    this.showLabels = true,
  });

  @override
  State<DeliVIPRadialMenu> createState() => _DeliVIPRadialMenuState();
}

class _DeliVIPRadialMenuState extends State<DeliVIPRadialMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_ButtonAnim> _anims;
  bool _open = false;

  static const _brandTeal = Color(0xFF09C4B8);

  List<RadialAction> get _actions => widget.actions ?? _defaultActions;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _anims = List.generate(_actions.length, (i) {
      final angle = -math.pi / 2 + i * (2 * math.pi) / 8;
      return _ButtonAnim(
        dx: widget.spreadRadius * math.cos(angle),
        dy: widget.spreadRadius * math.sin(angle),
        anim: CurvedAnimation(
          parent: _ctrl,
          curve: Interval(i * 0.04, (i * 0.04 + 0.6).clamp(0.0, 1.0)),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (final a in _anims) {
      a.anim.dispose();
    }
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

  void _onAction(int i, RadialAction a) {
    _close();
    Future.delayed(const Duration(milliseconds: 80), a.onTap);
  }

  // ═══════════════════════════════════════════════════════════════
  //  Default actions (feel free to customise via the actions param)
  // ═══════════════════════════════════════════════════════════════
  static const List<RadialAction> _defaultActions = [
    RadialAction(
      icon: Icons.restaurant_menu,
      label: 'Restaurants',
      color: Color(0xFFFF6D00),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.shopping_bag,
      label: 'Boutiques',
      color: Color(0xFFE040FB),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.local_grocery_store,
      label: 'Épiceries',
      color: Color(0xFF00C853),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.flash_on,
      label: 'Rapide',
      color: Color(0xFFFFD600),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.account_balance_wallet,
      label: 'Wallet',
      color: Color(0xFF448AFF),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.motorcycle,
      label: 'Riders',
      color: Color(0xFF7C4DFF),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.favorite,
      label: 'Favoris',
      color: Color(0xFFFF4081),
      onTap: _noop,
    ),
    RadialAction(
      icon: Icons.headset_mic,
      label: 'Support',
      color: Color(0xFF00BCD4),
      onTap: _noop,
    ),
  ];

  static void _noop() {}

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.spreadRadius + widget.buttonSize + 60,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ── Overlay (tappable to close) ──
          if (_open)
            GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.black45),
            ),

          // ── Satellite buttons ──
          for (int i = 0; i < _actions.length; i++) _buildButton(i),

          // ── Center toggle ──
          _buildCenter(),
        ],
      ),
    );
  }

  Widget _buildCenter() {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final rotation = Tween(
          begin: 0.0,
          end: math.pi / 4,
        ).evaluate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
        return GestureDetector(
          onTap: _toggle,
          child: Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_brandTeal, Color(0xFF00796B)],
              ),
              boxShadow: [
                BoxShadow(
                  color: _brandTeal.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: rotation,
              child: Icon(
                _open ? Icons.close : Icons.delivery_dining,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(int index) {
    final ba = _anims[index];
    final a = _actions[index];

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = ba.anim.value;
        final dx = ba.dx * t;
        final dy = ba.dy * t;
        final opacity = t.clamp(0.0, 1.0);
        final scale = 0.3 + 0.7 * t;

        return Positioned(
          bottom: 16 + dy,
          left: null,
          right: null,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _onAction(index, a),
                      child: Container(
                        width: widget.buttonSize,
                        height: widget.buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E1E1E),
                          border: Border.all(
                            color: a.color.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: a.color.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(a.icon, color: a.color, size: 24),
                      ),
                    ),
                    if (widget.showLabels) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          a.label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Internal helper for pre‑computed button animation data.
class _ButtonAnim {
  final double dx, dy;
  final CurvedAnimation anim;
  _ButtonAnim({required this.dx, required this.dy, required this.anim});
}
