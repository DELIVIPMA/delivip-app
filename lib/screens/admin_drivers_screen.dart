// ═══════════════════════════════════════════════════════════════════
//  ADMIN DRIVERS SCREEN — Delivery Drivers Management
//  Live map, KPIs, zone analytics, top drivers ranking
//  Dark mode compatible
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';

// ═══════════════════════════════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════════════════════════════
class AdminDriversColors {
  static const Color teal = Color(0xFF1AA49B);
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color gold = Color(0xFFEF9F27);
  static const Color goldLight = Color(0xFFFAEEDA);
  static const Color blueLight = Color(0xFFE6F1FB);
  static const Color pinkLight = Color(0xFFFBEAF0);
  static const Color bg = Color(0xFFF6F6F6);
  static const Color success = Color(0xFF0F6E56);
  static const Color danger = Color(0xFFA32D2D);
  static const Color purple = Color(0xFF7B61FF);
  static const Color purpleLight = Color(0xFFEDE9FF);
  static const Color mapBg = Color(0xFFE8E0D5);
  static const Color mapRoad = Color(0xFFC0B8A8);
  static const Color mapBuilding = Color(0xFFDDD6CC);
  static const Color mapPark = Color(0xFFC5DFC5);
  static const Color mapLabel = Color(0xFF9B8F7A);
  static const Color pink = Color(0xFFE91E63);
}

// ═══════════════════════════════════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════════════════════════════════
class DriverModel {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final Color avatarTextColor;
  final String status; // busy, idle, offline
  final double mapX; // percent 0-100
  final double mapY; // percent 0-100
  final int deliveriesThisWeek;
  final double rating;
  final int avgDeliveryMinutes;
  final int offlineMinutes; // 0 if online

