import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ═══════════════════════════════════════════════════════════════════
//  🎴 MODERN RESTAURANT CARD 2026 — Ultra Premium
// ═══════════════════════════════════════════════════════════════════

class ModernRestaurantCard extends StatefulWidget {
  final String emoji;
  final Color bgColor;
  final String name;
  final double rating;
  final String time;
  final String fee;
  final String? badge;
  final VoidCallback? onTap;

  const ModernRestaurantCard({
    super.key,
    required this.emoji,
    required this.bgColor,
    required this.name,
    required this.rating,
    required this.time,
    required this.fee,
    this.badge,
    this.onTap,
  });

  @override
  State<ModernRestaurantCard> createState() => _ModernRestaurantCardState();
}

class _ModernRestaurantCardState extends State<ModernRestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DeliVipDurations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: DeliVipCurves.snappy),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 220,
          margin: const EdgeInsets.only(right: 16),
          decoration: DeliVipDecoration.elevatedCard(context, radius: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── IMAGE AREA ─────────────────────────────────────
              _buildImageArea(),
              // ─── INFO AREA ──────────────────────────────────────
              _buildInfoArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.bgColor,
              widget.bgColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Emoji central
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: DeliVipDurations.slow,
                curve: DeliVipCurves.bounce,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 56),
                    ),
                  );
                },
              ),
            ),
            // Rating badge
            Positioned(
              top: 12,
              left: 12,
              child: _buildRatingBadge(),
            ),
            // Promo badge
            if (widget.badge != null)
              Positioned(
                bottom: 12,
                left: 12,
                child: _buildPromoBadge(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: DeliVipShadows.soft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: DeliVipColors.gold),
          const SizedBox(width: 4),
          Text(
            widget.rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: DeliVipColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [DeliVipShadows.glow(DeliVipColors.gold, blur: 12)],
      ),
      child: Text(
        widget.badge!,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildInfoArea() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant name
          Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DeliVipColors.textPrimary,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Metadata row
          Row(
            children: [
              // Rating
              Icon(
                Icons.star_rounded,
                size: 14,
                color: DeliVipColors.gold,
              ),
              const SizedBox(width: 3),
              Text(
                widget.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: DeliVipColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              // Time
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: DeliVipColors.textMuted,
              ),
              const SizedBox(width: 3),
              Text(
                widget.time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: DeliVipColors.textSecondary,
                ),
              ),
              const Spacer(),
              // Fee
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.fee == 'Gratuit'
                      ? DeliVipColors.teal.withValues(alpha: 0.1)
                      : DeliVipColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.moped_rounded,
                      size: 12,
                      color: widget.fee == 'Gratuit'
                          ? DeliVipColors.teal
                          : DeliVipColors.textMuted,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.fee,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.fee == 'Gratuit'
                            ? DeliVipColors.teal
                            : DeliVipColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
