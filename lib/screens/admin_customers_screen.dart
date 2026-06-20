// ═══════════════════════════════════════════════════════════════════
//  ADMIN CUSTOMERS SCREEN — Professional CRM-style customer
//  management with segments, KPIs, frequency chart & detail panel
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import 'admin_orders_screen.dart' as admin_orders_screen;

// ═══════════════════════════════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════════════════════════════
class AdminCustomersColors {
  static const Color teal = Color(0xFF1AA49B);
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color gold = Color(0xFFEF9F27);
  static const Color goldLight = Color(0xFFFAEEDA);
  static const Color pink = Color(0xFFD4537E);
  static const Color pinkLight = Color(0xFFFBEAF0);
  static const Color bg = Color(0xFFF6F6F6);
  static const Color success = Color(0xFF0F6E56);
  static const Color danger = Color(0xFFA32D2D);
}

// ═══════════════════════════════════════════════════════════════════
//  CUSTOMER MODEL
// ═══════════════════════════════════════════════════════════════════
class CustomerModel {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final Color avatarTextColor;
  final String email;
  final String phone;
  final String segment; // vip, regular, risk
  final int deliveredOrders;
  final int cancelledOrders;
  final double avgOrderValue;
  final double lifetimeValue;
  final int? daysSinceLastOrder;

  CustomerModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.email,
    required this.phone,
    required this.segment,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.avgOrderValue,
    required this.lifetimeValue,
    this.daysSinceLastOrder,
  });

  int get totalOrders => deliveredOrders + cancelledOrders;
}

// ═══════════════════════════════════════════════════════════════════
//  SEGMENT HELPERS
// ═══════════════════════════════════════════════════════════════════
String computeSegment(CustomerModel c) {
  if (c.daysSinceLastOrder != null && c.daysSinceLastOrder! > 30) return 'risk';
  if (c.lifetimeValue > 1000) return 'vip';
  return 'regular';
}

String segmentLabel(String s) {
  switch (s) {
    case 'vip': return 'VIP';
    case 'risk': return 'At risk';
    default: return 'Regular';
  }
}

Color segmentColor(String s) {
  switch (s) {
    case 'vip': return AdminCustomersColors.gold;
    case 'risk': return AdminCustomersColors.pink;
    default: return AdminCustomersColors.teal;
  }
}

Color segmentLightColor(String s) {
  switch (s) {
    case 'vip': return AdminCustomersColors.goldLight;
    case 'risk': return AdminCustomersColors.pinkLight;
    default: return AdminCustomersColors.tealLight;
  }
}

Color segmentTextColor(String s) {
  switch (s) {
    case 'vip': return const Color(0xFF633806);
    case 'risk': return const Color(0xFF72243E);
    default: return AdminCustomersColors.success;
  }
}

// ═══════════════════════════════════════════════════════════════════
//  AVATAR COLOR PALETTE
// ═══════════════════════════════════════════════════════════════════
const List<Color> _avatarPalette = [
  Color(0xFFE8F5E9), Color(0xFFE3F2FD), Color(0xFFFCE4EC),
  Color(0xFFFFF3E0), Color(0xFFF3E5F5), Color(0xFFE0F7FA),
  Color(0xFFFFF8E1), Color(0xFFFBE9E7), Color(0xFFE8EAF6),
  Color(0xFFF1F8E9),
];

const List<Color> _avatarTextPalette = [
  Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFFC62828),
  Color(0xFFE65100), Color(0xFF6A1B9A), Color(0xFF00838F),
  Color(0xFFF9A825), Color(0xFFBF360C), Color(0xFF283593),
  Color(0xFF558B2F),
];

