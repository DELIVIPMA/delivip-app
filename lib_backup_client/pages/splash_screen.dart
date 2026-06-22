import 'package:flutter/material.dart';
import '../widgets/app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoSlide;
  late final Animation<double> _taglineOpacity;

  bool _dotsStarted = false;
  bool _navigated = false;

  // Cycle durations
  static const int _mainDuration = 3000;
  static const int _dotsCycle = 600;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _mainDuration),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _dotsCycle),
    );

    // Logo: fade in + slide up (300ms → 900ms → interval 0.1 → 0.3)
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    _logoSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    // Tagline: fade in (800ms → 1200ms → interval 0.267 → 0.4)
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.267, 0.4, curve: Curves.easeOut),
      ),
    );

    // Start dots pulse when main controller reaches 1200ms (value ≥ 0.4)
    _mainController.addListener(_onMainTick);

    // Navigate when complete
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });

    _mainController.forward();
  }

  void _onMainTick() {
    if (!_dotsStarted && _mainController.value >= 0.4) {
      _dotsStarted = true;
      _dotsController.repeat(reverse: true);
    }
  }

  void _navigateToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const AppShell(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _mainController.removeListener(_onMainTick);
    _mainController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  /// Calculates the scale for each dot based on staggered pulse timing.
  /// Each dot pulses scale 1 → 1.3 → 1 over 300ms,
  /// staggered by 150ms between dots.
  double _getDotScale(int index) {
    if (!_dotsStarted) return 1.0;
    final value = _dotsController.value;
    final phase = (value * _dotsCycle - index * 150) % _dotsCycle;
    if (phase >= 0 && phase < 300) {
      final t = phase / 150;
      if (t <= 1) {
        return 1.0 + t * 0.3;
      } else {
        return 1.3 - (t - 1) * 0.3;
      }
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1AA49B),
      body: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Stack(
            children: [
              // Decorative large circle — top-right (300px, 6% opacity)
              const Positioned(
                top: -100,
                right: -100,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x0FFFFFFF),
                    ),
                  ),
                ),
              ),

              // Decorative small circle — bottom-left (200px, 4% opacity)
              const Positioned(
                bottom: -80,
                left: -80,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x0AFFFFFF),
                    ),
                  ),
                ),
              ),

              // Center content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---- Logo ----
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _logoSlide.value),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Deli',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'VIP',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Color(0xFFFCD033),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ---- Tagline ----
                    Opacity(
                      opacity: _taglineOpacity.value,
                      child: const Text(
                        'DELIVER FASTER',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 3,
                          color: Color(0xB3FFFFFF),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ---- Loading dots ----
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index > 0 ? 8 : 0),
                          child: Transform.scale(
                            scale: _getDotScale(index),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(
                                  alpha: 0.5 + (index * 0.1),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
