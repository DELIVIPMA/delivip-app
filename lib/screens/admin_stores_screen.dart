import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADMIN STORES SCREEN — Store Management with product tables
// ═══════════════════════════════════════════════════════════════════

// ─── COLORS ───────────────────────────────────────────────────────
const _teal = Color(0xFF1AA49B);
const _tealLight = Color(0xFFE1F5EE);
const _gold = Color(0xFFEF9F27);
const _goldLight = Color(0xFFFAEEDA);
const _bg = Color(0xFFF6F6F6);
const _cardBg = Colors.white;
const _success = Color(0xFF0F6E56);
const _danger = Color(0xFFA32D2D);

// ═══════════════════════════════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════════════════════════════

class ProductModel {
  final String name;
  final String category;
  final int price;
  final int orders;
  final bool available;

  const ProductModel({
    required this.name,
    required this.category,
    required this.price,
    this.orders = 0,
    this.available = true,
  });
}

class StoreModel {
  final String id;
  final String name;
  final String emoji;
  final Color bgColor;
  final String category; // restaurants, supermarkets, boutiques
  final String status; // active, inactive
  final double rating;
  final String location;
  final bool isNew;
  final List<ProductModel> products;

  const StoreModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.bgColor,
    required this.category,
    required this.status,
    required this.rating,
    required this.location,
    this.isNew = false,
    required this.products,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  MOCK DATA
// ═══════════════════════════════════════════════════════════════════

final _mockStores = [
  StoreModel(
    id: '1',
    name: 'Pizza Hut',
    emoji: '🍕',
    bgColor: const Color(0xFFFFF3E0),
    category: 'restaurants',
    status: 'active',
    rating: 4.8,
    location: 'Casablanca',
    products: const [
      ProductModel(name: 'Margherita', category: 'Pizza', price: 45, orders: 124),
      ProductModel(name: 'Pepperoni', category: 'Pizza', price: 55, orders: 98),
      ProductModel(name: 'Quatre Fromages', category: 'Pizza', price: 65, orders: 72),
      ProductModel(name: 'Pizza Végétarienne', category: 'Pizza', price: 50, orders: 54),
    ],
  ),
  StoreModel(
    id: '2',
    name: "McDonald's",
    emoji: '🍔',
    bgColor: const Color(0xFFFFF8E1),
    category: 'restaurants',
    status: 'active',
    rating: 4.6,
    location: 'Rabat',
    products: const [
      ProductModel(name: 'Big Mac', category: 'Burger', price: 35, orders: 210),
      ProductModel(name: 'McChicken', category: 'Burger', price: 28, orders: 167),
      ProductModel(name: 'Frites', category: 'Side', price: 15, orders: 345),
      ProductModel(name: 'McFlurry Oreo', category: 'Dessert', price: 22, orders: 89, available: false),
    ],
  ),
  StoreModel(
    id: '3',
    name: 'Sushi Shop',
    emoji: '🍣',
    bgColor: const Color(0xFFE8F5E9),
    category: 'restaurants',
    status: 'active',
    rating: 4.7,
    location: 'Marrakech',
    products: const [
      ProductModel(name: 'California Roll', category: 'Sushi', price: 55, orders: 87),
      ProductModel(name: 'Spicy Tuna', category: 'Sushi', price: 65, orders: 63),
      ProductModel(name: 'Salmon Sashimi', category: 'Sashimi', price: 80, orders: 41),
      ProductModel(name: 'Miso Soup', category: 'Soup', price: 18, orders: 112),
    ],
  ),
  StoreModel(
    id: '4',
    name: 'Taco Bell',
    emoji: '🌮',
    bgColor: const Color(0xFFF3E5F5),
    category: 'restaurants',
    status: 'inactive',
    rating: 4.3,
    location: 'Tanger',
    products: const [
      ProductModel(name: 'Crunchy Taco', category: 'Taco', price: 25, orders: 22, available: false),
      ProductModel(name: 'Burrito', category: 'Burrito', price: 38, orders: 18, available: false),
      ProductModel(name: 'Nachos', category: 'Side', price: 20, orders: 14, available: false),
    ],
  ),
  StoreModel(
    id: '5',
    name: 'Marjane',
    emoji: '🏪',
    bgColor: const Color(0xFFE3F2FD),
    category: 'supermarkets',
    status: 'active',
    rating: 4.3,
    location: 'Casablanca',
    isNew: true,
    products: const [
      ProductModel(name: 'Tomates', category: 'Légumes', price: 8, orders: 312),
      ProductModel(name: 'Lait', category: 'Produits laitiers', price: 7, orders: 289),
      ProductModel(name: 'Pain', category: 'Boulangerie', price: 5, orders: 458),
      ProductModel(name: 'Poulet', category: 'Viande', price: 42, orders: 134),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════

class AdminStoresScreen extends StatefulWidget {
  const AdminStoresScreen({super.key});

  @override
  State<AdminStoresScreen> createState() => _AdminStoresScreenState();
}

class _AdminStoresScreenState extends State<AdminStoresScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, restaurants, supermarkets, boutiques, inactive
  Set<String> _expandedStores = {'pizza'};
  int _filterCycle = 0; // 0 = All, 1 = Active, 2 = Inactive

  List<StoreModel> get _stores => _mockStores;

  List<StoreModel> get _filteredStores {
    var list = _stores.where((s) {
      if (_selectedFilter == 'restaurants') return s.category == 'restaurants';
      if (_selectedFilter == 'supermarkets') return s.category == 'supermarkets';
      if (_selectedFilter == 'boutiques') return s.category == 'boutiques';
      if (_selectedFilter == 'inactive') return s.status == 'inactive';
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((s) {
        if (s.name.toLowerCase().contains(q)) return true;
        for (final p in s.products) {
          if (p.name.toLowerCase().contains(q)) return true;
        }
        return false;
      }).toList();
    }

    return list;
  }

  int get _totalStores => _stores.length;
  int get _activeStores => _stores.where((s) => s.status == 'active').length;
  int get _totalProducts => _stores.fold(0, (sum, s) => sum + s.products.length);
  double get _avgRating {
    if (_stores.isEmpty) return 0;
    return _stores.fold(0.0, (sum, s) => sum + s.rating) / _stores.length;
  }

  void _cycleFilter() {
    _filterCycle = (_filterCycle + 1) % 3;
    if (_filterCycle == 0) _selectedFilter = 'all';
    else if (_filterCycle == 1) _selectedFilter = 'all';
    // We'll use the filter chips for specifics, this cycles All/Active/Inactive
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _expandedStores = {'1'}; // Pizza Hut expanded by default
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 1. TOP BAR ─────────────────────────────────
          _buildTopBar(context),
          const SizedBox(height: 24),

          // ─── 2. STATS ROW ──────────────────────────────
          _buildStatsRow(context),
          const SizedBox(height: 24),

          // ─── 3. FILTER CHIPS ───────────────────────────
          _buildFilterChips(context),
          const SizedBox(height: 24),

          // ─── 4. STORE LIST ─────────────────────────────
          ..._filteredStores.map((store) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _StoreCard(
                  store: store,
                  isExpanded: _expandedStores.contains(store.id),
                  onToggle: () {
                    setState(() {
                      if (_expandedStores.contains(store.id)) {
                        _expandedStores.remove(store.id);
                      } else {
                        _expandedStores.add(store.id);
                      }
                    });
                  },
                  onEdit: () => _showEditStoreDialog(context, store),
                  onToggleStatus: () => _toggleStatus(store),
                  onDelete: () => _showDeleteDialog(context, store),
                  onAddProduct: () => _showAddProductDialog(context, store),
                ),
              )),
        ],
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Text('Store Management',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const SizedBox(width: 20),
        // Search
        SizedBox(
          width: 220,
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Search stores or products...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search_rounded, size: 16, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Filter button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton.icon(
            onPressed: _cycleFilter,
            icon: Icon(Icons.filter_list_rounded, size: 16, color: Colors.grey.shade700),
            label: Text(
              _filterCycle == 0 ? 'All' : _filterCycle == 1 ? 'Active' : 'Inactive',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
          ),
        ),
        const Spacer(),
        // New Store button
        ElevatedButton.icon(
          onPressed: () => _showAddStoreDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: Text('New Store',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // ─── STATS ROW ────────────────────────────────────────────────

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _statCard(Icons.store_rounded, '$_totalStores', 'Total stores', _tealLight, _teal)),
        const SizedBox(width: 12),
        Expanded(child: _statCard(Icons.check_circle, '$_activeStores', 'Active', _tealLight, _teal)),
        const SizedBox(width: 12),
        Expanded(child: _statCard(Icons.inventory_2, '$_totalProducts', 'Total products', _goldLight, _gold)),
        const SizedBox(width: 12),
        Expanded(child: _statCard(Icons.star, _avgRating.toStringAsFixed(1), 'Avg rating', _goldLight, Colors.amber)),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500,
                      color: Colors.black87)),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── FILTER CHIPS ──────────────────────────────────────────────

  Widget _buildFilterChips(BuildContext context) {
    final filters = ['All stores', 'Restaurants', 'Supermarkets', 'Boutiques', 'Inactive'];
    final values = ['all', 'restaurants', 'supermarkets', 'boutiques', 'inactive'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (i) {
          final isSelected = _selectedFilter == values[i];
          final isInactive = values[i] == 'inactive';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filters[i],
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400)),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = values[i]),
              selectedColor: isInactive ? Colors.amber.shade400 : _teal,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                width: 0.5,
              ),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          );
        }),
      ),
    );
  }

  // ─── DIALOGS ──────────────────────────────────────────────────

  void _showAddStoreDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    String selectedCategory = 'restaurants';
    String selectedEmoji = '🏪';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.store_rounded, size: 18, color: _teal),
              ),
              const SizedBox(width: 10),
              Text('New Store',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Store name',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  style: GoogleFonts.inter(fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'restaurants', child: Text('Restaurants')),
                    DropdownMenuItem(value: 'supermarkets', child: Text('Supermarkets')),
                    DropdownMenuItem(value: 'boutiques', child: Text('Boutiques')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedCategory = v ?? 'restaurants'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: locationCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Emoji',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['🏪', '🍕', '🍔', '🍣', '🌮', '🥗', '🍜', '☕'].map((e) {
                    final isSelected = selectedEmoji == e;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedEmoji = e),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? _tealLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: _teal, width: 1.5)
                              : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Center(child: Text(e, style: const TextStyle(fontSize: 20))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ "${nameCtrl.text}" store added!'),
                    backgroundColor: _teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add Store', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStoreDialog(BuildContext context, StoreModel store) {
    final nameCtrl = TextEditingController(text: store.name);
    final locationCtrl = TextEditingController(text: store.location);
    String selectedCategory = store.category;
    String selectedEmoji = store.emoji;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.edit_outlined, size: 18, color: _teal),
              ),
              const SizedBox(width: 10),
              Text('Edit Store',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Store name',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  style: GoogleFonts.inter(fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'restaurants', child: Text('Restaurants')),
                    DropdownMenuItem(value: 'supermarkets', child: Text('Supermarkets')),
                    DropdownMenuItem(value: 'boutiques', child: Text('Boutiques')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedCategory = v ?? 'restaurants'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: locationCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Emoji',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['🏪', '🍕', '🍔', '🍣', '🌮', '🥗', '🍜', '☕'].map((e) {
                    final isSelected = selectedEmoji == e;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedEmoji = e),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? _tealLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: _teal, width: 1.5)
                              : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Center(child: Text(e, style: const TextStyle(fontSize: 20))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ "${nameCtrl.text}" updated!'),
                    backgroundColor: _teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save Changes', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, StoreModel store) {
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    bool available = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.add_circle_outline, size: 18, color: _teal),
              ),
              const SizedBox(width: 10),
              Text('Add Product to ${store.name}',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Product name',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: categoryCtrl,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Price (MAD)',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                    suffixText: 'MAD',
                    suffixStyle: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('Available',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700)),
                    const Spacer(),
                    Switch(
                      value: available,
                      activeColor: _teal,
                      onChanged: (v) => setDialogState(() => available = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ "${nameCtrl.text}" added to ${store.name}!'),
                    backgroundColor: _teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add Product', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, StoreModel store) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.delete_outline, size: 18, color: _danger),
            ),
            const SizedBox(width: 10),
            Text('Delete ${store.name}?',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text('This action cannot be undone.',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ "${store.name}" deleted!'),
                  backgroundColor: _danger,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(StoreModel store) {
    setState(() {
      // In a real app, this would modify the store data
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(store.status == 'active'
            ? '⏸️ "${store.name}" deactivated'
            : '✅ "${store.name}" activated'),
        backgroundColor: store.status == 'active' ? Colors.amber.shade700 : _teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STORE CARD
// ═══════════════════════════════════════════════════════════════════

class _StoreCard extends StatefulWidget {
  final StoreModel store;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final VoidCallback onAddProduct;

  const _StoreCard({
    required this.store,
    required this.isExpanded,
    required this.onToggle,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onAddProduct,
  });

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  int? _hoveredProductIndex;

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    final isActive = s.status == 'active';

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // ── A) STORE HEADER ──
          InkWell(
            onTap: widget.onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: s.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(s.emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name,
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w500,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _tagChip(s.category),
                            const SizedBox(width: 8),
                            Text('${s.products.length} products',
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey.shade600)),
                            const SizedBox(width: 8),
                            Icon(Icons.location_on_outlined,
                                size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 2),
                            Text(s.location,
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 13, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(s.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? _tealLight
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s.isNew
                          ? 'New'
                          : isActive
                              ? 'Active'
                              : 'Inactive',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: s.isNew
                            ? Colors.amber.shade800
                            : isActive
                                ? _success
                                : _danger,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Chevron
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down,
                        size: 20, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),

          // ── B) PRODUCT TABLE ──
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: widget.isExpanded
                ? Column(
                    children: [
                      Divider(height: 1, color: Colors.grey.shade200),
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        color: const Color(0xFFF6F6F6),
                        child: Row(
                          children: [
                            _headerCell('Product', flex: 3),
                            _headerCell('Category', flex: 2),
                            _headerCell('Price', flex: 1),
                            _headerCell('Orders', flex: 1),
                            _headerCell('Status', flex: 2),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      // Product rows
                      ...List.generate(s.products.length, (i) {
                        final p = s.products[i];
                        return MouseRegion(
                          onEnter: (_) =>
                              setState(() => _hoveredProductIndex = i),
                          onExit: (_) =>
                              setState(() => _hoveredProductIndex = null),
                          child: Container(
                            color: _hoveredProductIndex == i
                                ? const Color(0xFFF6F6F6)
                                : Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade200, width: 0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Product name
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30, height: 30,
                                          decoration: BoxDecoration(
                                            color: _tealLight,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.restaurant,
                                                size: 14, color: _teal),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(p.name,
                                            style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                  // Category
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: _tealLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(p.category,
                                          style: GoogleFonts.inter(
                                              fontSize: 11, color: _success)),
                                    ),
                                  ),
                                  // Price
                                  Expanded(
                                    flex: 1,
                                    child: Text('${p.price} MAD',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: _teal)),
                                  ),
                                  // Orders
                                  Expanded(
                                    flex: 1,
                                    child: Text('${p.orders}',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.black87)),
                                  ),
                                  // Status
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Icon(
                                          p.available
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          size: 14,
                                          color: p.available
                                              ? _success
                                              : _danger,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          p.available
                                              ? 'Available'
                                              : 'Unavailable',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: p.available
                                                ? _success
                                                : _danger,
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
                      }),
                      // Add product row
                      InkWell(
                        onTap: widget.onAddProduct,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          color: const Color(0xFFF6F6F6),
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 16, color: _teal),
                              const SizedBox(width: 6),
                              Text('Add product',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: _teal)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // ── C) ACTION BUTTONS ──
          if (widget.isExpanded)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: widget.onEdit,
                      icon: Icon(Icons.edit_outlined, size: 16, color: _teal),
                      label: Text('Edit store',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: _teal)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5, height: 24,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: widget.onToggleStatus,
                      icon: Icon(
                        widget.store.status == 'active'
                            ? Icons.power_settings_new
                            : Icons.power_settings_new,
                        size: 16,
                        color: widget.store.status == 'active'
                            ? Colors.amber.shade700
                            : Colors.green,
                      ),
                      label: Text(
                        widget.store.status == 'active'
                            ? 'Deactivate'
                            : 'Activate',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: widget.store.status == 'active'
                              ? Colors.amber.shade700
                              : Colors.green,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5, height: 24,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: Icon(Icons.delete_outline, size: 16, color: _danger),
                      label: Text('Delete',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: _danger)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4)),
    );
  }

  Widget _tagChip(String category) {
    String label;
    Color bg;
    Color textColor;
    switch (category) {
      case 'restaurants':
        label = 'Restaurant';
        bg = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        break;
      case 'supermarkets':
        label = 'Supermarket';
        bg = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      case 'boutiques':
        label = 'Boutique';
        bg = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        break;
      default:
        label = category;
        bg = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: GoogleFonts.inter(fontSize: 10, color: textColor)),
    );
  }
}