List<CustomerModel> getMockCustomers() {
  const names = [
    'Ahmed Benali', 'Sara Mouline', 'Omar Kacem', 'Imane Rami',
    'Youssef Amrani', 'Fatima Zahraoui', 'Khalid Mansouri', 'Nadia Tahiri',
    'Hicham Karimi', 'Latifa Idrissi',
  ];
  const initials = [
    'AB', 'SM', 'OK', 'IR', 'YA', 'FZ', 'KM', 'NT', 'HK', 'LI',
  ];
  const emails = [
    'ahmed.benali@email.com', 'sara.mouline@email.com',
    'omar.kacem@email.com', 'imane.rami@email.com',
    'youssef.amrani@email.com', 'fatima.zahraoui@email.com',
    'khalid.mansouri@email.com', 'nadia.tahiri@email.com',
    'hicham.karimi@email.com', 'latifa.idrissi@email.com',
  ];
  const phones = [
    '+212 6XX XXX 001', '+212 6XX XXX 002', '+212 6XX XXX 003',
    '+212 6XX XXX 004', '+212 6XX XXX 005', '+212 6XX XXX 006',
    '+212 6XX XXX 007', '+212 6XX XXX 008', '+212 6XX XXX 009',
    '+212 6XX XXX 010',
  ];
  // delivered, cancelled, avgOrderValue, lifetimeValue, daysSinceLastOrder
  const data = [
    [10, 2, 35.0, 1240.0, -1],
    [7, 1, 127.0, 890.0, -1],
    [13, 2, 140.0, 2100.0, -1],
    [4, 1, 108.0, 430.0, 34],
    [18, 2, 175.0, 3500.0, -1],
    [2, 1, 83.0, 250.0, -1],
    [9, 0, 95.0, 855.0, -1],
    [3, 0, 112.0, 336.0, 41],
    [6, 1, 98.0, 588.0, -1],
    [15, 1, 142.0, 2130.0, -1],
  ];

  return List.generate(10, (i) {
    final seg = _computeSegmentFromData(data[i][3] as double, data[i][4] as int);
    return CustomerModel(
      id: 'CUS-${1001 + i}',
      name: names[i],
      initials: initials[i],
      avatarColor: _avatarPalette[i],
      avatarTextColor: _avatarTextPalette[i],
      email: emails[i],
      phone: phones[i],
      segment: seg,
      deliveredOrders: data[i][0] as int,
      cancelledOrders: data[i][1] as int,
      avgOrderValue: data[i][2] as double,
      lifetimeValue: data[i][3] as double,
      daysSinceLastOrder: data[i][4] == -1 ? null : data[i][4] as int,
    );
  });
}

String _computeSegmentFromData(double ltv, int daysSince) {
  if (daysSince > 30) return 'risk';
  if (ltv > 1000) return 'vip';
  return 'regular';
}

// ═══════════════════════════════════════════════════════════════════
//  MOCK ORDERS PER CUSTOMER (for detail dialog)
// ═══════════════════════════════════════════════════════════════════
class _MockOrder {
  final String orderId;
  final String storeName;
  final double amount;
  final String status;
  final String date;
  const _MockOrder(this.orderId, this.storeName, this.amount, this.status, this.date);
}

List<_MockOrder> _mockOrdersForCustomer(int index) {
  // Each customer gets 3-5 mock orders
  final stores = ['Burger House', 'Pizza Marrakech', 'Sushi Souss', "McDonald's", 'Marjane'];
  final statuses = ['delivered', 'delivered', 'delivered', 'delivered', 'cancelled'];
  final amounts = [95, 145, 220, 50, 310];
  final dates = ['12 Jun', '08 Jun', '02 Jun', '28 May', '20 May'];
  return List.generate(5, (i) => _MockOrder(
    '#${1250 + index * 5 + i}',
    stores[(index + i) % stores.length],
    amounts[(index + i) % amounts.length].toDouble(),
    statuses[(index + i) % statuses.length],
    dates[(index + i) % dates.length],
  ));
}

