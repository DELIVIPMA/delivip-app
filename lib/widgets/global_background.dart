import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
//  GLOBAL BACKGROUND — Pure White Uber Eats Style
// ═══════════════════════════════════════════════════════════════════

class GlobalBackground extends StatelessWidget {
  final Widget child;

  const GlobalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.white)),
        child,
      ],
    );
  }
}

/// Convenience scaffold preset that wraps body with GlobalBackground.
class GlassScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const GlassScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: appBar,
      body: GlobalBackground(child: body),
      bottomNavigationBar: bottomNavigationBar,
      extendBody: true,
    );
  }
}
