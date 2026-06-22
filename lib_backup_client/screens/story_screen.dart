import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  STORY SCREEN — DeliVip Instagram-style story
// ═══════════════════════════════════════════════════════════════════

class StoryScreen extends StatefulWidget {
  final int initialStoryIndex;

  const StoryScreen({super.key, this.initialStoryIndex = 1});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _currentStory = 1; // 0 = first (full), 1 = second (partial)
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _currentStory = widget.initialStoryIndex;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animController.forward();

    // Auto-advance after 5 seconds
    _autoTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _autoTimer?.cancel();
    super.dispose();
  }

  void _goNext() {
    _autoTimer?.cancel();
    if (_currentStory == 1) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _currentStory++);
      _animController.reset();
      _animController.forward();
      _autoTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  void _goPrevious() {
    if (_currentStory > 0) {
      _autoTimer?.cancel();
      setState(() => _currentStory--);
      _animController.reset();
      _animController.forward();
      _autoTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 3) {
            _goPrevious();
          } else {
            _goNext();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF1A237E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Food emoji overlay (large, centered)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Center(
                    child: Transform.scale(
                      scale: 1.8,
                      child: const Text(
                        '\u{1F354}',
                        style: TextStyle(fontSize: 200),
                      ),
                    ),
                  ),
                ),
              ),
              // Dark overlay
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              // Progress bars
              Positioned(
                top: 48,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Container(
                          height: 3,
                          color: Colors.white.withValues(alpha: 0.4),
                          child: const Row(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: AnimatedBuilder(
                          listenable: _animController,
                          builder: (context, child) {
                            return Container(
                              height: 3,
                              color: Colors.white.withValues(alpha: 0.3),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _animController.value,
                                child: Container(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Top info row
              Positioned(
                top: 68,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Burger Beast Agadir',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Il y a 2 jours',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                '  \u2022  ',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                'Top satisfaction client',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Content: section title + review card
              Positioned(
                top: MediaQuery.of(context).size.height * 0.32,
                left: 0,
                right: 0,
                bottom: 120,
                child: Column(
                  children: [
                    // Section title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nos habitu\u00E9s disent',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Review card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\u201C',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00BFA5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'On adore leurs choix aujourd\'hui, on a tous trouv\u00E9 quelque chose de diff\u00E9rent qu\'on a ador\u00E9.',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00BFA5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mohammed Amine',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Command\u00E9 4x',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom bar
              Positioned(
                bottom: 32,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // View store button
                    GestureDetector(
                      onTap: () {
                        // Navigator.push to RestaurantDetailsScreen
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Voir le magasin',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // More options
                    GestureDetector(
                      onTap: () {
                        // Show bottom sheet
                      },
                      child: const Icon(
                        Icons.more_horiz,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  AnimatedBuilder helper
// ═══════════════════════════════════════════════════════════════════

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