// ═══════════════════════════════════════════════════════════════════
//  MAIN CUSTOMERS SCREEN
// ═══════════════════════════════════════════════════════════════════
class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  final List<CustomerModel> _customers = getMockCustomers();
  String _searchQuery = '';
  String _selectedSegment = 'all';

  List<CustomerModel> get _filtered {
    var list = _customers.where((c) {
      if (_selectedSegment != 'all' && computeSegment(c) != _selectedSegment) return false;
      return true;
    }).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.email.toLowerCase().contains(q) ||
        c.phone.toLowerCase().contains(q)
      ).toList();
    }
    return list;
  }

  // ── Computed stats from actual customer list ──
  int get _totalCustomers => _customers.length;

  double get _avgOrderValue {
    if (_customers.isEmpty) return 0;
    return _customers.fold(0.0, (s, c) => s + c.avgOrderValue) / _customers.length;
  }

  double get _totalRevenue => _customers.fold(0.0, (s, c) => s + c.lifetimeValue);

  double get _repeatRate {
    if (_customers.isEmpty) return 0;
    final repeat = _customers.where((c) => c.deliveredOrders >= 2).length;
    return repeat / _customers.length * 100;
  }

  int get _atRiskCount => _customers.where((c) => computeSegment(c) == 'risk').length;
  int get _vipCount => _customers.where((c) => computeSegment(c) == 'vip').length;
  int get _regularCount => _customers.where((c) => computeSegment(c) == 'regular').length;

  // ── Order frequency bands ──
  List<int> get _frequencyBands {
    final bands = [0, 0, 0, 0]; // 1-3, 4-7, 8-12, 13+
    for (final c in _customers) {
      if (c.deliveredOrders <= 3) bands[0]++;
      else if (c.deliveredOrders <= 7) bands[1]++;
      else if (c.deliveredOrders <= 12) bands[2]++;
      else bands[3]++;
    }
    return bands;
  }

  // ── Top customers by spend (top 5) ──
  List<CustomerModel> get _topCustomers {
    final sorted = List<CustomerModel>.from(_customers)
      ..sort((a, b) => b.lifetimeValue.compareTo(a.lifetimeValue));
    return sorted.take(5).toList();
  }

  void _showCustomerDetail(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (ctx) => _CustomerDetailDialog(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return Scaffold(
          backgroundColor: context.adminBg,
          body: Column(
            children: [
              _buildTopBar(context),
              _buildKpiRow(context),
              _buildSegmentTabs(context),
              Expanded(
                child: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: context.adminTopbarBg,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Customers',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: context.adminTextPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 320,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: context.adminCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.adminBorder),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.inter(fontSize: 13, color: context.adminTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search by name, email or phone...',
                  hintStyle: TextStyle(color: context.adminTextMuted, fontSize: 12),
                  prefixIcon: Icon(Icons.search, size: 18, color: context.adminTextMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Export coming soon'),
                  backgroundColor: AdminCustomersColors.teal,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            icon: const Icon(Icons.download, size: 16),
            label: Text('Export', style: GoogleFonts.inter(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AdminCustomersColors.teal,
              side: BorderSide(color: AdminCustomersColors.teal.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  KPI ROW (5 cards)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildKpiRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _kpiCard(context, 'Total customers', '$_totalCustomers', '+3 this month', AdminCustomersColors.teal, Icons.trending_up),
          _kpiCard(context, 'Avg order value', '${_avgOrderValue.toStringAsFixed(0)} DH', '+6%', AdminCustomersColors.teal, Icons.trending_up),
          _kpiCard(context, 'Total revenue', '${_totalRevenue.toStringAsFixed(0)} DH', '+18%', AdminCustomersColors.teal, Icons.trending_up),
          _kpiCard(context, 'Repeat rate', '${_repeatRate.toStringAsFixed(0)}%', '+4%', AdminCustomersColors.teal, Icons.trending_up),
          _kpiCard(context, 'At risk', '$_atRiskCount', 'no order 30d+', AdminCustomersColors.pink, Icons.warning_amber),
        ],
      ),
    );
  }

  Widget _kpiCard(BuildContext context, String label, String value, String delta, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: context.adminCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.adminBorder.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.inter(fontSize: 11, color: context.adminTextMuted)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 19, fontWeight: FontWeight.w500, color: context.adminTextPrimary)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(delta,
                      style: GoogleFonts.inter(fontSize: 11, color: color),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SEGMENT FILTER TABS
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildSegmentTabs(BuildContext context) {
    final segments = [
      ('all', 'All', _totalCustomers),
      ('vip', 'VIP', _vipCount),
      ('regular', 'Regular', _regularCount),
      ('risk', 'At risk', _atRiskCount),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: segments.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (key, label, count) = segments[i];
          final isSelected = _selectedSegment == key;
          return GestureDetector(
            onTap: () => setState(() => _selectedSegment = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : context.adminCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.black : context.adminBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : context.adminTextSecondary)),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : context.adminBorder.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('$count',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : context.adminTextMuted)),
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
  //  LAYOUTS
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildCustomerList(context)),
        const VerticalDivider(width: 1),
        Expanded(flex: 1, child: _buildSidebar(context)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return ListView(
      children: [
        _buildCustomerList(context),
        const SizedBox(height: 16),
        _buildSidebar(context),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CUSTOMER LIST
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildCustomerList(BuildContext context) {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(
        child: Text('No customers found',
            style: GoogleFonts.inter(fontSize: 14, color: context.adminTextMuted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _CustomerCard(
        customer: list[i],
        onTap: () => _showCustomerDetail(list[i]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  RIGHT SIDEBAR - 3 cards
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildSidebar(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopCustomersCard(context),
          const SizedBox(height: 16),
          _buildSegmentsCard(context),
          const SizedBox(height: 16),
          _buildFrequencyCard(context),
        ],
      ),
    );
  }

  // ── Card A: Top customers by spend ──
  Widget _buildTopCustomersCard(BuildContext context) {
    final top = _topCustomers;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top customers by spend',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 12),
          ...List.generate(top.length, (i) {
            final c = top[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Text('${i + 1}',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: context.adminTextMuted)),
                  ),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: c.avatarColor,
                    child: Text(c.initials,
                        style: GoogleFonts.inter(
                            fontSize: 8, fontWeight: FontWeight.bold, color: c.avatarTextColor)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: context.adminTextPrimary),
                            overflow: TextOverflow.ellipsis),
                        Text('${c.deliveredOrders} orders',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: context.adminTextMuted)),
                      ],
                    ),
                  ),
                  Text('${c.lifetimeValue.toStringAsFixed(0)} DH',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AdminCustomersColors.teal)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Card B: Customer segments ──
  Widget _buildSegmentsCard(BuildContext context) {
    final total = _totalCustomers;
    final segments = [
      ('vip', _vipCount, segmentColor('vip')),
      ('regular', _regularCount, segmentColor('regular')),
      ('risk', _atRiskCount, segmentColor('risk')),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer segments',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 16),
          ...segments.map((s) {
            final (key, count, color) = s;
            final pct = total > 0 ? count / total : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(segmentLabel(key),
                          style: GoogleFonts.inter(
                              fontSize: 12, color: context.adminTextSecondary)),
                      const Spacer(),
                      Text('${(pct * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.inter(
                              fontSize: 11, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: context.adminBorder.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Card C: Order frequency ──
  Widget _buildFrequencyCard(BuildContext context) {
    final bands = _frequencyBands;
    final labels = ['1-3 orders', '4-7 orders', '8-12 orders', '13+ orders'];
    final maxVal = bands.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order frequency',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal < 1 ? 1 : maxVal + 1,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble()) {
                          return Text('${value.toInt()}',
                              style: GoogleFonts.inter(fontSize: 9, color: context.adminTextMuted));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[idx],
                                style: GoogleFonts.inter(
                                    fontSize: 8, color: context.adminTextMuted)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.adminBorder.withValues(alpha: 0.3),
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(bands.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: bands[i].toDouble(),
                        color: AdminCustomersColors.teal,
                        width: 18,
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
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CUSTOMER CARD
// ═══════════════════════════════════════════════════════════════════
class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const _CustomerCard({required this.customer, required this.onTap});

  String get _segmentLabel {
    switch (customer.segment) {
      case 'vip': return 'VIP';
      case 'risk': return 'At risk';
      default: return 'Regular';
    }
  }

  Color get _segmentBg => segmentLightColor(customer.segment);
  Color get _segmentText => segmentTextColor(customer.segment);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder, width: 0.5),
        boxShadow: [
          BoxShadow(color: context.adminShadow, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Avatar with optional VIP badge ──
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: customer.avatarColor,
                    child: Text(customer.initials,
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.bold, color: customer.avatarTextColor)),
                  ),
                  if (customer.segment == 'vip')
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AdminCustomersColors.gold,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.workspace_premium, size: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // ── Info column ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + segment pill
                    Row(
                      children: [
                        Flexible(
                          child: Text(customer.name,
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w500, color: context.adminTextPrimary),
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _segmentBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_segmentLabel,
                              style: GoogleFonts.inter(
                                  fontSize: 9, fontWeight: FontWeight.w600, color: _segmentText)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Email + phone
                    Wrap(
                      spacing: 12,
                      runSpacing: 2,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.email_outlined, size: 11, color: context.adminTextMuted),
                            const SizedBox(width: 3),
                            Text(customer.email,
                                style: GoogleFonts.inter(fontSize: 11, color: context.adminTextMuted)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_outlined, size: 11, color: context.adminTextMuted),
                            const SizedBox(width: 3),
                            Text(customer.phone,
                                style: GoogleFonts.inter(fontSize: 11, color: context.adminTextMuted)),
                          ],
                        ),
                        if (customer.segment == 'risk' && customer.daysSinceLastOrder != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, size: 11, color: AdminCustomersColors.pink),
                              const SizedBox(width: 3),
                              Text('last order ${customer.daysSinceLastOrder}d ago',
                                  style: GoogleFonts.inter(
                                      fontSize: 10, color: AdminCustomersColors.pink)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // ── Stats column ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Delivered
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AdminCustomersColors.tealLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Delivered: ${customer.deliveredOrders}',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AdminCustomersColors.success)),
                  ),
                  const SizedBox(height: 4),
                  // Cancelled
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AdminCustomersColors.pinkLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Cancelled: ${customer.cancelledOrders}',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AdminCustomersColors.danger)),
                  ),
                  const SizedBox(height: 4),
                  // Avg order
                  Text('Avg: ${customer.avgOrderValue.toStringAsFixed(0)} DH',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: context.adminTextMuted)),
                  const SizedBox(height: 2),
                  // LTV badge
                  Container(
                    constraints: const BoxConstraints(minWidth: 70),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AdminCustomersColors.tealLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                        '${customer.lifetimeValue.toStringAsFixed(0)} DH',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.bold, color: AdminCustomersColors.teal)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CUSTOMER DETAIL DIALOG
// ═══════════════════════════════════════════════════════════════════
class _CustomerDetailDialog extends StatelessWidget {
  final CustomerModel customer;

  const _CustomerDetailDialog({required this.customer});

  @override
  Widget build(BuildContext context) {
    final orders = _mockOrdersForCustomer(int.tryParse(customer.id.split('-').last) ?? 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.adminBg,
      child: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.adminCard,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: customer.avatarColor,
                          child: Text(customer.initials,
                              style: GoogleFonts.inter(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: customer.avatarTextColor)),
                        ),
                        if (customer.segment == 'vip')
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AdminCustomersColors.gold,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.workspace_premium, size: 12, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customer.name,
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: segmentLightColor(customer.segment),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(segmentLabel(customer.segment),
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: segmentTextColor(customer.segment))),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: context.adminTextMuted),
                    ),
                  ],
                ),
              ),
              // ── CONTACT INFO ──
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _contactTile(context, Icons.email_outlined, customer.email, () {
                        Clipboard.setData(ClipboardData(text: customer.email));
                        _showCopied(context);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _contactTile(context, Icons.phone_outlined, customer.phone, () {
                        Clipboard.setData(ClipboardData(text: customer.phone));
                        _showCopied(context);
                      }),
                    ),
                  ],
                ),
              ),
              // ── STATS GRID ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _statTile(context, 'Total orders', '${customer.totalOrders}'),
                    _statTile(context, 'Delivered', '${customer.deliveredOrders}'),
                    _statTile(context, 'Cancelled', '${customer.cancelledOrders}'),
                    _statTile(context, 'Avg order', '${customer.avgOrderValue.toStringAsFixed(0)} DH'),
                    _statTile(context, 'Lifetime', '${customer.lifetimeValue.toStringAsFixed(0)} DH'),
                    _statTile(context, 'Member since', 'Jan 2024'),
                  ],
                ),
              ),
              // ── ORDER HISTORY ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text('Order history',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
              ),
              ...orders.map((o) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.adminCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.adminBorder),
                    ),
                    child: Row(
                      children: [
                        Text(o.orderId,
                            style: GoogleFonts.inter(
                                fontSize: 11, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                        const SizedBox(width: 8),
                        Text(o.storeName,
                            style: GoogleFonts.inter(fontSize: 10, color: context.adminTextMuted)),
                        const Spacer(),
                        Text('${o.amount.toStringAsFixed(0)} DH',
                            style: GoogleFonts.inter(
                                fontSize: 11, fontWeight: FontWeight.w600, color: AdminCustomersColors.teal)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: o.status == 'delivered'
                                ? AdminCustomersColors.tealLight
                                : AdminCustomersColors.pinkLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(o.status,
                              style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: o.status == 'delivered'
                                      ? AdminCustomersColors.success
                                      : AdminCustomersColors.danger)),
                        ),
                        const SizedBox(width: 8),
                        Text(o.date,
                            style: GoogleFonts.inter(fontSize: 10, color: context.adminTextMuted)),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              // ── ACTIONS ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                        final promos = ['10% off', 'Free delivery', '20 DH off'];
                        showDialog(context: context, builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: ctx.adminCard,
                        title: Row(children: [
                        const Icon(Icons.local_offer, size: 20, color: AdminCustomersColors.teal),
                        const SizedBox(width: 8),
                        Text('Send promo to ${customer.name}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: ctx.adminTextPrimary)),
                        ]),
                        content: Column(mainAxisSize: MainAxisSize.min, children: promos.map((p) => ListTile(
                        title: Text(p, style: GoogleFonts.inter(fontSize: 14, color: ctx.adminTextPrimary)),
                        leading: const Icon(Icons.discount, color: AdminCustomersColors.teal),
                        onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Promo code sent to ${customer.name}: $p'),
                        backgroundColor: AdminCustomersColors.teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ));
                        },
                        )).toList()),
                        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: ctx.adminTextMuted)))],
                        ));
                        },
                        icon: const Icon(Icons.local_offer, size: 16),
                        label: Text('Send promo code',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminCustomersColors.teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const admin_orders_screen.AdminOrdersScreen()));
                        },
                        icon: const Icon(Icons.receipt_long, size: 16),
                        label: Text('View all orders',
                            style: GoogleFonts.inter(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AdminCustomersColors.teal,
                          side: BorderSide(color: AdminCustomersColors.teal.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
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

  Widget _contactTile(BuildContext context, IconData icon, String text, VoidCallback onCopy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.adminBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AdminCustomersColors.teal),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(fontSize: 11, color: context.adminTextPrimary),
                overflow: TextOverflow.ellipsis),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Icon(Icons.copy, size: 14, color: context.adminTextMuted),
          ),
        ],
      ),
    );
  }

  Widget _statTile(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          Text(label,
              style: GoogleFonts.inter(fontSize: 8, color: context.adminTextMuted)),
        ],
      ),
    );
  }

  void _showCopied(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: AdminCustomersColors.teal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
