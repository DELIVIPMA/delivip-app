import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADMIN ANALYTICS SCREEN — Full Analytics Dashboard
//  KPIs, Revenue Chart, Peak Hours, Top Products, Categories,
//  Top Drivers, Smart Insights, Conversion Funnel
// ═══════════════════════════════════════════════════════════════════

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  String _period = 'week';

  static const teal = Color(0xFF1AA49B);
  static const gold = Color(0xFFEF9F27);
  static const pink = Color(0xFFD4537E);
  static const cardBg = Colors.white;

  // ─── Period Data ──────────────────────────────────────────────
  List<_KpiData> get _kpis {
    switch (_period) {
      case 'today':
        return [
          _KpiData('Total Revenue', '1,890 MAD', '+8%', true, Icons.trending_up),
          _KpiData('Total Orders', '38', '+5%', true, Icons.shopping_bag),
          _KpiData('Avg Order Value', '49.7 MAD', '+2%', true, Icons.money),
          _KpiData('Avg Delivery Time', '26 min', '-2 min \u2191', true, Icons.timer),
          _KpiData('Active Customers', '124', '+3%', true, Icons.people),
          _KpiData('Cancellation Rate', '3.8%', '-0.4%', true, Icons.cancel),
        ];
      case 'month':
        return [
          _KpiData('Total Revenue', '48,200 MAD', '+31%', true, Icons.trending_up),
          _KpiData('Total Orders', '1,043', '+24%', true, Icons.shopping_bag),
          _KpiData('Avg Order Value', '46.2 MAD', '+6%', true, Icons.money),
          _KpiData('Avg Delivery Time', '30 min', '+1 min', false, Icons.timer),
          _KpiData('Active Customers', '898', '+18%', true, Icons.people),
          _KpiData('Cancellation Rate', '5.1%', '+0.8%', false, Icons.cancel),
        ];
      default: // week
        return [
          _KpiData('Total Revenue', '12,480 MAD', '+23%', true, Icons.trending_up),
          _KpiData('Total Orders', '247', '+18%', true, Icons.shopping_bag),
          _KpiData('Avg Order Value', '50.5 MAD', '+4%', true, Icons.money),
          _KpiData('Avg Delivery Time', '28 min', '+3 min \u2193', false, Icons.timer),
          _KpiData('Active Customers', '898', '+12%', true, Icons.people),
          _KpiData('Cancellation Rate', '4.2%', '-1.1% \u2193', true, Icons.cancel),
        ];
    }
  }

  List<double> get _revenueThisPeriod {
    switch (_period) {
      case 'today': return [120, 160, 140, 190, 170, 220, 200, 230, 180, 160, 150, 110];
      case 'month': return [1500, 1700, 1400, 1800, 2000, 1600, 2100, 1900, 2200, 1700, 1600, 1500];
      default: return [120, 150, 90, 180, 200, 140, 160, 190, 210, 170, 150, 130];
    }
  }

  List<double> get _revenueLastPeriod {
    switch (_period) {
      case 'today': return [100, 130, 120, 150, 140, 180, 160, 190, 150, 130, 120, 90];
      case 'month': return [1200, 1400, 1200, 1500, 1600, 1300, 1700, 1500, 1800, 1400, 1300, 1200];
      default: return [100, 120, 80, 150, 160, 110, 130, 150, 170, 140, 120, 100];
    }
  }

  List<String> get _revenueLabels {
    switch (_period) {
      case 'today': return ['6h','8h','10h','12h','14h','16h','18h','20h','22h','24h','2h','4h'];
      case 'month': return ['W1','W2','W3','W4','W5','W6','W7','W8','W9','W10','W11','W12'];
      default: return ['Mon','Tue','Wed','Thu','Fri','Sat','Sun','Mon','Tue','Wed','Thu','Fri'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TOP BAR ──
          Row(
            children: [
              Text('Analytics',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500,
                      color: context.adminTextPrimary)),
              const Spacer(),
              // Period chips
              _periodChip('Today', 'today'),
              const SizedBox(width: 6),
              _periodChip('This week', 'week'),
              const SizedBox(width: 6),
              _periodChip('This month', 'month'),
              const SizedBox(width: 16),
              // Export button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: Text('Export',
                      style: GoogleFonts.inter(fontSize: 13)),
                  style: TextButton.styleFrom(
                      foregroundColor: context.adminTextPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── KPI CARDS ──
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _kpis.map((kpi) => _KpiCard(kpi: kpi)).toList(),
          ),
          const SizedBox(height: 24),

          // ── REVENUE CHART ──
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart, size: 18, color: teal),
                    const SizedBox(width: 8),
                    Text('Revenue overview',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600,
                            color: context.adminTextPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _revenueThisPeriod.reduce((a, b) => a > b ? a : b) * 1.3,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final value = rod.toY;
                            return BarTooltipItem(
                              '${value.toStringAsFixed(0)} MAD',
                              const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= _revenueLabels.length) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(_revenueLabels[idx],
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                              );
                            },
                            reservedSize: 22,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey.shade500));
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
                        horizontalInterval: _revenueThisPeriod
                                .reduce((a, b) => a > b ? a : b) *
                            0.3,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1);
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(_revenueThisPeriod.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: _revenueThisPeriod[i],
                              color: teal,
                              width: 10,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                            BarChartRodData(
                              toY: _revenueLastPeriod[i],
                              color: Colors.grey.shade300,
                              width: 10,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ],
                          barsSpace: 4,
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legendDot(teal, 'This period'),
                    const SizedBox(width: 20),
                    _legendDot(Colors.grey.shade300, 'Last period'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── PEAK HOURS CHART ──
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: teal),
                    const SizedBox(width: 8),
                    Text('Peak hours',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600,
                            color: context.adminTextPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: 8,
                      maxX: 22,
                      minY: 0,
                      maxY: 50,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(8, 4),
                            const FlSpot(9, 8),
                            const FlSpot(10, 12),
                            const FlSpot(11, 18),
                            const FlSpot(12, 38),
                            const FlSpot(13, 42),
                            const FlSpot(14, 35),
                            const FlSpot(15, 22),
                            const FlSpot(16, 20),
                            const FlSpot(17, 24),
                            const FlSpot(18, 36),
                            const FlSpot(19, 44),
                            const FlSpot(20, 38),
                            const FlSpot(21, 28),
                            const FlSpot(22, 14),
                          ],
                          color: teal,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: teal,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: teal.withValues(alpha: 0.1),
                          ),
                          isCurved: true,
                          curveSmoothness: 0.3,
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              if (value % 2 != 0) return const SizedBox();
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('${value.toInt()}h',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 10,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey.shade500));
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
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1);
                        },
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── BOTTOM ROW: 3 cards side by side ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card A — Top products
              Expanded(
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 18, color: gold),
                          const SizedBox(width: 8),
                          Text('Top products',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.adminTextPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_topProducts.length, (i) {
                        final p = _topProducts[i];
                        final maxRev = _topProducts.first.revenue;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: teal.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text('${i + 1}',
                                          style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: teal)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p.name,
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    context.adminTextPrimary)),
                                        Text(p.store,
                                            style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color:
                                                    context.adminGreyText)),
                                      ],
                                    ),
                                  ),
                                  Text('${p.revenue} MAD',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: teal)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: p.revenue / maxRev,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor:
                                      AlwaysStoppedAnimation(teal),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Card B — Orders by category
              Expanded(
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pie_chart, size: 18, color: pink),
                          const SizedBox(width: 8),
                          Text('Orders by category',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.adminTextPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 0,
                            sections: [
                              PieChartSectionData(
                                value: 58,
                                color: teal,
                                radius: 50,
                                titleStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                title: '58%',
                              ),
                              PieChartSectionData(
                                value: 24,
                                color: gold,
                                radius: 50,
                                titleStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                title: '24%',
                              ),
                              PieChartSectionData(
                                value: 18,
                                color: pink,
                                radius: 50,
                                titleStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                title: '18%',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _categoryLegend('Restaurants', 58, teal),
                      const SizedBox(height: 8),
                      _categoryLegend('Supermarkets', 24, gold),
                      const SizedBox(height: 8),
                      _categoryLegend('Boutiques', 18, pink),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Card C — Top drivers
              Expanded(
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.delivery_dining, size: 18, color: teal),
                          const SizedBox(width: 8),
                          Text('Top drivers',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.adminTextPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._topDrivers.map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: teal.withValues(alpha: 0.15),
                                  child: Text(d.initials,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: teal)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(d.name,
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: context
                                                  .adminTextPrimary)),
                                      Text('${d.orders} orders',
                                          style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color:
                                                  context.adminGreyText)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            size: 12, color: gold),
                                        const SizedBox(width: 2),
                                        Text(d.rating,
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: gold)),
                                      ],
                                    ),
                                    Text(d.time,
                                        style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color:
                                                context.adminGreyText)),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── SMART INSIGHTS ──
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 18, color: gold),
                    const SizedBox(width: 8),
                    Text('Smart insights',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600,
                            color: context.adminTextPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                ..._insights.map((insight) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: insight.dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(insight.title,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: context.adminTextPrimary)),
                                const SizedBox(height: 2),
                                Text(insight.subtitle,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: context.adminGreyText)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: teal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(insight.time,
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: teal)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── CONVERSION FUNNEL ──
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt, size: 18, color: teal),
                    const SizedBox(width: 8),
                    Text('Order conversion funnel',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600,
                            color: context.adminTextPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                ..._funnelSteps.map((step) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(step.label,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: context.adminTextSecondary)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: step.count / _funnelSteps.first.count,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation(
                                      step.color,
                                    ),
                                    minHeight: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 50,
                            child: Text('${step.count}',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: context.adminTextPrimary)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────

  Widget _periodChip(String label, String value) {
    final isActive = _period == value;
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(
            color: isActive ? Colors.grey.shade300 : Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () => setState(() => _period = value),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isActive ? Colors.black87 : Colors.grey.shade500,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            )),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: child,
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _categoryLegend(String label, int percent, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: Colors.black87)),
        ),
        Text('$percent%',
            style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Data ────────────────────────────────────────────────────

  static const _topProducts = [
    _ProductData('Classic Burger', 'Burger House', 2340),
    _ProductData('Big Tasty', 'Burger House', 1920),
    _ProductData('Margherita', 'Pizza Marrakech', 1640),
    _ProductData('California Roll', 'Sushi Souss', 1290),
    _ProductData('Caesar Salad', 'Fresh Salad Bar', 940),
  ];

  static const _topDrivers = [
    _DriverData('Youssef B.', 'YB', 48, '4.9', '32 min'),
    _DriverData('Khalid M.', 'KM', 41, '4.8', '35 min'),
    _DriverData('Amine R.', 'AR', 37, '4.7', '38 min'),
    _DriverData('Sara L.', 'SL', 29, '4.9', '30 min'),
  ];

  static const _insights = [
    _InsightData(
      'Peak hour 12h-14h',
      'Orders triple at lunch. Add 2 standby drivers.',
      'Now',
      Colors.green,
    ),
    _InsightData(
      'Burger House = 38% revenue',
      'Portfolio too dependent. Incentivize other stores.',
      'Today',
      Colors.orange,
    ),
    _InsightData(
      'Boutique orders -12%',
      'Run a promotion to re-engage customers.',
      'Today',
      Colors.red,
    ),
    _InsightData(
      'Customer retention 74%',
      'Launch loyalty program to push above 80%.',
      'This week',
      Colors.blue,
    ),
  ];

  static const _funnelSteps = [
    _FunnelStep('App opens', 1240, Color(0xFF0D7A73)),
    _FunnelStep('Browse stores', 890, Color(0xFF1AA49B)),
    _FunnelStep('Add to cart', 420, Color(0xFF3DBDB5)),
    _FunnelStep('Checkout', 310, Color(0xFF6CD4CE)),
    _FunnelStep('Delivered', 247, Color(0xFF9DE8E3)),
  ];
}

// ─── Data classes ───────────────────────────────────────────────

class _KpiData {
  final String label;
  final String value;
  final String delta;
  final bool isPositive;
  final IconData icon;
  const _KpiData(this.label, this.value, this.delta, this.isPositive, this.icon);
}

class _KpiCard extends StatelessWidget {
  final _KpiData kpi;
  const _KpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(kpi.label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text(kpi.value,
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                kpi.isPositive
                    ? Icons.trending_up
                    : Icons.trending_down,
                size: 14,
                color: kpi.isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(kpi.delta,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: kpi.isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductData {
  final String name;
  final String store;
  final int revenue;
  const _ProductData(this.name, this.store, this.revenue);
}

class _DriverData {
  final String name;
  final String initials;
  final int orders;
  final String rating;
  final String time;
  const _DriverData(
      this.name, this.initials, this.orders, this.rating, this.time);
}

class _InsightData {
  final String title;
  final String subtitle;
  final String time;
  final Color dotColor;
  const _InsightData(
      this.title, this.subtitle, this.time, this.dotColor);
}

class _FunnelStep {
  final String label;
  final int count;
  final Color color;
  const _FunnelStep(this.label, this.count, this.color);
}
