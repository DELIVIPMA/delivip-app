import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_container.dart';
import '../widgets/responsive_helper.dart';
import '../data/mock_orders_data.dart';
import '../data/models.dart';

// ═══════════════════════════════════════════════════════
//  ORDERS SCREEN — Uber Eats Style
//  Premium Glassmorphism UI
// ═══════════════════════════════════════════════════════

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    final isTablet = ResponsiveHelper.isLargeScreen(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(horPad, 20, horPad, 0),
              child: Text(
                'My Orders',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveHelper.fontSize(context, 28),
                  fontWeight: FontWeight.w700,
                  color: _dark,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─── TabBar ──────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horPad),
              child: Container(
                decoration: BoxDecoration(
                  color: _dark.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: _dark.withValues(alpha: 0.5),
                  indicator: BoxDecoration(
                    color: _teal,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _teal.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    fontWeight: FontWeight.w500,
                  ),
                  padding: const EdgeInsets.all(4),
                  isScrollable: isTablet ? false : false,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bike_scooter_outlined,
                            size: 18,
                            color: _tabController.index == 0
                                ? Colors.white
                                : _dark.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 6),
                          const Text('Active'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 18,
                            color: _tabController.index == 1
                                ? Colors.white
                                : _dark.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 6),
                          const Text('Past'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Tab Content ─────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [_buildActiveTab(context), _buildPastTab(context)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  ACTIVE TAB
  // ═══════════════════════════════════════════════════════
  Widget _buildActiveTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      physics: const BouncingScrollPhysics(),
      child: ResponsiveHelper.constrainWidth(
        context,
        _buildActiveOrderCard(mockActiveOrder),
      ),
    );
  }

  Widget _buildActiveOrderCard(Order order) {
    final eta = '~25 min';
    final statusSteps = ['Accepted', 'Preparing', 'On the way'];
    final currentStep = 2; // "On the way"

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(22),
      opacity: 0.20,
      tintColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: restaurant + ETA ──────────────
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text('\u{1F355}', style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.restaurantName,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order #${order.id.split('-').last}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _dark.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
              // ETA badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: _teal),
                    const SizedBox(width: 4),
                    Text(
                      eta,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _teal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Items summary ─────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 66),
            child: Text(
              order.items
                  .map((ci) => '${ci.quantity}x ${ci.item.name}')
                  .join(', '),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _dark.withValues(alpha: 0.55),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 20),

          // ── Status Timeline ───────────────────────
          _buildStatusTimeline(statusSteps, currentStep),
          const SizedBox(height: 20),

          // ── Rider info ────────────────────────────
          GlassContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: BorderRadius.circular(14),
            opacity: 0.12,
            tintColor: _teal,
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pedal_bike_outlined,
                      size: 20,
                      color: _teal,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yassin is on the way!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _dark,
                        ),
                      ),
                      Text(
                        'Your delivery rider',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _dark.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _teal.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Track Order button ────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showSnackBar('Opening live tracking...'),
              icon: const Icon(Icons.navigation_rounded, size: 18),
              label: Text(
                'Track Order',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(List<String> steps, int currentStep) {
    return Column(
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIdx = index ~/ 2;
              final active = stepIdx < currentStep;
              return Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: active ? _teal : _dark.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            }
            // Circle dot
            final stepIdx = index ~/ 2;
            final active = stepIdx <= currentStep;
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? _teal : _dark.withValues(alpha: 0.06),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: _teal.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  stepIdx < currentStep ? Icons.check : Icons.circle_rounded,
                  size: stepIdx < currentStep ? 14 : 10,
                  color: active ? Colors.white : _dark.withValues(alpha: 0.15),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(steps.length, (index) {
            final active = index <= currentStep;
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? _teal : _dark.withValues(alpha: 0.35),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  PAST TAB
  // ═══════════════════════════════════════════════════════
  Widget _buildPastTab(BuildContext context) {
    final orders = mockPastOrders;
    if (orders.isEmpty) {
      return Center(
        child: ResponsiveHelper.constrainWidth(
          context,
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\u{1F4E6}', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(
                  'No past orders yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your completed orders will appear here',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _dark.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) => ResponsiveHelper.constrainWidth(
        context,
        _buildPastOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildPastOrderCard(Order order) {
    final isDelivered = order.status == 'delivered';
    final statusLabel = order.statusText;
    final statusBadgeColor = order.statusColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        opacity: 0.20,
        tintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row: image placeholder + info ────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Square image placeholder
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _teal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      order.items.isNotEmpty
                          ? order.items.first.item.emoji
                          : '\u{1F37D}\uFE0F',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.items
                            .map((ci) => '${ci.quantity}x ${ci.item.name}')
                            .join(', '),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _dark.withValues(alpha: 0.55),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Row: date / total / status ───────────
            Row(
              children: [
                // Date
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: _dark.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  order.formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _dark.withValues(alpha: 0.45),
                  ),
                ),
                const Spacer(),
                // Total
                Text(
                  '${order.total.toStringAsFixed(2)} DH',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Row: status badge + Reorder ──────────
            Row(
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBadgeColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDelivered ? Icons.check_circle : Icons.cancel,
                        size: 12,
                        color: statusBadgeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusBadgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Reorder button
                SizedBox(
                  height: 34,
                  child: OutlinedButton.icon(
                    onPressed: () => _showSnackBar(
                      'Reordering from ${order.restaurantName}...',
                    ),
                    icon: const Icon(Icons.replay_rounded, size: 16),
                    label: Text(
                      'Reorder',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _teal,
                      side: BorderSide(color: _teal.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HELPER
  // ═══════════════════════════════════════════════════════
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: _dark,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
