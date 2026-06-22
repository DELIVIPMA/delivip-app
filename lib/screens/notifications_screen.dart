import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_container.dart';
import '../widgets/global_background.dart';
import '../widgets/responsive_helper.dart';

// ═══════════════════════════════════════════════════════════════════
//  NOTIFICATIONS SCREEN — Premium Glassmorphism Notification List
//  Uses GlobalBackground + GlassContainer for a cohesive DeliVIP look
// ═══════════════════════════════════════════════════════════════════

/// Represents a single notification item
class _NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isUnread;
  final String time;
  const _NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isUnread = true,
    required this.time,
  });
}

/// Mock notifications data
const _mockNotifications = [
  _NotificationItem(
    id: '1',
    title: 'Commande en route 🚀',
    subtitle:
        'Votre commande #1245 est en route ! Livraison prévue dans 15 min.',
    icon: Icons.delivery_dining_rounded,
    isUnread: true,
    time: '2 min',
  ),
  _NotificationItem(
    id: '2',
    title: 'Promo spéciale 🍕',
    subtitle: 'Promo : -20% sur toutes les Pizzas aujourd\'hui seulement !',
    icon: Icons.local_offer_rounded,
    isUnread: true,
    time: '15 min',
  ),
  _NotificationItem(
    id: '3',
    title: 'Commande livrée ✅',
    subtitle: 'Votre commande #1239 a été livrée avec succès. Bon appétit !',
    icon: Icons.check_circle_outline_rounded,
    isUnread: false,
    time: '2 h',
  ),
  _NotificationItem(
    id: '4',
    title: 'Nouveau restaurant 🎉',
    subtitle:
        'Burger House vient d\'ouvrir près de chez vous. Découvrez leurs offres !',
    icon: Icons.store_rounded,
    isUnread: true,
    time: '3 h',
  ),
  _NotificationItem(
    id: '5',
    title: 'Points de fidélité ⭐',
    subtitle: 'Vous avez gagné 50 points DeliVIP sur votre commande #1234.',
    icon: Icons.star_rounded,
    isUnread: false,
    time: '1 j',
  ),
  _NotificationItem(
    id: '6',
    title: 'Réduction weekend 💥',
    subtitle:
        'Livraison gratuite ce weekend pour toute commande de 80 MAD ou plus.',
    icon: Icons.card_giftcard_rounded,
    isUnread: true,
    time: '1 j',
  ),
  _NotificationItem(
    id: '7',
    title: 'Code promo exclusif 🔥',
    subtitle:
        'Utilisez le code DELIVIP15 pour -15% sur votre prochaine commande.',
    icon: Icons.discount_rounded,
    isUnread: false,
    time: '2 j',
  ),
];

// ═══════════════════════════════════════════════════════════════════
//  SCREEN
// ═══════════════════════════════════════════════════════════════════

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  @override
  Widget build(BuildContext context) {
    return GlobalBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  // ─── Transparent AppBar ──────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: _teal,
        onPressed: () {
          final rootNav = Navigator.of(context, rootNavigator: true);
          if (rootNav.canPop()) {
            rootNav.pop();
          } else if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      title: Text(
        'Notifications',

        style: GoogleFonts.poppins(
          fontSize: ResponsiveHelper.fontSize(context, 20),
          fontWeight: FontWeight.w700,
          color: _dark,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      actions: [
        if (_mockNotifications.any((n) => n.isUnread))
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Toutes les notifications marquées comme lues',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: _dark,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Tout lire',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _teal,
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ─── Body with ListView ──────────────────────────────
  Widget _buildBody(BuildContext context) {
    final horPad = ResponsiveHelper.horizontalPadding(context);

    return SafeArea(
      child: ResponsiveHelper.constrainWidth(
        context,
        ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(horPad, 8, horPad, 24),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemCount: _mockNotifications.length,
          itemBuilder: (context, index) =>
              _buildNotificationCard(context, _mockNotifications[index]),
        ),
      ),
    );
  }

  // ─── Single Notification Card (GlassContainer) ──────
  Widget _buildNotificationCard(BuildContext context, _NotificationItem item) {
    final isUnread = item.isUnread;

    // Unread: primary color icon + subtle glowing border
    // Read: grey icon
    final iconColor = isUnread ? _teal : _dark.withValues(alpha: 0.35);

    // Unread items get a subtle teal-tinted border + glow
    final border = isUnread
        ? Border.all(color: _teal.withValues(alpha: 0.25), width: 1.2)
        : Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.0);

    // Extra shadow glow for unread items
    final extraShadow = isUnread
        ? [
            BoxShadow(
              color: _teal.withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ]
        : <BoxShadow>[];

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: BorderRadius.circular(16),
      opacity: isUnread ? 0.22 : 0.14,
      tintColor: isUnread ? Colors.white : Colors.white,
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isUnread ? 0.07 : 0.04),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
        ...extraShadow,
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon container ──
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isUnread ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),

          // ── Text content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _dark,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unread dot indicator
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _teal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _teal.withValues(alpha: 0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _dark.withValues(alpha: 0.55),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'il y a ${item.time}',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _teal.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
