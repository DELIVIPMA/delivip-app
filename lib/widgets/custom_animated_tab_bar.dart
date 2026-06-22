import 'package:flutter/material.dart';

class CustomAnimatedTabBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomAnimatedTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomAnimatedTabBar> createState() => _CustomAnimatedTabBarState();
}

class _CustomAnimatedTabBarState extends State<CustomAnimatedTabBar>
    with TickerProviderStateMixin {
  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    (icon: Icons.analytics_rounded, label: 'Analytics'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  late AnimationController _slideCtrl;
  late List<AnimationController> _bounceCtrls;
  late List<Animation<double>> _bounceAnims;
  int _prev = 0;

  @override
  void initState() {
    super.initState();
    _prev = widget.currentIndex;
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideCtrl.value = 1.0;

    _bounceCtrls = List.generate(4, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      c.value = widget.currentIndex == i ? 1.0 : 0.0;
      return c;
    });

    _bounceAnims = List.generate(4, (i) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 1.35,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 45,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.35,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.elasticOut)),
          weight: 55,
        ),
      ]).animate(_bounceCtrls[i]);
    });
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedTabBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _bounceCtrls[_prev].reverse(from: 1.0);
      _slideCtrl.forward(from: 0.0);
      _bounceCtrls[widget.currentIndex].forward(from: 0.0);
      _prev = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    for (final c in _bounceCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    const hm = 16.0;
    final seg = (screenW - hm * 2) / 4;

    return Container(
      height: 68,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(14),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Sliding pill indicator
          AnimatedBuilder(
            animation: _slideCtrl,
            builder: (_, _) {
              final t = Curves.easeOutBack.transform(_slideCtrl.value);
              final from = _prev;
              final to = widget.currentIndex;
              final left =
                  hm + seg * from + (seg * (to - from)) * t + seg / 2 - 26;
              return Positioned(
                top: 6,
                left: left,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0E6B56), Color(0xFF0B5A47)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0E6B56).withAlpha(55),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Tab items
          Row(
            children: List.generate(4, (i) {
              final sel = widget.currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onTap(i),
                  child: AnimatedBuilder(
                    animation: _bounceAnims[i],
                    builder: (_, child) => Transform.scale(
                      scale: _bounceAnims[i].value,
                      child: child,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          color: sel ? Colors.white : Colors.grey.shade400,
                          size: sel ? 23 : 21,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _tabs[i].label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                            color: sel ? Colors.white : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
