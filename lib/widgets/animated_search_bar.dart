import 'package:flutter/material.dart';

/// A premium animated search bar with a pill-shaped container,
/// glassmorphism styling, and a micro-interaction action button.
class AnimatedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onActionTap;
  final Color actionColor;

  const AnimatedSearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onActionTap,
    this.actionColor = const Color(0xFFFF6B35),
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _opacityAnim;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Phase 1: scale down (0–20%)
    // Phase 2: slide out right + fade (20–60%)
    // Phase 3: snap back to identity (60–100%)
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeInOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 80,
      ),
    ]).animate(_controller);

    _slideAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: ConstantTween<Offset>(Offset.zero), weight: 20),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.5, 0.0),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(1.5, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 55,
      ),
    ]).animate(_controller);

    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onActionPressed() {
    if (_isAnimating) return;
    setState(() => _isAnimating = true);

    widget.onActionTap?.call();
    _controller.forward(from: 0.0).then((_) {
      setState(() => _isAnimating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Search icon
          const Icon(Icons.search, color: Color(0xFFFF6B35), size: 22),
          const SizedBox(width: 10),
          // Search text field
          Expanded(
            child: TextField(
              controller: widget.controller,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                hintText: 'قلب على الماكلة لي بغيتي...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                isDense: true,
              ),
              style: TextStyle(color: Colors.grey[800], fontSize: 15),
            ),
          ),
          // Clear button (conditionally shown)
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.controller.clear();
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.close, color: Colors.grey[400], size: 18),
              ),
            ),
          const SizedBox(width: 4),
          // Animated action button
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _slideAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Opacity(opacity: _opacityAnim.value, child: child),
                  ),
                );
              },
              child: Material(
                color: widget.actionColor,
                borderRadius: BorderRadius.circular(24),
                elevation: 2,
                shadowColor: widget.actionColor.withValues(alpha: 0.4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _onActionPressed,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