  const DriverModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.status,
    required this.mapX,
    required this.mapY,
    required this.deliveriesThisWeek,
    required this.rating,
    required this.avgDeliveryMinutes,
    this.offlineMinutes = 0,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  MOCK DRIVERS
// ═══════════════════════════════════════════════════════════════════
List<DriverModel> getMockDrivers() {
  return [
    DriverModel(
      id: 'd1',
      name: 'Youssef B.',
      initials: 'YB',
      avatarColor: AdminDriversColors.gold,
      avatarTextColor: Colors.white,
      status: 'busy',
      mapX: 34,
      mapY: 22,
      deliveriesThisWeek: 48,
      rating: 4.9,
      avgDeliveryMinutes: 32,
    ),
    DriverModel(
      id: 'd2',
      name: 'Khalid M.',
      initials: 'KM',
      avatarColor: AdminDriversColors.teal,
      avatarTextColor: Colors.white,
      status: 'idle',
      mapX: 62,
      mapY: 30,
      deliveriesThisWeek: 41,
      rating: 4.8,
      avgDeliveryMinutes: 35,
    ),
    DriverModel(
      id: 'd3',
      name: 'Amine R.',
      initials: 'AR',
      avatarColor: AdminDriversColors.gold,
      avatarTextColor: Colors.white,
      status: 'busy',
      mapX: 18,
      mapY: 48,
      deliveriesThisWeek: 37,
      rating: 4.7,
      avgDeliveryMinutes: 38,
    ),
    DriverModel(
      id: 'd4',
      name: 'Sara L.',
      initials: 'SL',
      avatarColor: AdminDriversColors.teal,
      avatarTextColor: Colors.white,
      status: 'idle',
      mapX: 78,
      mapY: 55,
      deliveriesThisWeek: 29,
      rating: 4.9,
      avgDeliveryMinutes: 30,
    ),
    DriverModel(
      id: 'd5',
      name: 'Hamza T.',
      initials: 'HT',
      avatarColor: AdminDriversColors.gold,
      avatarTextColor: Colors.white,
      status: 'busy',
      mapX: 48,
      mapY: 68,
      deliveriesThisWeek: 26,
      rating: 4.6,
      avgDeliveryMinutes: 36,
    ),
    DriverModel(
      id: 'd6',
      name: 'Nadia F.',
      initials: 'NF',
      avatarColor: Colors.grey,
      avatarTextColor: Colors.white,
      status: 'offline',
      mapX: 67,
      mapY: 80,
      deliveriesThisWeek: 22,
      rating: 4.5,
      avgDeliveryMinutes: 40,
      offlineMinutes: 40,
    ),
    DriverModel(
      id: 'd7',
      name: 'Rachid B.',
      initials: 'RB',
      avatarColor: AdminDriversColors.gold,
      avatarTextColor: Colors.white,
      status: 'busy',
      mapX: 28,
      mapY: 78,
      deliveriesThisWeek: 20,
      rating: 4.4,
      avgDeliveryMinutes: 34,
    ),
    DriverModel(
      id: 'd8',
      name: 'Mehdi R.',
      initials: 'MR',
      avatarColor: AdminDriversColors.teal,
      avatarTextColor: Colors.white,
      status: 'idle',
      mapX: 53,
      mapY: 18,
      deliveriesThisWeek: 18,
      rating: 4.3,
      avgDeliveryMinutes: 37,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════════
//  MAIN WIDGET
// ═══════════════════════════════════════════════════════════════════
class AdminDriversScreen extends StatefulWidget {
  const AdminDriversScreen({super.key});

  @override
  State<AdminDriversScreen> createState() => _AdminDriversScreenState();
}

class _AdminDriversScreenState extends State<AdminDriversScreen>
    with TickerProviderStateMixin {
  final List<DriverModel> _drivers = getMockDrivers();
  String _selectedFilter = 'all';
  String _searchQuery = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showAddDriverDialog(BuildContext ctx) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ctx.adminCard,
        title: Row(children: [
          const Icon(Icons.person_add, size: 20, color: AdminDriversColors.teal),
          const SizedBox(width: 8),
          Text('Add new driver', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: ctx.adminTextPrimary)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Driver name', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: ctx.adminGreyText)),
          const SizedBox(height: 6),
          TextField(
            controller: nameCtrl,
            autofocus: true,
            style: GoogleFonts.inter(fontSize: 14, color: ctx.adminTextPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. Hassan A.',
              hintStyle: TextStyle(color: ctx.adminTextMuted),
              fillColor: ctx.adminBgLight,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ctx.adminBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ctx.adminBorder)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: Text('Cancel', style: GoogleFonts.inter(color: ctx.adminTextSecondary))),
          ElevatedButton(onPressed: () {
            final name = nameCtrl.text.trim();
            if (name.isEmpty) return;
            final parts = name.split(' ');
            final initials = parts.length >= 2 ? '${parts[0][0]}${parts[1][0]}'.toUpperCase() : name.substring(0, 2).toUpperCase();
            setState(() {
              _drivers.add(DriverModel(
                id: 'd${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                initials: initials,
                avatarColor: AdminDriversColors.teal,
                avatarTextColor: Colors.white,
                status: 'idle',
                mapX: 50.0,
                mapY: 50.0,
                deliveriesThisWeek: 0,
                rating: 5.0,
                avgDeliveryMinutes: 30,
              ));
            });
            Navigator.pop(dialogCtx);
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text('Driver "$name" added!'),
              backgroundColor: AdminDriversColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ));
          }, style: ElevatedButton.styleFrom(backgroundColor: AdminDriversColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Add driver')),
        ],
      ),
    );
  }

  List<DriverModel> get _filteredDrivers {
    var list = _drivers;
    if (_selectedFilter != 'all') {
      list = list.where((d) => d.status == _selectedFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((d) => d.name.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Map<String, int> get _counts {
    final counts = <String, int>{'all': _drivers.length};
    for (final d in _drivers) {
      counts[d.status] = (counts[d.status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.adminBg,
      body: Column(
        children: [
          _buildTopBar(context),
          _buildKpiRow(context),
          _buildFilterTabs(context),
          Expanded(child: _buildMainLayout(context)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  1. TOP BAR
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: context.adminTopbarBg,
      child: Row(
        children: [
          Text(
            'Delivery drivers',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: context.adminTextPrimary,
            ),
          ),
          const SizedBox(width: 12),
          // Live dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Live',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          // Search
          SizedBox(
            width: 260,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: context.adminCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.adminBorder),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.inter(
                    fontSize: 13, color: context.adminTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search driver by name...',
                  hintStyle: TextStyle(
                      color: context.adminTextMuted, fontSize: 12),
                  prefixIcon: Icon(Icons.search,
                      size: 18, color: context.adminTextMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // New driver button
          ElevatedButton.icon(
            onPressed: () => _showAddDriverDialog(context),
            icon: const Icon(Icons.person_add, size: 18),
            label: Text(
              'New driver',
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminDriversColors.teal,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.notifications_outlined,
              size: 22, color: context.adminTextSecondary),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  2. KPI ROW
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildKpiRow(BuildContext context) {
    final busyCount = _counts['busy'] ?? 0;
    final idleCount = _counts['idle'] ?? 0;

    final kpis = [
      _KpiData(
        value: '12',
        label: 'Total drivers',
        delta: '+2 this month',
        deltaColor: AdminDriversColors.success,
        deltaIcon: Icons.trending_up,
        bgColor: AdminDriversColors.tealLight,
        iconColor: AdminDriversColors.teal,
        icon: Icons.person_pin,
      ),
      _KpiData(
        value: '8',
        label: 'Online now',
        subtitle: '$busyCount busy · $idleCount idle',
        bgColor: AdminDriversColors.goldLight,
        iconColor: AdminDriversColors.gold,
        icon: Icons.wifi_tethering,
      ),
      _KpiData(
        value: '28 min',
        label: 'Avg delivery time',
        delta: '-2 min',
        deltaColor: AdminDriversColors.success,
        deltaIcon: Icons.trending_down,
        bgColor: AdminDriversColors.blueLight,
        iconColor: Colors.blue,
        icon: Icons.timer_outlined,
      ),
      _KpiData(
        value: '4.7',
        label: 'Avg rating',
        subtitle: 'stable',
        icon: Icons.star,
        bgColor: AdminDriversColors.pinkLight,
        iconColor: Colors.pink,
      ),
      _KpiData(
        value: '87',
        label: 'Deliveries today',
        delta: '+14%',
        deltaColor: AdminDriversColors.success,
        deltaIcon: Icons.trending_up,
        bgColor: AdminDriversColors.tealLight,
        iconColor: AdminDriversColors.teal,
        icon: Icons.local_shipping,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = 10.0;
          final cardWidth =
              (constraints.maxWidth - spacing * (kpis.length - 1)) /
                  kpis.length;

          return Row(
            children: kpis.map((kpi) {
              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(right: spacing),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.adminCard,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: context.adminBorder, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: kpi.bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(kpi.icon,
                          color: kpi.iconColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            kpi.value,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.adminTextPrimary,
                            ),
                          ),
                          Text(
                            kpi.label,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: context.adminGreyText,
                            ),
                          ),
                          if (kpi.delta != null) ...[
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Icon(kpi.deltaIcon,
                                    size: 10, color: kpi.deltaColor),
                                const SizedBox(width: 2),
                                Text(
                                  kpi.delta!,
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: kpi.deltaColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (kpi.subtitle != null)
                            Text(
                              kpi.subtitle!,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: context.adminGreyText,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  3. FILTER TABS
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFilterTabs(BuildContext context) {
    final counts = _counts;
    final filters = [
      _FilterData('all', 'All', counts['all'] ?? 0),
      _FilterData('busy', 'Busy', counts['busy'] ?? 0),
      _FilterData('idle', 'Idle', counts['idle'] ?? 0),
      _FilterData('offline', 'Offline', counts['offline'] ?? 0),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final isSelected = _selectedFilter == f.key;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : context.adminCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSelected
                        ? Colors.black
                        : context.adminBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    f.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : context.adminTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withAlpha(50)
                          : context.adminBorder.withAlpha(128),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${f.count}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : context.adminTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  4. MAIN 2-COLUMN LAYOUT
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildMainLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildLeftColumn(context)),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildRightColumn(context)),
            ],
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLeftColumn(context),
                const SizedBox(height: 24),
                _buildRightColumn(context),
              ],
            ),
          );
        }
      },
    );
  }

  // ─── LEFT COLUMN ─────────────────────────────────────────────────
  Widget _buildLeftColumn(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMapCard(context),
          const SizedBox(height: 20),
          _buildDeliveriesByZoneCard(context),
        ],
      ),
    );
  }

  // ─── RIGHT COLUMN ────────────────────────────────────────────────
  Widget _buildRightColumn(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        children: [
          _buildTopDriversCard(context),
          const SizedBox(height: 20),
          _buildZoneCoverageCard(context),
          const SizedBox(height: 20),
          _buildAlertsCard(context),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  A) MAP CARD
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildMapCard(BuildContext context) {
    return _SectionCard(
      icon: Icons.map,
      title: 'Live driver map — Agadir',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendDot(AdminDriversColors.gold, 'Busy'),
          const SizedBox(width: 8),
          _legendDot(AdminDriversColors.teal, 'Idle'),
          const SizedBox(width: 8),
          _legendDot(Colors.grey, 'Offline'),
        ],
      ),
      child: SizedBox(
        height: 420,
        child: Stack(
          children: [
            // Map background
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomPaint(
                painter: _AgadirMapPainter(),
                size: const Size(double.infinity, double.infinity),
              ),
            ),
            // Neighborhood labels
            ..._neighborhoodLabels(),
            // Driver pins
            ..._filteredDrivers.map((d) => _buildDriverPin(d)),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 10, color: AdminDriversColors.mapLabel),
        ),
      ],
    );
  }

  List<Widget> _neighborhoodLabels() {
    final labels = [
      ('Hay Salam', 22.0, 14.0),
      ('Founty', 71.0, 19.0),
      ('Anza', 12.0, 58.0),
      ('Tikiouine', 50.0, 10.0),
      ('Charaf', 34.0, 45.0),
      ('Bensergao', 38.0, 75.0),
      ('Inezgane', 60.0, 58.0),
      ('Dcheira', 76.0, 75.0),
    ];

    return labels.map((l) {
      return Positioned(
        left: l.$2 / 100 * 100,
        top: l.$3 / 100 * 100,
        child: Transform.translate(
          offset: const Offset(-24, -6),
          child: Text(
            l.$1,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AdminDriversColors.mapLabel,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDriverPin(DriverModel driver) {
    final color = driver.status == 'busy'
        ? AdminDriversColors.gold
        : driver.status == 'idle'
            ? AdminDriversColors.teal
            : Colors.grey;

    final showPulse = driver.status == 'busy';

    return Positioned(
      left: driver.mapX / 100 * 100,
      top: driver.mapY / 100 * 100,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(driver.name),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing ring for busy drivers
              if (showPulse)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value * 1.8.clamp(1.0, 2.0),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withAlpha(
                              (0.7 - (_pulseAnimation.value - 1.0) * 0.7)
                                  .clamp(0.0, 0.7)
                                  .toInt()),
                        ),
                      ),
                    );
                  },
                ),
              // Pulse ring behind
              if (showPulse)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withAlpha(50),
                        ),
                      ),
                    );
                  },
                ),
              // Pin circle
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  driver.initials,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  B) DELIVERIES BY ZONE (BarChart)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildDeliveriesByZoneCard(BuildContext context) {
    final zoneData = [
      _ZoneData('Hay Salam', 42),
      _ZoneData('Founty', 38),
      _ZoneData('Inezgane', 29),
      _ZoneData('Charaf', 21),
      _ZoneData('Dcheira', 14),
      _ZoneData('Anza', 9),
    ];
    final maxVal = zoneData.map((z) => z.count).reduce((a, b) => a > b ? a : b);

    return _SectionCard(
      icon: Icons.pie_chart,
      title: 'Deliveries by zone',
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (maxVal * 1.25).ceilToDouble(),
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()}',
                    TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < zoneData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          zoneData[idx].name.length > 7
                              ? '${zoneData[idx].name.substring(0, 7)}…'
                              : zoneData[idx].name,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: context.adminGreyText,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) {
                      return Text('0',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: context.adminGreyText));
                    }
                    return Text('${value.toInt()}',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: context.adminGreyText));
                  },
                ),
              ),
              topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxVal / 4).ceilToDouble().clamp(1, 999),
              getDrawingHorizontalLine: (value) => FlLine(
                color: context.adminBorderLight,
                strokeWidth: 0.5,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(zoneData.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: zoneData[i].count.toDouble(),
                    color: AdminDriversColors.teal,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  C) TOP DRIVERS THIS WEEK
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTopDriversCard(BuildContext context) {
    final sorted = List<DriverModel>.from(_drivers)
      ..sort((a, b) => b.deliveriesThisWeek.compareTo(a.deliveriesThisWeek));

    final top5 = sorted.take(5).toList();

    return _SectionCard(
      icon: Icons.leaderboard,
      title: 'Top drivers this week',
      child: Column(
        children: List.generate(top5.length, (i) {
          final d = top5[i];
          final statusColor = d.status == 'busy'
              ? AdminDriversColors.gold
              : d.status == 'idle'
                  ? AdminDriversColors.teal
                  : Colors.grey;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: i < top5.length - 1
                  ? Border(
                      bottom: BorderSide(
                          color: context.adminBorderLight, width: 0.5))
                  : null,
            ),
            child: Row(
              children: [
                // Rank
                SizedBox(
                  width: 20,
                  child: Text(
                    '${i + 1}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.adminGreyText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: d.avatarColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        d.initials,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: d.avatarTextColor,
                        ),
                      ),
                    ),
                    // Status dot
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: context.adminCard, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                // Name + details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.adminTextPrimary,
                        ),
                      ),
                      Text(
                        '${d.deliveriesThisWeek} deliveries · ★${d.rating}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: context.adminGreyText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Avg time
                Text(
                  '${d.avgDeliveryMinutes} min avg',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AdminDriversColors.teal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  D) ZONE COVERAGE
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildZoneCoverageCard(BuildContext context) {
    final zones = [
      ('Hay Salam', 42, AdminDriversColors.teal),
      ('Founty', 38, AdminDriversColors.gold),
      ('Inezgane', 29, Colors.blue),
      ('Charaf', 21, AdminDriversColors.pink),
      ('Dcheira', 14, AdminDriversColors.purple),
    ];

    final maxOrders = zones.map((z) => z.$2).reduce((a, b) => a > b ? a : b);

    return _SectionCard(
      icon: Icons.map_outlined,
      title: 'Zone coverage',
      child: Column(
        children: zones.map((z) {
          final ratio = z.$2 / maxOrders;
          final color = z.$3;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    z.$1,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.adminTextPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: context.adminBorderLight,
                      color: color,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${z.$2}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.adminTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  E) ALERTS
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildAlertsCard(BuildContext context) {
    final alerts = [
      _AlertData(
        Icons.access_time,
        Colors.amber,
        'Nadia F. offline for 40 min',
      ),
      _AlertData(
        Icons.map_outlined,
        AdminDriversColors.danger,
        'Dcheira zone has only 1 active driver',
      ),
      _AlertData(
        Icons.star,
        AdminDriversColors.success,
        'Sara L. hit a 5.0 rating streak (10 orders)',
      ),
    ];

    return _SectionCard(
      icon: Icons.notifications_active,
      title: 'Alerts',
      child: Column(
        children: alerts.map((a) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(a.icon, size: 16, color: a.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    a.message,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.adminTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  MAP PAINTER — Agadir-style background
// ═══════════════════════════════════════════════════════════════════
class _AgadirMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background
    final bgPaint = Paint()..color = AdminDriversColors.mapBg;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Park areas
    final parkPaint = Paint()..color = AdminDriversColors.mapPark;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.05, h * 0.05, w * 0.18, h * 0.15),
            const Radius.circular(6)),
        parkPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.72, h * 0.40, w * 0.20, h * 0.18),
            const Radius.circular(6)),
        parkPaint);

    // Building blocks
    final buildingPaint = Paint()..color = AdminDriversColors.mapBuilding;

    void drawBuilding(double left, double top, double width, double height) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(left, top, width, height), const Radius.circular(3)),
          buildingPaint);
    }

    drawBuilding(w * 0.28, h * 0.08, w * 0.12, h * 0.10);
    drawBuilding(w * 0.50, h * 0.06, w * 0.08, h * 0.08);
    drawBuilding(w * 0.12, h * 0.28, w * 0.10, h * 0.10);
    drawBuilding(w * 0.30, h * 0.30, w * 0.14, h * 0.08);
    drawBuilding(w * 0.55, h * 0.28, w * 0.10, h * 0.12);
    drawBuilding(w * 0.75, h * 0.08, w * 0.12, h * 0.08);
    drawBuilding(w * 0.10, h * 0.55, w * 0.08, h * 0.10);
    drawBuilding(w * 0.70, h * 0.65, w * 0.12, h * 0.10);
    drawBuilding(w * 0.45, h * 0.50, w * 0.10, h * 0.08);
    drawBuilding(w * 0.40, h * 0.82, w * 0.14, h * 0.07);
    drawBuilding(w * 0.20, h * 0.72, w * 0.08, h * 0.10);
    drawBuilding(w * 0.60, h * 0.78, w * 0.08, h * 0.08);
    drawBuilding(w * 0.06, h * 0.78, w * 0.10, h * 0.08);
    drawBuilding(w * 0.80, h * 0.20, w * 0.12, h * 0.08);
    drawBuilding(w * 0.82, h * 0.58, w * 0.10, h * 0.08);

    // Road network
    void drawRoad(double startX, double startY, double endX, double endY,
        double strokeWidth) {
      final roadPaint = Paint()
        ..color = AdminDriversColors.mapRoad
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), roadPaint);
    }

    // Main roads (thicker)
    drawRoad(w * 0.01, h * 0.50, w * 0.99, h * 0.50, 6); // horizontal main
    drawRoad(w * 0.50, h * 0.01, w * 0.50, h * 0.99, 6); // vertical main
    drawRoad(w * 0.01, h * 0.25, w * 0.99, h * 0.25, 4); // top horizontal
    drawRoad(w * 0.01, h * 0.75, w * 0.99, h * 0.75, 4); // bottom horizontal
    drawRoad(w * 0.25, h * 0.01, w * 0.25, h * 0.99, 4); // left vertical
    drawRoad(w * 0.75, h * 0.01, w * 0.75, h * 0.99, 4); // right vertical

    // Secondary roads (thinner)
    drawRoad(w * 0.15, h * 0.50, w * 0.15, h * 0.99, 2.5);
    drawRoad(w * 0.37, h * 0.01, w * 0.37, h * 0.50, 2.5);
    drawRoad(w * 0.63, h * 0.50, w * 0.63, h * 0.99, 2.5);
    drawRoad(w * 0.88, h * 0.01, w * 0.88, h * 0.50, 2.5);
    drawRoad(w * 0.01, h * 0.37, w * 0.50, h * 0.37, 2.5);
    drawRoad(w * 0.50, h * 0.63, w * 0.99, h * 0.63, 2.5);

    // Diagonal connectors
    drawRoad(w * 0.05, h * 0.05, w * 0.42, h * 0.42, 2);
    drawRoad(w * 0.58, h * 0.58, w * 0.95, h * 0.95, 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
//  SHARED / HELPER CLASSES
// ═══════════════════════════════════════════════════════════════════

class _KpiData {
  final String value;
  final String label;
  final String? subtitle;
  final String? delta;
  final Color? deltaColor;
  final IconData? deltaIcon;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const _KpiData({
    required this.value,
    required this.label,
    this.subtitle,
    this.delta,
    this.deltaColor,
    this.deltaIcon,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });
}

class _FilterData {
  final String key;
  final String label;
  final int count;
  const _FilterData(this.key, this.label, this.count);
}

class _ZoneData {
  final String name;
  final int count;
  const _ZoneData(this.name, this.count);
}

class _AlertData {
  final IconData icon;
  final Color color;
  final String message;
  const _AlertData(this.icon, this.color, this.message);
}

// ═══════════════════════════════════════════════════════════════════
//  SECTION CARD — Reusable card wrapper (same style as _DashboardCard)
// ═══════════════════════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AdminDriversColors.teal),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.adminTextPrimary,
                ),
              ),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
