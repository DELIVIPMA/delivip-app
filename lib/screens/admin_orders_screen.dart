// ═══════════════════════════════════════════════════════════════════
//  ADMIN ORDERS SCREEN — Professional Order Management
//  Glovo / Uber Eats inspired redesign
//  Dark mode compatible
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/localization.dart';

// ═══════════════════════════════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════════════════════════════
class AdminOrdersColors {
  static const Color teal = Color(0xFF1AA49B);
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color gold = Color(0xFFEF9F27);
  static const Color goldLight = Color(0xFFFAEEDA);
  static const Color blue = Color(0xFF378ADD);
  static const Color blueLight = Color(0xFFE6F1FB);
  static const Color purple = Color(0xFF534AB7);
  static const Color purpleLight = Color(0xFFEEEDFE);
  static const Color red = Color(0xFFE24B4A);
  static const Color redLight = Color(0xFFFCEBEB);
  static const Color bg = Color(0xFFF6F6F6);
  static const Color success = Color(0xFF0F6E56);
  static const Color danger = Color(0xFF791F1F);
}

// ═══════════════════════════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════════════════════════
class DriverModel {
  final String name;
  final String initials;
  final double rating;
  final String statusText;

  const DriverModel({
    required this.name,
    required this.initials,
    required this.rating,
    required this.statusText,
  });
}

class TimelineStep {
  final String label;
  final String time;
  final String state;

  const TimelineStep({
    required this.label,
    required this.time,
    required this.state,
  });
}

class OrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String storeName;
  String status;
  final int price;
  final int itemCount;
  final String address;
  final double? distanceKm;
  final String? etaText;
  final String timeAgo;
  final String? confirmedAt;
  DriverModel? driver;
  final String? cancelReason;
  final List<TimelineStep> timeline;
  final String pickupArea;
  final String dropoffArea;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.storeName,
    required this.status,
    required this.price,
    required this.itemCount,
    required this.address,
    this.distanceKm,
    this.etaText,
    required this.timeAgo,
    this.confirmedAt,
    this.driver,
    this.cancelReason,
    required this.timeline,
    required this.pickupArea,
    required this.dropoffArea,
  });
}

// Agadir neighborhood names for map labels
const List<String> _agadirAreas = [
  'Hay Salam', 'Hay Al Houda', 'Inezgane', 'Lqliaa', 'Dcheira',
  'Bensergao', 'Founty', 'Tikiouine', 'Charaf', 'Anza',
  'Sonaba', 'Cité Suisse', 'Polyvalente', 'Tilila',
];

