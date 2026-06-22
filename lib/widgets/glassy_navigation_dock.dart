import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════
//  GlassyNavigationDock – Cosmic / Glassmorphism Floating Bottom Nav
// ═══════════════════════════════════════════════════════════════════════
class GlassyNavigationDock extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<IconData> icons;
  final Color activeColor;
  final Color inactiveColor;
  final Color glowColor;

  const GlassyNavigationDock({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.icons = const [
      Icons.home_rounded,
      Icons.person_rounded,
      Icons.business_center_rounded,
      Icons.code_rounded,
      Icons.mail_rounded,
    ],
    this.activeColor = const Color(0xFF7C4DFF),
    this.inactiveColor = Colors.white60,
    this.glowColor = const Color(0xFF7C4DFF),
  });

  @override
  State<GlassyNavigationDock> createState() => _GlassyNavigationDockState();
}

class _GlassyNavigationDockState extends State<GlassyNavigationDock> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 48) / widget.icons.length;
    final activeLeft = widget.selectedIndex * itemWidth + 24;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ─── Animated Active Pill ─────────────
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  left: activeLeft,
                  top: 12,
                  child: Container(
                    width: itemWidth - 16,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.activeColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: widget.glowColor.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Icons Row ────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.icons.length, (i) {
                    final isActive = widget.selectedIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onItemSelected(i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Icon(
                              widget.icons[i],
                              size: 24,
                              color: isActive
                                  ? Colors.white
                                  : widget.inactiveColor,
                            ),
                            const SizedBox(height: 4),
                            // ─── Glowing Dot Indicator ──
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isActive ? 6 : 0,
                              height: isActive ? 6 : 0,
                              decoration: BoxDecoration(
                                color: widget.activeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.glowColor.withValues(
                                      alpha: 0.7,
                                    ),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