// ═══════════════════════════════════════════════════════════════════
//  MOCK DATA
// ═══════════════════════════════════════════════════════════════════
List<OrderModel> getMockOrders() {
  return [
    // ── DELIVERING (3) ──────────────────────────────────────
    OrderModel(
      id: '#1239',
      customerName: 'Karim L.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Burger House',
      status: 'delivering',
      price: 95,
      itemCount: 3,
      address: '18 Rue Mohammed V, Agadir',
      distanceKm: 0.8,
      etaText: 'ETA 3 min',
      timeAgo: '1 min ago',
      confirmedAt: '16:58',
      driver: DriverModel(name: 'Sara L.', initials: 'SL', rating: 4.9, statusText: 'almost there'),
      pickupArea: 'Anza',
      dropoffArea: 'Hay Salam',
      timeline: [
        TimelineStep(label: 'Order placed', time: '16:45', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '16:50', state: 'done'),
        TimelineStep(label: 'Preparing', time: '16:55', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '17:00', state: 'done'),
        TimelineStep(label: 'On the way', time: 'En cours', state: 'current'),
      ],
    ),
    OrderModel(
      id: '#1238',
      customerName: 'Nadia F.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Marrakech',
      status: 'delivering',
      price: 145,
      itemCount: 4,
      address: '33 Av. Hassan II, Agadir',
      distanceKm: 3.5,
      etaText: 'ETA 12 min',
      timeAgo: '5 min ago',
      confirmedAt: '16:20',
      driver: DriverModel(name: 'Hamza T.', initials: 'HT', rating: 4.6, statusText: 'on the way'),
      pickupArea: 'Founty',
      dropoffArea: 'Inezgane',
      timeline: [
        TimelineStep(label: 'Order placed', time: '16:00', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '16:20', state: 'done'),
        TimelineStep(label: 'Preparing', time: '16:35', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '16:45', state: 'done'),
        TimelineStep(label: 'On the way', time: 'En cours', state: 'current'),
      ],
    ),
    OrderModel(
      id: '#1237',
      customerName: 'Rachid B.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Sushi Souss',
      status: 'delivering',
      price: 220,
      itemCount: 5,
      address: '7 Rue Essaouira, Agadir',
      distanceKm: 1.2,
      etaText: 'ETA 4 min',
      timeAgo: '3 min ago',
      confirmedAt: '16:55',
      driver: DriverModel(name: 'Sara L.', initials: 'SL', rating: 4.9, statusText: 'almost there'),
      pickupArea: 'Charaf',
      dropoffArea: 'Tilila',
      timeline: [
        TimelineStep(label: 'Order placed', time: '16:45', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '16:55', state: 'done'),
        TimelineStep(label: 'Preparing', time: '17:00', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '17:08', state: 'done'),
        TimelineStep(label: 'On the way', time: 'En cours', state: 'current'),
      ],
    ),

    // ── CANCELLED (4) ───────────────────────────────────────
    OrderModel(
      id: '#1236',
      customerName: 'Latifa M.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Marjane',
      status: 'cancelled',
      price: 310,
      itemCount: 8,
      address: 'Quartier Industriel, Agadir',
      distanceKm: null,
      etaText: null,
      timeAgo: '30 min ago',
      confirmedAt: '14:30',
      driver: null,
      cancelReason: 'Store closed unexpectedly — refund: Processed',
      pickupArea: 'Anza',
      dropoffArea: 'Hay Salam',
      timeline: [
        TimelineStep(label: 'Order placed', time: '14:20', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '14:30', state: 'done'),
        TimelineStep(label: 'Cancelled', time: '14:35', state: 'current'),
        TimelineStep(label: 'Refunded', time: '15:00', state: 'done'),
      ],
    ),
    OrderModel(
      id: '#1235',
      customerName: 'Hicham K.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: "McDonald's",
      status: 'cancelled',
      price: 42,
      itemCount: 2,
      address: 'Rue de Fès, Agadir',
      distanceKm: null,
      etaText: null,
      timeAgo: '45 min ago',
      confirmedAt: '15:10',
      driver: null,
      cancelReason: 'Customer cancelled — refund: Processed',
      pickupArea: 'Founty',
      dropoffArea: 'Inezgane',
      timeline: [
        TimelineStep(label: 'Order placed', time: '15:00', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '15:10', state: 'done'),
        TimelineStep(label: 'Preparing', time: '15:15', state: 'done'),
        TimelineStep(label: 'Cancelled', time: '15:20', state: 'current'),
        TimelineStep(label: 'Refunded', time: '15:22', state: 'done'),
      ],
    ),
    OrderModel(
      id: '#1234',
      customerName: 'Salma A.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Fresh Salad Bar',
      status: 'cancelled',
      price: 68,
      itemCount: 2,
      address: 'Rue de Meknès, Agadir',
      distanceKm: null,
      etaText: null,
      timeAgo: '1h ago',
      confirmedAt: '14:00',
      driver: null,
      cancelReason: 'No driver available — refund: Pending',
      pickupArea: 'Charaf',
      dropoffArea: 'Lqliaa',
      timeline: [
        TimelineStep(label: 'Order placed', time: '13:45', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '14:00', state: 'done'),
        TimelineStep(label: 'Preparing', time: '14:10', state: 'done'),
        TimelineStep(label: 'Cancelled', time: '14:40', state: 'current'),
        TimelineStep(label: 'Refund', time: 'Pending', state: 'pending'),
      ],
    ),
    OrderModel(
      id: '#1233',
      customerName: 'Mehdi R.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Carrefour',
      status: 'cancelled',
      price: 180,
      itemCount: 5,
      address: 'Bd Mohammed VI, Agadir',
      distanceKm: null,
      etaText: null,
      timeAgo: '2h ago',
      confirmedAt: '12:30',
      driver: null,
      cancelReason: 'Customer unreachable — refund: Processed',
      pickupArea: 'Bensergao',
      dropoffArea: 'Dcheira',
      timeline: [
        TimelineStep(label: 'Order placed', time: '12:15', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '12:30', state: 'done'),
        TimelineStep(label: 'Preparing', time: '12:45', state: 'done'),
        TimelineStep(label: 'Cancelled', time: '13:30', state: 'current'),
        TimelineStep(label: 'Refunded', time: '13:35', state: 'done'),
      ],
    ),

    // ── DELIVERED (2 more) ─────────────────────────────────
    OrderModel(
      id: '#1232',
      customerName: 'Yasmine T.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Adidas Store',
      status: 'delivered',
      price: 899,
      itemCount: 1,
      address: 'Av. du 18 Novembre, Agadir',
      distanceKm: 2.8,
      etaText: 'completed in 55 min',
      timeAgo: '2h ago',
      confirmedAt: '14:05',
      driver: DriverModel(name: 'Khalid M.', initials: 'KM', rating: 5.0, statusText: 'delivered'),
      pickupArea: 'Tikiouine',
      dropoffArea: 'Sonaba',
      timeline: [
        TimelineStep(label: 'Order placed', time: '13:30', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '14:05', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '14:15', state: 'done'),
        TimelineStep(label: 'Picked up', time: '14:20', state: 'done'),
        TimelineStep(label: 'Delivered', time: '14:25', state: 'done'),
      ],
    ),
    OrderModel(
      id: '#1231',
      customerName: 'Othmane S.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Zara Agadir',
      status: 'delivered',
      price: 458,
      itemCount: 3,
      address: 'Rue Oued N\'Fis, Agadir',
      distanceKm: 1.5,
      etaText: 'completed in 48 min',
      timeAgo: '3h ago',
      confirmedAt: '12:45',
      driver: DriverModel(name: 'Amine R.', initials: 'AR', rating: 4.7, statusText: 'delivered'),
      pickupArea: 'Polyvalente',
      dropoffArea: 'Cité Suisse',
      timeline: [
        TimelineStep(label: 'Order placed', time: '12:15', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '12:45', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '12:55', state: 'done'),
        TimelineStep(label: 'Picked up', time: '13:00', state: 'done'),
        TimelineStep(label: 'Delivered', time: '13:03', state: 'done'),
      ],
    ),

    // ── ORIGINAL 6 ──────────────────────────────────────────
    OrderModel(
      id: '#1245',
      customerName: 'Ahmed B.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Hut',
      status: 'pending',
      price: 102,
      itemCount: 2,
      address: '12 Rue des Far, Casablanca',
      distanceKm: 3.2,
      etaText: '25-35 min',
      timeAgo: '2 min ago',
      confirmedAt: '15:54',
      driver: null,
      pickupArea: 'Hay Al Houda',
      dropoffArea: 'Hay Salam',
      timeline: [
        TimelineStep(label: 'Order placed', time: '15:47', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '15:54', state: 'done'),
        TimelineStep(label: 'Preparing', time: 'En cours', state: 'current'),
        TimelineStep(label: 'Ready for pickup', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Delivered', time: 'En attente', state: 'pending'),
      ],
    ),
    OrderModel(
      id: '#1244',
      customerName: 'Sara M.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: "McDonald's",
      status: 'ready',
      price: 50,
      itemCount: 2,
      address: '45 Bd Zerktouni, Casablanca',
      distanceKm: 1.8,
      etaText: '15-20 min',
      timeAgo: '15 min ago',
      confirmedAt: '15:42',
      driver: DriverModel(name: 'Youssef B.', initials: 'YB', rating: 4.9, statusText: 'waiting pickup'),
      pickupArea: 'Founty',
      dropoffArea: 'Hay Al Houda',
      timeline: [
        TimelineStep(label: 'Order placed', time: '15:28', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '15:42', state: 'done'),
        TimelineStep(label: 'Preparing', time: '15:50', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '16:00', state: 'current'),
        TimelineStep(label: 'Delivered', time: 'En attente', state: 'pending'),
      ],
    ),
    OrderModel(
      id: '#1243',
      customerName: 'Omar K.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Sushi Shop',
      status: 'delivered',
      price: 135,
      itemCount: 2,
      address: '8 Rue Tantan, Casablanca',
      distanceKm: 4.5,
      etaText: 'completed 14:52',
      timeAgo: '1h ago',
      confirmedAt: '12:30',
      driver: DriverModel(name: 'Khalid M.', initials: 'KM', rating: 4.8, statusText: 'delivered'),
      pickupArea: 'Dcheira',
      dropoffArea: 'Bensergao',
      timeline: [
        TimelineStep(label: 'Order placed', time: '12:10', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '12:30', state: 'done'),
        TimelineStep(label: 'Preparing', time: '13:00', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '13:20', state: 'done'),
        TimelineStep(label: 'Delivered', time: '14:52', state: 'done'),
      ],
    ),
    OrderModel(
      id: '#1242',
      customerName: 'Imane R.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Taco Bell',
      status: 'delivering',
      price: 38,
      itemCount: 1,
      address: '3 Av. des FAR, Casablanca',
      distanceKm: 2.1,
      etaText: 'ETA 6min',
      timeAgo: '8 min ago',
      confirmedAt: '16:05',
      driver: DriverModel(name: 'Amine R.', initials: 'AR', rating: 4.7, statusText: 'on the way'),
      pickupArea: 'Tikiouine',
      dropoffArea: 'Polyvalente',
      timeline: [
        TimelineStep(label: 'Order placed', time: '16:00', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '16:05', state: 'done'),
        TimelineStep(label: 'Preparing', time: '16:10', state: 'done'),
        TimelineStep(label: 'Ready for pickup', time: '16:18', state: 'done'),
        TimelineStep(label: 'Delivered', time: 'En cours', state: 'current'),
      ],
    ),
    OrderModel(
      id: '#1241',
      customerName: 'Youssef A.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Hut',
      status: 'cancelled',
      price: 55,
      itemCount: 1,
      address: '20 Bd Anfa, Casablanca',
      distanceKm: null,
      etaText: null,
      timeAgo: '2h ago',
      confirmedAt: '13:00',
      driver: null,
      cancelReason: 'customer unreachable',
      pickupArea: 'Sonaba',
      dropoffArea: 'Cité Suisse',
      timeline: [
        TimelineStep(label: 'Order placed', time: '12:30', state: 'done'),
        TimelineStep(label: 'Confirmed by store', time: '13:00', state: 'done'),
        TimelineStep(label: 'Preparing', time: '13:15', state: 'done'),
        TimelineStep(label: 'Cancelled', time: '13:45', state: 'current'),
        TimelineStep(label: 'Delivered', time: '-', state: 'pending'),
      ],
    ),
    OrderModel(
      id: '#1240',
      customerName: 'Fatima Z.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Marjane',
      status: 'pending',
      price: 210,
      itemCount: 6,
      address: '5 Rue Essaouira, Agadir',
      distanceKm: 5.0,
      etaText: '30-45 min',
      timeAgo: '22 min ago',
      confirmedAt: null,
      driver: null,
      pickupArea: 'Tilila',
      dropoffArea: 'Lqliaa',
      timeline: [
        TimelineStep(label: 'Order placed', time: '16:20', state: 'current'),
        TimelineStep(label: 'Confirmed by store', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Preparing', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Ready for pickup', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Delivered', time: 'En attente', state: 'pending'),
      ],
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════════
//  DATA HELPERS
// ═══════════════════════════════════════════════════════════════════
class _StatData {
  final String label;
  final String value;
  final Color color;
  final Color light;
  final IconData icon;
  const _StatData(this.label, this.value, this.color, this.light, this.icon);
}

class _FilterData {
  final String key;
  final String label;
  final int count;
  const _FilterData(this.key, this.label, this.count);
}

// ═══════════════════════════════════════════════════════════════════
//  MAIN WIDGET
// ═══════════════════════════════════════════════════════════════════
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with TickerProviderStateMixin {
  final List<OrderModel> _orders = getMockOrders();
  String _selectedFilter = 'all';
  String _searchQuery = '';
  String? _selectedOrderId;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  List<OrderModel> get _filteredOrders {
    var list = _orders.where((o) =>
        _selectedFilter == 'all' || o.status == _selectedFilter).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((o) =>
          o.customerName.toLowerCase().contains(q) ||
          o.id.toLowerCase().contains(q) ||
          o.storeName.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  OrderModel? get _selectedOrder {
    if (_selectedOrderId == null) return null;
    return _orders.firstWhere((o) => o.id == _selectedOrderId,
        orElse: () => _orders.first);
  }

  Map<String, int> get _counts {
    final counts = <String, int>{'all': _orders.length};
    for (final o in _orders) {
      counts[o.status] = (counts[o.status] ?? 0) + 1;
    }
    return counts;
  }

  void _simulateNewOrder() {
    final newOrder = OrderModel(
      id: '#${1240 + _orders.length}',
      customerName: 'New C.',
      customerPhone: '+212 6XX XXX XXX',
      storeName: 'Pizza Hut',
      status: 'pending',
      price: 75,
      itemCount: 2,
      address: '10 Rue New, Casablanca',
      distanceKm: 2.5,
      etaText: '20-30 min',
      timeAgo: 'just now',
      confirmedAt: null,
      driver: null,
      pickupArea: 'Anza',
      dropoffArea: 'Hay Salam',
      timeline: [
        TimelineStep(label: 'Order placed', time: 'En cours', state: 'current'),
        TimelineStep(label: 'Confirmed by store', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Preparing', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Ready for pickup', time: 'En attente', state: 'pending'),
        TimelineStep(label: 'Delivered', time: 'En attente', state: 'pending'),
      ],
    );
    setState(() {
      _orders.insert(0, newOrder);
      _selectedOrderId = newOrder.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: context.adminBg,
      body: Column(
        children: [
          _buildTopBar(context),
          _buildSummaryStrip(context),
          _buildFilterTabs(context),
          Expanded(
            child:
                isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: context.adminTopbarBg,
      child: Row(
        children: [
          Expanded(
            child: Text(
              s.orderManagement,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: context.adminTextPrimary,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _pulseAnimation.value,
                child: Container(
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
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(s.liveLabel, style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 280,
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
                  hintText: s.searchByCustomerIdStore,
                  hintStyle: TextStyle(color: context.adminTextMuted, fontSize: 12),
                  prefixIcon: Icon(Icons.search, size: 18, color: context.adminTextMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: _simulateNewOrder,
            icon: const Icon(Icons.add_circle_outline, size: 18, color: AdminOrdersColors.teal),
            label: Text(s.simulate, style: GoogleFonts.inter(fontSize: 11, color: AdminOrdersColors.teal)),
            style: TextButton.styleFrom(
              backgroundColor: AdminOrdersColors.tealLight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 22, color: context.adminTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;
    final counts = _counts;
    final stats = [
      _StatData(s.totalToday, '${counts['all'] ?? 0}', AdminOrdersColors.teal, AdminOrdersColors.tealLight, Icons.list_alt),
      _StatData(s.pendingOrders, '${counts['pending'] ?? 0}', AdminOrdersColors.gold, AdminOrdersColors.goldLight, Icons.schedule),
      _StatData(s.inProgress, '${(counts['pending'] ?? 0) + (counts['ready'] ?? 0)}', AdminOrdersColors.blue, AdminOrdersColors.blueLight, Icons.restaurant),
      _StatData(s.deliveredLabel, '${counts['delivered'] ?? 0}', AdminOrdersColors.success, AdminOrdersColors.tealLight, Icons.check_circle),
      _StatData(s.cancelledLabel, '${counts['cancelled'] ?? 0}', AdminOrdersColors.red, AdminOrdersColors.redLight, Icons.close),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: stats.map((s) {
          final c = s.color;
          final l = s.light;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(color: l, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: c)),
                        Text(s.label, style: GoogleFonts.inter(fontSize: 11, color: c)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;
    final counts = _counts;
    final filters = [
      _FilterData('all', s.filterAll, counts['all'] ?? 0),
      _FilterData('pending', s.pendingOrders, counts['pending'] ?? 0),
      _FilterData('ready', s.readyStatus, counts['ready'] ?? 0),
      _FilterData('delivering', s.deliveringStatus, counts['delivering'] ?? 0),
      _FilterData('delivered', s.deliveredLabel, counts['delivered'] ?? 0),
      _FilterData('cancelled', s.cancelledLabel, counts['cancelled'] ?? 0),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : context.adminCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.black : context.adminBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(f.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : context.adminTextSecondary)),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withAlpha(50) : context.adminBorder.withAlpha(128),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${f.count}', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600,
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

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildOrderList(context)),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: _selectedOrder != null
              ? _DetailPanel(order: _selectedOrder!, pulseAnimation: _pulseAnimation)
              : _buildEmptyDetail(context),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) => _buildOrderList(context);

  Widget _buildEmptyDetail(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app, size: 36, color: context.adminTextMuted),
            const SizedBox(height: 16),
            Text(
              s.selectOrderHint,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: context.adminTextMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;
    final orders = _filteredOrders;
    if (orders.isEmpty) {
      return Center(
        child: Text(s.noOrdersFound, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextMuted)),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey('$_selectedFilter-$_searchQuery'),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (_, i) => _OrderCard(
          order: orders[i],
          isSelected: _selectedOrderId == orders[i].id,
          onTap: () => setState(() => _selectedOrderId = orders[i].id),
          onMarkReady: () {
            final idx = _orders.indexWhere((o) => o.id == orders[i].id);
            if (idx != -1) {
              setState(() { _orders[idx].status = 'ready'; });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(s.orderMarkedReadyMsg.replaceAll('{{id}}', orders[i].id)),
                backgroundColor: AdminOrdersColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ));
            }
          },
          onAssignDriver: () => _showAssignDriverDialog(context, orders[i]),
          onCancelOrder: () {
            setState(() {
              final idx = _orders.indexWhere((o) => o.id == orders[i].id);
              if (idx != -1) _orders[idx].status = 'cancelled';
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(s.orderCancelledMsg.replaceAll('{{id}}', orders[i].id)),
              backgroundColor: AdminOrdersColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ));
          },
          onCallPhone: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Calling ${orders[i].customerPhone}...'),
              backgroundColor: AdminOrdersColors.teal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ));
          },
        ),
      ),
    );
  }

  void _showAssignDriverDialog(BuildContext ctx, OrderModel order) {
    final s = ctx.read<LanguageProvider>().strings;
    final drivers = [
      DriverModel(name: 'Youssef B.', initials: 'YB', rating: 4.9, statusText: 'available'),
      DriverModel(name: 'Khalid M.', initials: 'KM', rating: 4.8, statusText: 'available'),
      DriverModel(name: 'Amine R.', initials: 'AR', rating: 4.7, statusText: 'available'),
    ];

    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: ctx.adminCard,
        title: Text(s.assignDriverTitle, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: ctx.adminTextPrimary)),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: drivers.map((d) => RadioListTile<DriverModel>(
            value: d, groupValue: d,
            title: Text(d.name, style: GoogleFonts.inter(fontSize: 13, color: ctx.adminTextPrimary)),
            subtitle: Text('★ ${d.rating}', style: GoogleFonts.inter(fontSize: 11, color: ctx.adminTextMuted)),
            activeColor: AdminOrdersColors.teal,
            contentPadding: EdgeInsets.zero,
            onChanged: (_) {
              final idx = _orders.indexWhere((o) => o.id == order.id);
              if (idx != -1) {
                setState(() { _orders[idx].driver = d; });
              }
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(s.driverAssignedMsg
                    .replaceAll('{{name}}', d.name)
                    .replaceAll('{{id}}', order.id)),
                backgroundColor: AdminOrdersColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ));
            },
          )).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx),
              child: Text(s.cancel, style: TextStyle(color: ctx.adminTextMuted))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  ORDER CARD
// ═══════════════════════════════════════════════════════════════════
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onMarkReady;
  final VoidCallback onAssignDriver;
  final VoidCallback onCancelOrder;
  final VoidCallback onCallPhone;

  const _OrderCard({
    required this.order,
    required this.isSelected,
    required this.onTap,
    required this.onMarkReady,
    required this.onAssignDriver,
    required this.onCancelOrder,
    required this.onCallPhone,
  });

  Color get _borderColor {
    switch (order.status) {
      case 'pending': case 'preparing': return AdminOrdersColors.gold;
      case 'ready': return AdminOrdersColors.blue;
      case 'delivering': return AdminOrdersColors.purple;
      case 'delivered': return AdminOrdersColors.teal;
      case 'cancelled': return AdminOrdersColors.red;
      default: return Colors.grey;
    }
  }

  Map<String, Color> get _statusStyle {
    switch (order.status) {
      case 'pending': case 'preparing': return {'bg': AdminOrdersColors.goldLight, 'text': const Color(0xFF633806)};
      case 'ready': return {'bg': AdminOrdersColors.blueLight, 'text': const Color(0xFF0C447C)};
      case 'delivering': return {'bg': AdminOrdersColors.purpleLight, 'text': const Color(0xFF3C3489)};
      case 'delivered': return {'bg': AdminOrdersColors.tealLight, 'text': AdminOrdersColors.success};
      case 'cancelled': return {'bg': AdminOrdersColors.redLight, 'text': AdminOrdersColors.danger};
      default: return {'bg': Colors.grey.shade100, 'text': Colors.grey.shade700};
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<LanguageProvider>().strings;
    final style = _statusStyle;
    final statusLabel = s.statusLabel(order.status);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.adminCard,
          border: Border.all(color: context.adminBorder, width: 0.5),
          boxShadow: isSelected
              ? [BoxShadow(color: _borderColor.withAlpha(25), blurRadius: 8, spreadRadius: 2)]
              : [BoxShadow(color: context.adminShadow, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Positioned(left: 0, top: 0, bottom: 0,
              child: Container(width: 3,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                ),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(order.id, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: style['bg'], borderRadius: BorderRadius.circular(12)),
                        child: Text(statusLabel, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: style['text'])),
                      ),
                      const Spacer(),
                      Text(order.timeAgo, style: GoogleFonts.inter(fontSize: 11, color: context.adminTextMuted)),
                      const SizedBox(width: 4),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, size: 16, color: context.adminTextMuted),
                        color: context.adminCard,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onSelected: (v) {},
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'view', child: Text(s.viewDetails, style: const TextStyle(fontSize: 13))),
                          PopupMenuItem(value: 'print', child: Text(s.printReceipt, style: const TextStyle(fontSize: 13))),
                          PopupMenuItem(value: 'contact', child: Text(s.contactCustomer, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Text('${order.customerName} · ${order.storeName}',
                        style: GoogleFonts.inter(fontSize: 13, color: context.adminTextSecondary)),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: onCallPhone,
                      child: Row(children: [
                        Icon(Icons.phone, size: 13, color: AdminOrdersColors.teal),
                        const SizedBox(width: 4),
                        Text(order.customerPhone,
                            style: GoogleFonts.inter(fontSize: 12, color: AdminOrdersColors.teal, decoration: TextDecoration.underline)),
                      ]),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text('${order.price} ${s.dh}',
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                      const SizedBox(width: 8),
                      Text('${order.itemCount} ${s.items}',
                          style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
                    ]),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.location_on, size: 13, color: context.adminTextMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(order.address,
                            style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted),
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: context.adminDivider),
                    const SizedBox(height: 8),
                    Row(children: [
                      if (order.distanceKm != null) ...[
                        _metaChip(Icons.route, '${order.distanceKm!.toStringAsFixed(1)} km', AdminOrdersColors.teal),
                        const SizedBox(width: 8),
                      ],
                      if (order.etaText != null)
                        _metaChip(Icons.timer_outlined, order.etaText!, AdminOrdersColors.teal),
                      const SizedBox(width: 8),
                      if (order.confirmedAt != null)
                        _metaChip(Icons.check_circle_outline, '${s.confirmedAtLabel} ${order.confirmedAt}', AdminOrdersColors.teal),
                    ]),
                    if (order.driver != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: context.adminDivider))),
                        child: Row(children: [
                          CircleAvatar(radius: 12, backgroundColor: AdminOrdersColors.tealLight,
                            child: Text(order.driver!.initials,
                                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AdminOrdersColors.teal))),
                          const SizedBox(width: 8),
                          Text(order.driver!.name,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                          const Spacer(),
                          Text('★ ${order.driver!.rating} · ${order.driver!.statusText}',
                              style: GoogleFonts.inter(fontSize: 11, color: context.adminTextMuted)),
                        ]),
                      ),
                    ],
                    if (order.driver == null && (order.status == 'pending' || order.status == 'preparing')) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onAssignDriver,
                          icon: const Icon(Icons.person_add_alt, size: 16),
                          label: Text(s.assignDriver, style: GoogleFonts.inter(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AdminOrdersColors.teal,
                            side: BorderSide(color: AdminOrdersColors.teal.withAlpha(102)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                    if (order.status == 'pending') ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onMarkReady,
                            icon: const Icon(Icons.check, size: 16),
                            label: Text(s.markReady, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminOrdersColors.tealLight,
                              foregroundColor: AdminOrdersColors.success,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onCancelOrder,
                            icon: const Icon(Icons.close, size: 16),
                            label: Text(s.cancelOrder, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminOrdersColors.redLight,
                              foregroundColor: AdminOrdersColors.danger,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String text, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 3),
      Text(text, style: GoogleFonts.inter(fontSize: 10, color: color)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  DETAIL PANEL (right side — wide layout)
// ═══════════════════════════════════════════════════════════════════
class _DetailPanel extends StatelessWidget {
  final OrderModel order;
  final Animation<double> pulseAnimation;

  const _DetailPanel({required this.order, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    final s = context.read<LanguageProvider>().strings;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(children: [
            Expanded(
              child: Text(order.id, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusBg(order.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(s.statusLabel(order.status),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _statusFg(order.status))),
            ),
          ]),
          const SizedBox(height: 20),

          // Customer card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.adminBorder, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(radius: 18, backgroundColor: AdminOrdersColors.tealLight,
                    child: Text(order.customerName[0].toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AdminOrdersColors.teal))),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(order.customerName,
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                    Text(order.customerPhone,
                        style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
                  ]),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Icon(Icons.store_outlined, size: 14, color: context.adminTextMuted),
                  const SizedBox(width: 6),
                  Text(order.storeName, style: GoogleFonts.inter(fontSize: 13, color: context.adminTextSecondary)),
                ]),
                const SizedBox(height: 4),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.location_on_outlined, size: 14, color: context.adminTextMuted),
                  const SizedBox(width: 6),
                  Expanded(child: Text(order.address, style: GoogleFonts.inter(fontSize: 13, color: context.adminTextSecondary))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Order details
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.adminBorder, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Details', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                const SizedBox(height: 12),
                _detailRow(s.priceLabel, '${order.price} ${s.dh}', context),
                _detailRow(s.itemsLabel, '${order.itemCount}', context),
                _detailRow('Time', order.timeAgo, context),
                if (order.distanceKm != null)
                  _detailRow(s.distanceLabel, '${order.distanceKm!.toStringAsFixed(1)} km', context),
                if (order.etaText != null)
                  _detailRow('ETA', order.etaText!, context),
                if (order.confirmedAt != null)
                  _detailRow(s.confirmedAtLabel, order.confirmedAt!, context),
                _detailRow(s.pickupLabel, order.pickupArea, context),
                _detailRow(s.dropoffLabel, order.dropoffArea, context),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Driver card (if assigned)
          if (order.driver != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.adminCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.adminBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Driver', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                  const SizedBox(height: 10),
                  Row(children: [
                    CircleAvatar(radius: 20, backgroundColor: AdminOrdersColors.tealLight,
                      child: Text(order.driver!.initials,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AdminOrdersColors.teal))),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(order.driver!.name,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                      Text('★ ${order.driver!.rating} · ${order.driver!.statusText}',
                          style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
                    ]),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Timeline
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.adminBorder, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.timelineLabel, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                const SizedBox(height: 12),
                ...order.timeline.asMap().entries.map((entry) {
                  final i = entry.key;
                  final step = entry.value;
                  final isLast = i == order.timeline.length - 1;
                  return _timelineStep(step, isLast, context);
                }),
              ],
            ),
          ),

          // Cancel reason if cancelled
          if (order.status == 'cancelled' && order.cancelReason != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AdminOrdersColors.redLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AdminOrdersColors.red.withAlpha(50)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, size: 16, color: AdminOrdersColors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(order.cancelReason!,
                    style: GoogleFonts.inter(fontSize: 12, color: AdminOrdersColors.danger))),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
        Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.adminTextPrimary)),
      ]),
    );
  }

  Widget _timelineStep(TimelineStep step, bool isLast, BuildContext context) {
    final isDone = step.state == 'done';
    final isCurrent = step.state == 'current';
    final dotColor = isDone ? AdminOrdersColors.teal : isCurrent ? AdminOrdersColors.gold : context.adminBorder;
    final lineColor = isDone ? AdminOrdersColors.teal : context.adminBorder;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: lineColor),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.label,
                      style: GoogleFonts.inter(fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isCurrent ? context.adminTextPrimary : context.adminTextMuted)),
                  Text(step.time,
                      style: GoogleFonts.inter(fontSize: 11, color: isCurrent ? AdminOrdersColors.teal : context.adminTextMuted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'pending': case 'preparing': return AdminOrdersColors.goldLight;
      case 'ready': return AdminOrdersColors.blueLight;
      case 'delivering': return AdminOrdersColors.purpleLight;
      case 'delivered': return AdminOrdersColors.tealLight;
      case 'cancelled': return AdminOrdersColors.redLight;
      default: return Colors.grey.shade100;
    }
  }

  Color _statusFg(String status) {
    switch (status) {
      case 'pending': case 'preparing': return const Color(0xFF633806);
      case 'ready': return const Color(0xFF0C447C);
      case 'delivering': return const Color(0xFF3C3489);
      case 'delivered': return AdminOrdersColors.success;
      case 'cancelled': return AdminOrdersColors.danger;
      default: return Colors.grey.shade700;
    }
  }
}