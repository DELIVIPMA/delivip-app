import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/admin_models.dart';
import '../data/app_data_provider.dart';
import '../data/localization.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADMIN DASHBOARD SCREEN — Full Backoffice DeliVip
//  Contrôle total : Dashboard, Stores, Produits, Commandes, Clients,
//  Catégories, Paramètres de l'app — avec Dark Mode 🌙
//  Maintenant avec support EN / FR / AR 🎉
// ═══════════════════════════════════════════════════════════════════

class AdminDashboardScreen extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  const AdminDashboardScreen({
    super.key,
    this.initialThemeMode = ThemeMode.light,
    this.onThemeModeChanged,
  });

  @override
  State<AdminDashboardScreen> createState() => AdminDashboardScreenState();
}

class AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // ─── Navigation ──────────────────────────────────────────
  int _selectedIndex = 0;

  // ─── Données ─────────────────────────────────────────────
  List<AdminStore> _stores = [];
  List<AdminOrder> _orders = [];
  List<AdminCategory> _categories = [];
  AppSettings _settings = AppSettings();

  // ─── Theme ───────────────────────────────────────────────
  late ThemeMode _themeMode;

  bool get _isDark => _themeMode == ThemeMode.dark;

  // ─── Helpers ─────────────────────────────────────────────
  AdminStrings get s => context.watch<LanguageProvider>().strings;
  AppLanguage get _currentLang => context.watch<LanguageProvider>().current;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppDataProvider>();
      setState(() {
        _stores = provider.stores;
        _orders = provider.orders;
        _categories = provider.categories;
        _settings = provider.settings;
      });
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _isDark ? ThemeMode.light : ThemeMode.dark;
      widget.onThemeModeChanged?.call(_themeMode);
    });
  }

  void _syncToProvider() {
    context.read<AppDataProvider>().updateStores(_stores);
    context.read<AppDataProvider>().updateOrders(_orders);
    context.read<AppDataProvider>().updateCategories(_categories);
    context.read<AppDataProvider>().updateSettings(_settings);
  }

  void _selectPage(int index) => setState(() => _selectedIndex = index);

  void _navigateToStores() => _selectPage(1);
  void _navigateToOrders() => _selectPage(2);
  void _navigateToDashboard() => _selectPage(0);

  // ─── BUILD ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.adminBg,
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(child: _buildPageContent(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════╗
  //  SIDEBAR                                                ║
  // ═════════════════════════════════════════════════════════╝
  Widget _buildSidebar(BuildContext context) {
    final items = [
      _SidebarItemData(Icons.dashboard, s.navDashboard, 0),
      _SidebarItemData(Icons.store, s.navStores, 1),
      _SidebarItemData(Icons.receipt_long, s.navOrders, 2),
      _SidebarItemData(Icons.people, s.navCustomers, 3),
      _SidebarItemData(Icons.category, s.navCategories, 4),
      _SidebarItemData(Icons.settings, s.navSettings, 5),
    ];

    return Container(
      width: 240,
      color: context.adminSidebarBg,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: DeliVipColors.headerGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delivery_dining, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Text('DELIVIP', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: context.adminTextBlackOrWhite)),
              ],
            ),
          ),
          Divider(height: 1, color: context.adminDivider),
          const SizedBox(height: 8),
          // Theme toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                Icon(_isDark ? Icons.dark_mode : Icons.light_mode, size: 16, color: context.adminTextMuted),
                const SizedBox(width: 8),
                Text(_isDark ? s.modeDark : s.modeLight, style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleTheme,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40, height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: _isDark ? DeliVipColors.teal : Colors.grey.shade300,
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: _isDark ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        width: 16, height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Language selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.language, size: 16, color: context.adminTextMuted),
                const SizedBox(width: 8),
                Text(s.languageLabel, style: GoogleFonts.inter(fontSize: 12, color: context.adminTextMuted)),
                const Spacer(),
                GestureDetector(
                  onTap: _showLanguagePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: DeliVipColors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${_currentLang.flag} ${_currentLang.label}', style: GoogleFonts.inter(fontSize: 11, color: DeliVipColors.teal, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (_, i) => _buildSidebarItem(context, items[i]),
            ),
          ),
          Divider(color: context.adminDivider),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF00BFA5),
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.adminLabel, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                    Text(s.superAdmin, style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.logout, size: 18, color: Colors.red.shade300),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    final langs = AppLanguage.values;
    showDialog(
      context: context,
      builder: (ctx) {
        final langProvider = context.read<LanguageProvider>();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: context.adminCard,
          title: Text(s.languageLabel, style: TextStyle(color: context.adminTextPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: langs.map((lang) {
              final selected = lang == _currentLang;
              return ListTile(
                leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
                title: Text(lang.label, style: GoogleFonts.inter(fontSize: 15, color: context.adminTextPrimary, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
                trailing: selected ? Icon(Icons.check_circle, color: DeliVipColors.teal) : null,
                onTap: () {
                  langProvider.setLanguage(lang);
                  Navigator.pop(ctx);
                  setState(() {});
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSidebarItem(BuildContext context, _SidebarItemData item) {
    final isActive = _selectedIndex == item.index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () => _selectPage(item.index),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? DeliVipColors.teal.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: isActive ? DeliVipColors.teal : context.adminTextMuted),
                const SizedBox(width: 12),
                Text(item.label, style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? DeliVipColors.teal : context.adminTextSecondary,
                )),
                const Spacer(),
                if (isActive)
                  Container(width: 4, height: 20, decoration: BoxDecoration(
                    color: DeliVipColors.teal,
                    borderRadius: BorderRadius.circular(2),
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════╗
  //  TOP BAR                                                ║
  // ═════════════════════════════════════════════════════════╝
  Widget _buildTopBar(BuildContext context) {
    final titles = [s.navDashboard, s.storeManagement, s.orderManagement, s.navCustomers, s.navCategories, s.appSettings];
    return Container(
      height: 64,
      color: context.adminTopbarBg,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(titles[_selectedIndex], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const Spacer(),
          if (_selectedIndex == 0) ...[
            _badge(context, '${_stores.length}', s.navStores),
            const SizedBox(width: 12),
            _badge(context, '${_orders.length}', s.navOrders),
            const SizedBox(width: 12),
            _badge(context, _orders.where((o) => o.status == 'pending' || o.status == 'preparing').length.toString(), s.inProgress, isAlert: true),
          ],
          const Spacer(),
          Icon(Icons.notifications_outlined, size: 22, color: context.adminTextSecondary),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: DeliVipColors.teal,
            child: Text('A', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String count, String label, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAlert ? Colors.orange.withValues(alpha: 0.1) : DeliVipColors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isAlert ? Colors.orange : DeliVipColors.teal)),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: isAlert ? Colors.orange.shade700 : DeliVipColors.teal)),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════╗
  //  PAGE CONTENT                                           ║
  // ═════════════════════════════════════════════════════════╝
  Widget _buildPageContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0: return _buildDashboardPage(context);
      case 1: return _StoresPanel(
        stores: _stores,
        onUpdate: (s) {
          setState(() => _stores = s);
          _syncToProvider();
        },
      );
      case 2: return _OrdersPanel(
        orders: _orders,
        onUpdate: (o) {
          setState(() => _orders = o);
          _syncToProvider();
        },
      );
      case 3: return _CustomersPanel();
      case 4: return _CategoriesPanel(
        categories: _categories,
        onUpdate: (c) {
          setState(() => _categories = c);
          _syncToProvider();
        },
      );
      case 5: return _SettingsPanel(
        settings: _settings,
        onUpdate: (s) {
          setState(() => _settings = s);
          _syncToProvider();
        },
        onThemeToggle: _toggleTheme,
        isDarkMode: _isDark,
      );
      default: return const SizedBox();
    }
  }

  // ═════════════════════════════════════════════════════════╗
  //  DASHBOARD PAGE                                         ║
  // ═════════════════════════════════════════════════════════╝
  Widget _buildDashboardPage(BuildContext context) {
    final totalRevenue = _orders.fold(0.0, (sum, o) => sum + (o.status != 'cancelled' ? o.total : 0));
    final activeOrders = _orders.where((o) => o.status == 'pending' || o.status == 'preparing' || o.status == 'delivering').length;
    final totalCustomers = 892 + _orders.map((o) => o.customerName).toSet().length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCardGradient(title: s.totalOrders, value: '${_orders.length}', gradientColors: const [Color(0xFF2C0A0E), Color(0xFF4A151B)], icon: Icons.receipt_long),
              _StatCardGradient(title: s.revenue, value: '${totalRevenue.toStringAsFixed(0)} ${s.dh}', gradientColors: const [Color(0xFFFF9800), Color(0xFFF57C00)], icon: Icons.trending_up),
              _StatCardGradient(title: s.activeOrders, value: '$activeOrders', gradientColors: const [Color(0xFFE64A19), Color(0xFFD84315)], icon: Icons.delivery_dining),
              _StatCardGradient(title: s.customers, value: '$totalCustomers', gradientColors: const [Color(0xFF4CAF50), Color(0xFF388E3C)], icon: Icons.people),
            ],
          ),
          const SizedBox(height: 24),

          // Graphique + Activité récente
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.adminCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.adminBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(s.revenueOverview, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: DeliVipColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text('+23%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: DeliVipColors.teal)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [30, 45, 25, 60, 40, 75, 55, 35, 80, 65, 50, 70].asMap().entries.map((e) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 180 * (e.value / 100),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [DeliVipColors.teal, DeliVipColors.tealLight],
                                        ),
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Container(
                  height: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.adminCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.adminBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.recentOrders, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _orders.take(5).length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: context.adminDivider),
                          itemBuilder: (_, i) {
                            final o = _orders[i];
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  color: o.statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(_statusIcon(o.status), size: 16, color: o.statusColor),
                              ),
                              title: Text('${o.customerName} • ${o.storeName}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                              subtitle: Text('${o.total.toStringAsFixed(0)} ${s.dh}', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: o.statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(o.statusText, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: o.statusColor)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stores Overview
          Text(s.storesOverview, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 12),
          ..._stores.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.adminBorder),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: s.imageUrl.isNotEmpty
                      ? Image.network(s.imageUrl, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(width: 40, height: 40, color: Colors.grey.shade200, child: const Icon(Icons.store, color: Colors.grey)))
                      : Container(width: 40, height: 40, color: Colors.grey.shade200, child: Text(s.emoji, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                      Text('${s.products.length} ${this.s.productsCount} • ${s.category}', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s.isActive ? this.s.active : this.s.inactive, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: s.isActive ? const Color(0xFF2E7D32) : Colors.red)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.hourglass_empty;
      case 'confirmed': return Icons.check_circle_outline;
      case 'preparing': return Icons.restaurant;
      case 'ready': return Icons.shopping_bag;
      case 'delivering': return Icons.delivery_dining;
      case 'delivered': return Icons.check_circle;
      case 'cancelled': return Icons.cancel;
      default: return Icons.help_outline;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STAT CARD GRADIENT
// ═══════════════════════════════════════════════════════════════════
class _StatCardGradient extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> gradientColors;
  final IconData icon;

  const _StatCardGradient({required this.title, required this.value, required this.gradientColors, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(icon, size: 40, color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  COPYABLE TEXT — Click to copy any text to clipboard
// ═══════════════════════════════════════════════════════════════════
class _CopyableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool showIcon;

  const _CopyableText(this.text, {this.style, this.showIcon = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم النسخ: "$text"'),
            duration: const Duration(seconds: 1),
            backgroundColor: DeliVipColors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(12),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(text, style: style?.copyWith(decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted) ?? GoogleFonts.inter(decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted)),
          ),
          if (showIcon) ...[
            const SizedBox(width: 4),
            Icon(Icons.copy, size: 12, color: style?.color ?? DeliVipColors.teal),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SIDEBAR ITEM DATA
// ═══════════════════════════════════════════════════════════════════
class _SidebarItemData {
  final IconData icon;
  final String label;
  final int index;
  const _SidebarItemData(this.icon, this.label, this.index);
}

// ═══════════════════════════════════════════════════════════════════
//  STORES PANEL
// ═══════════════════════════════════════════════════════════════════
class _StoresPanel extends StatefulWidget {
  final List<AdminStore> stores;
  final ValueChanged<List<AdminStore>> onUpdate;
  const _StoresPanel({required this.stores, required this.onUpdate});

  @override
  State<_StoresPanel> createState() => _StoresPanelState();
}

class _StoresPanelState extends State<_StoresPanel> {
  int _tab = 0; // 0 = liste, 1 = ajouter
  bool _showInactive = true;
  String _searchQuery = '';

  AdminStrings get s => context.watch<LanguageProvider>().strings;

  List<AdminStore> get _filteredStores {
    var list = widget.stores.where((s) => _showInactive || s.isActive).toList();
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.adminTabBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _tabBtn(context, '${s.listView} (${widget.stores.length})', 0),
                          _tabBtn(context, s.newStore, 1),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_tab == 0)
                    Container(
                      width: 200,
                      height: 38,
                      decoration: BoxDecoration(
                        color: context.adminSearchBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: GoogleFonts.inter(fontSize: 13, color: context.adminTextPrimary),
                        decoration: InputDecoration(
                          hintText: s.searchStores,
                          hintStyle: TextStyle(color: context.adminTextMuted),
                          prefixIcon: Icon(Icons.search, size: 18, color: context.adminTextMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                ],
              ),
              if (_tab == 0)
                Row(
                  children: [
                    const SizedBox(width: 4),
                    SizedBox(
                      height: 32,
                      child: FilterChip(
                        label: Text(s.showInactive, style: GoogleFonts.inter(fontSize: 11, color: context.adminTextPrimary)),
                        selected: _showInactive,
                        onSelected: (v) => setState(() => _showInactive = v),
                        visualDensity: VisualDensity.compact,
                        selectedColor: Colors.orange.withValues(alpha: 0.15),
                        checkmarkColor: Colors.orange,
                        backgroundColor: context.adminCard,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _tab == 0 ? _buildList(context) : _StoreForm(
          store: null,
          onSave: (s) {
            final list = [...widget.stores, s];
            widget.onUpdate(list);
            setState(() => _tab = 0);
          },
          onCancel: () => setState(() => _tab = 0),
        )),
      ],
    );
  }

  Widget _tabBtn(BuildContext context, String label, int index) {
    final isSel = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSel ? context.adminCard : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
            color: isSel ? context.adminTextBlackOrWhite : context.adminTextMuted,
          )),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final list = _filteredStores;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏪', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(s.noStoresFound, style: GoogleFonts.poppins(fontSize: 16, color: context.adminGreyText)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => _tab = 1),
              style: ElevatedButton.styleFrom(backgroundColor: DeliVipColors.teal, foregroundColor: Colors.white),
              child: Text(s.addStore),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _buildStoreCard(context, list[i]),
    );
  }

  Widget _buildStoreCard(BuildContext context, AdminStore store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adminBorder),
        boxShadow: [
          BoxShadow(color: context.adminShadow, blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [DeliVipColors.teal, DeliVipColors.tealDark]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: store.imageUrl.isNotEmpty
                      ? Image.network(store.imageUrl, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(width: 48, height: 48, color: Colors.white24, child: Text(store.emoji, style: const TextStyle(fontSize: 24), textAlign: TextAlign.center)))
                      : Container(width: 48, height: 48, color: Colors.white24, child: Text(store.emoji, style: const TextStyle(fontSize: 28), textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('${store.products.length} ${s.productsCount} • ${store.category}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: store.isActive ? Colors.white.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(store.isActive ? s.active : s.inactive, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...store.products.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.adminBgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: DeliVipColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Icon(Icons.restaurant, size: 18, color: DeliVipColors.teal)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(p.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: context.adminTextPrimary))),
                      Text('${p.price.toStringAsFixed(0)} ${s.dh}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: DeliVipColors.teal)),
                      const SizedBox(width: 8),
                      Icon(p.isAvailable ? Icons.check_circle : Icons.cancel, size: 16, color: p.isAvailable ? const Color(0xFF4CAF50) : Colors.red),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editStore(context, store),
                        icon: const Icon(Icons.edit, size: 16),
                        label: Text(s.edit, style: GoogleFonts.inter(fontSize: 12)),
                        style: OutlinedButton.styleFrom(foregroundColor: DeliVipColors.teal),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deleteStore(context, store),
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                        label: Text(s.delete, style: GoogleFonts.inter(fontSize: 12, color: Colors.red)),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editStore(BuildContext context, AdminStore store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: context.adminBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _StoreForm(
          store: store,
          onSave: (s) {
            final list = widget.stores.map((e) => e.id == s.id ? s : e).toList();
            widget.onUpdate(list);
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _deleteStore(BuildContext context, AdminStore store) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.adminCard,
        title: Text(s.confirmDeleteTitle, style: TextStyle(color: context.adminTextPrimary)),
        content: Text(s.confirmDeleteMsg.replaceAll('{{name}}', store.name), style: TextStyle(color: context.adminTextSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: TextStyle(color: context.adminTextSecondary))),
          TextButton(onPressed: () {
            widget.onUpdate(widget.stores.where((s) => s.id != store.id).toList());
            Navigator.pop(ctx);
          }, child: Text(s.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STORE FORM
// ═══════════════════════════════════════════════════════════════════
class _StoreForm extends StatefulWidget {
  final AdminStore? store;
  final ValueChanged<AdminStore> onSave;
  final VoidCallback onCancel;

  const _StoreForm({this.store, required this.onSave, required this.onCancel});

  @override
  State<_StoreForm> createState() => _StoreFormState();
}

class _StoreFormState extends State<_StoreForm> {
  late AdminStore _store;
  late TextEditingController _nameCtrl, _descCtrl, _imageUrlCtrl, _emojiCtrl, _addressCtrl, _phoneCtrl, _openCtrl, _closeCtrl, _latCtrl, _lngCtrl;
  late List<TextEditingController> _pNames, _pDescs, _pPrices;

  AdminStrings get s => context.watch<LanguageProvider>().strings;

  bool get _isEditing => widget.store != null;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? AdminStore();
    _nameCtrl = TextEditingController(text: _store.name);
    _descCtrl = TextEditingController(text: _store.description);
    _imageUrlCtrl = TextEditingController(text: _store.imageUrl);
    _imageUrlCtrl.addListener(() => setState(() {}));
    _emojiCtrl = TextEditingController(text: _store.emoji);
    _addressCtrl = TextEditingController(text: _store.address);
    _phoneCtrl = TextEditingController(text: _store.phone);
    _openCtrl = TextEditingController(text: _store.openingHours);
    _closeCtrl = TextEditingController(text: _store.closingHours);
    _latCtrl = TextEditingController(text: _store.latitude.toString());
    _lngCtrl = TextEditingController(text: _store.longitude.toString());
    _initProductCtrls();
  }

  void _initProductCtrls() {
    _pNames = _store.products.map((p) => TextEditingController(text: p.name)).toList();
    _pDescs = _store.products.map((p) => TextEditingController(text: p.description)).toList();
    _pPrices = _store.products.map((p) => TextEditingController(text: p.price.toString())).toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _emojiCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _openCtrl.dispose();
    _closeCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    for (var c in [..._pNames, ..._pDescs, ..._pPrices]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_isEditing ? '✏️ ${s.edit}' : '➕ ${s.newStore}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: context.adminTextPrimary)),
              const Spacer(),
              IconButton(onPressed: widget.onCancel, icon: Icon(Icons.close, color: context.adminTextPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 3, child: _field(context, s.storeName, _nameCtrl, Icons.store)),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _field(context, s.emojiFallback, _emojiCtrl, Icons.emoji_emotions)),
            ],
          ),
          const SizedBox(height: 12),
          _field(context, s.imageUrl, _imageUrlCtrl, Icons.image),
          const SizedBox(height: 12),
          if (_imageUrlCtrl.text.isNotEmpty)
            Container(
              width: 80, height: 80,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.adminBorder),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(_imageUrlCtrl.text, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: Colors.grey.shade200, child: Icon(Icons.broken_image, color: Colors.grey.shade400))),
              ),
            ),
          const SizedBox(height: 12),
          _field(context, s.description, _descCtrl, Icons.description, maxLines: 3),
          const SizedBox(height: 12),
          _field(context, s.address, _addressCtrl, Icons.location_on),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field(context, s.phone, _phoneCtrl, Icons.phone)),
              const SizedBox(width: 12),
              Expanded(child: _field(context, s.openingHours, _openCtrl, Icons.wb_sunny)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field(context, s.closingHours, _closeCtrl, Icons.nightlight)),
              const SizedBox(width: 12),
              Expanded(child: _field(context, s.latitude, _latCtrl, Icons.map)),
              const SizedBox(width: 12),
              Expanded(child: _field(context, s.longitude, _lngCtrl, Icons.map)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.adminBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.toggle_on, color: DeliVipColors.teal),
                const SizedBox(width: 8),
                Text(s.storeActive, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextPrimary)),
                const Spacer(),
                Switch(value: _store.isActive, activeThumbColor: DeliVipColors.teal, onChanged: (v) => setState(() => _store.isActive = v)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('${s.productsCount} (${_store.products.length})', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
          const SizedBox(height: 8),
          ..._store.products.asMap().entries.map((e) => _productForm(context, e.key)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _store.products.add(AdminProduct());
                  _pNames.add(TextEditingController());
                  _pDescs.add(TextEditingController());
                  _pPrices.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.addProduct, style: GoogleFonts.inter(fontSize: 13)),
              style: OutlinedButton.styleFrom(foregroundColor: DeliVipColors.teal),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: DeliVipColors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(_isEditing ? s.save : s.addStoreBtn, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _field(BuildContext context, String label, TextEditingController ctrl, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: context.adminGreyText)),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl, maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 13, color: context.adminTextPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 16, color: DeliVipColors.teal),
            fillColor: context.adminCard,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.adminBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.adminBorder),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _productForm(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('${s.productsCount} #${i + 1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: DeliVipColors.teal)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() {
                  _store.products.removeAt(i);
                  _pNames.removeAt(i);
                  _pDescs.removeAt(i);
                  _pPrices.removeAt(i);
                }),
                child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.close, size: 14, color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _pNames[i],
                  style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary),
                  decoration: InputDecoration(
                    hintText: s.storeName,
                    hintStyle: TextStyle(color: context.adminTextMuted),
                    fillColor: context.adminBgLight,
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextFormField(
                  controller: _pPrices[i],
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary),
                  decoration: InputDecoration(
                    hintText: s.dh,
                    hintStyle: TextStyle(color: context.adminTextMuted),
                    fillColor: context.adminBgLight,
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                    suffixText: s.dh,
                    suffixStyle: TextStyle(color: context.adminTextMuted),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _pDescs[i],
            maxLines: 2,
            style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary),
            decoration: InputDecoration(
              hintText: s.description,
              hintStyle: TextStyle(color: context.adminTextMuted),
              fillColor: context.adminBgLight,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    _store.name = _nameCtrl.text;
    _store.description = _descCtrl.text;
    _store.imageUrl = _imageUrlCtrl.text;
    _store.emoji = _emojiCtrl.text;
    _store.address = _addressCtrl.text;
    _store.phone = _phoneCtrl.text;
    _store.openingHours = _openCtrl.text;
    _store.closingHours = _closeCtrl.text;
    _store.latitude = double.tryParse(_latCtrl.text) ?? 33.5731;
    _store.longitude = double.tryParse(_lngCtrl.text) ?? -7.5898;

    for (int i = 0; i < _store.products.length; i++) {
      _store.products[i].name = _pNames[i].text;
      _store.products[i].description = _pDescs[i].text;
      _store.products[i].price = double.tryParse(_pPrices[i].text) ?? 0.0;
    }

    widget.onSave(_store);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  ORDERS PANEL
// ═══════════════════════════════════════════════════════════════════
class _OrdersPanel extends StatefulWidget {
  final List<AdminOrder> orders;
  final ValueChanged<List<AdminOrder>> onUpdate;
  const _OrdersPanel({required this.orders, required this.onUpdate});

  @override
  State<_OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<_OrdersPanel> {
  String _statusFilter = 'all';
  String _search = '';

  AdminStrings get s => context.watch<LanguageProvider>().strings;

  List<AdminOrder> get _filtered {
    var list = widget.orders.where((o) => _statusFilter == 'all' || o.status == _statusFilter).toList();
    if (_search.isNotEmpty) {
      list = list.where((o) => o.customerName.toLowerCase().contains(_search.toLowerCase()) || o.id.contains(_search)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['all', 'pending', 'preparing', 'ready', 'delivering', 'delivered', 'cancelled'];
    final filterLabels = [s.all, s.pending, s.preparing, s.ready, s.delivering, s.delivered, s.cancelled];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            children: [
              Container(
                height: 38, width: double.infinity,
                decoration: BoxDecoration(
                  color: context.adminSearchBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: GoogleFonts.inter(fontSize: 13, color: context.adminTextPrimary),
                  decoration: InputDecoration(
                    hintText: s.searchOrders,
                    hintStyle: TextStyle(color: context.adminTextMuted),
                    prefixIcon: Icon(Icons.search, size: 18, color: context.adminTextMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => FilterChip(
                    label: Text('${filterLabels[i]} (${i == 0 ? widget.orders.length : widget.orders.where((o) => o.status == filters[i]).length})', style: GoogleFonts.inter(fontSize: 11, color: _statusFilter == filters[i] ? DeliVipColors.teal : context.adminTextSecondary)),
                    selected: _statusFilter == filters[i],
                    onSelected: (_) => setState(() => _statusFilter = filters[i]),
                    visualDensity: VisualDensity.compact,
                    selectedColor: DeliVipColors.teal.withValues(alpha: 0.15),
                    checkmarkColor: DeliVipColors.teal,
                    backgroundColor: context.adminCard,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _miniStat(context, s.total, '${widget.orders.length}', DeliVipColors.teal),
              const SizedBox(width: 16),
              _miniStat(context, s.inProgress, '${widget.orders.where((o) => o.status == 'pending' || o.status == 'preparing').length}', Colors.orange),
              const SizedBox(width: 16),
              _miniStat(context, s.delivered, '${widget.orders.where((o) => o.status == 'delivered').length}', const Color(0xFF4CAF50)),
              const SizedBox(width: 16),
              _miniStat(context, s.cancelled, '${widget.orders.where((o) => o.status == 'cancelled').length}', Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: _buildList(context)),
      ],
    );
  }

  Widget _miniStat(BuildContext context, String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(count, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: color)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(s.noOrders, style: GoogleFonts.poppins(fontSize: 16, color: context.adminGreyText)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _buildOrderCard(context, list[i]),
    );
  }

  Widget _buildOrderCard(BuildContext context, AdminOrder order) {
    final orderDateStr = '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}';
    final daysAgo = DateTime.now().difference(order.orderDate).inDays;
    final registrationLabel = daysAgo < 1 ? 'اليوم' : daysAgo < 7 ? 'منذ $daysAgo أيام' : orderDateStr;
    final strs = context.read<LanguageProvider>().strings; // use read not watch for event handlers

    void _showOrderItems() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: context.adminCard,
          title: Row(
            children: [
              const Icon(Icons.receipt_long, color: DeliVipColors.teal, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${strs.productsCount} — ${order.id}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: order.items.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: context.adminDivider),
              itemBuilder: (_, i) {
                final item = order.items[i];
                final itemTotal = item.price * item.quantity;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: DeliVipColors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text('${i + 1}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: DeliVipColors.teal))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                            Text('${item.quantity} × ${item.price.toStringAsFixed(0)} ${strs.dh}', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: DeliVipColors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${itemTotal.toStringAsFixed(0)} ${strs.dh}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: DeliVipColors.teal)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.adminBgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${strs.total}:', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: context.adminTextPrimary)),
                  Text('${order.total.toStringAsFixed(0)} ${strs.dh}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: DeliVipColors.teal)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: DeliVipColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('إغلاق', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.adminBorder),
        boxShadow: [
          BoxShadow(color: context.adminShadowLight, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 4, height: 150, decoration: BoxDecoration(color: order.statusColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ID + Status ──
                Row(
                  children: [
                    Text(order.id, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: context.adminTextPrimary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(order.statusText, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: order.statusColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${order.customerName} • ${order.storeName}', style: GoogleFonts.inter(fontSize: 12, color: context.adminGreyText)),
                // ── Phone (copiable) ──
                if (order.customerPhone.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 11, color: DeliVipColors.teal),
                        const SizedBox(width: 4),
                        _CopyableText(order.customerPhone, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: DeliVipColors.teal)),
                      ],
                    ),
                  ),
                Text('${order.total.toStringAsFixed(0)} ${strs.dh} • ${order.items.length} ${strs.items}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                Text(order.deliveryAddress, style: GoogleFonts.inter(fontSize: 10, color: context.adminGreyText)),
                const SizedBox(height: 4),
                // ── Registration date ──
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 11, color: context.adminGreyText),
                    const SizedBox(width: 4),
                    Text('زبون: $registrationLabel', style: GoogleFonts.inter(fontSize: 10, color: context.adminGreyText)),
                  ],
                ),
                const SizedBox(height: 4),
                // ── Delivery tracking info ──
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.adminBgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _trackInfo(Icons.map, order.distanceKm != null ? '${order.distanceKm!.toStringAsFixed(1)} km' : '-'),
                      if (order.deliveryDuration != null)
                        _trackInfo(Icons.timer_outlined, order.deliveryDuration!),
                      _trackInfo(Icons.call_received, 'وصل: ${order.receivedTimeFormatted}'),
                      if (order.confirmedAt != null)
                        _trackInfo(Icons.check_circle_outline, 'تأكيد: ${order.confirmedTimeFormatted}'),
                      if (order.completedAt != null)
                        _trackInfo(Icons.task_alt, 'اكتمل: ${order.completedTimeFormatted}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 18, color: context.adminTextMuted),
            color: context.adminCard,
            onSelected: (v) {
              if (v == '_view_items') {
                _showOrderItems();
              } else {
                setState(() => order.status = v);
                widget.onUpdate(widget.orders);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: '_view_items', child: Row(children: [const Icon(Icons.receipt_long, size: 16, color: DeliVipColors.teal), const SizedBox(width: 8), Text('📦 عرض المنتوجات', style: GoogleFonts.inter(fontWeight: FontWeight.w600))])),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'pending', child: Text('🕐 ${strs.pending}')),
              PopupMenuItem(value: 'confirmed', child: Text('✅ ${strs.confirmed}')),
              PopupMenuItem(value: 'preparing', child: Text('👨‍🍳 ${strs.preparing}')),
              PopupMenuItem(value: 'ready', child: Text('📦 ${strs.ready}')),
              PopupMenuItem(value: 'delivering', child: Text('🚚 ${strs.delivering}')),
              PopupMenuItem(value: 'delivered', child: Text('✅ ${strs.delivered}')),
              PopupMenuItem(value: 'cancelled', child: Text('❌ ${strs.cancelled}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trackInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: DeliVipColors.teal),
        const SizedBox(width: 3),
        Text(text, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: context.adminTextSecondary)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CUSTOMERS PANEL — Improved with full name, email, delivered & cancelled
// ═══════════════════════════════════════════════════════════════════
class _CustomersPanel extends StatefulWidget {
  @override
  State<_CustomersPanel> createState() => _CustomersPanelState();
}

class _CustomersPanelState extends State<_CustomersPanel> {
  String _searchQuery = '';

  static AdminStrings _s(BuildContext context) => context.watch<LanguageProvider>().strings;

  final sampleCustomers = [
    {'firstName': 'Ahmed', 'lastName': 'Benali', 'email': 'ahmed.benali@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 10, 'cancelled': 2, 'total': '1,240 DH'},
    {'firstName': 'Sara', 'lastName': 'Mouline', 'email': 'sara.mouline@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 7, 'cancelled': 1, 'total': '890 DH'},
    {'firstName': 'Omar', 'lastName': 'Kacem', 'email': 'omar.kacem@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 13, 'cancelled': 2, 'total': '2,100 DH'},
    {'firstName': 'Imane', 'lastName': 'Rami', 'email': 'imane.rami@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 4, 'cancelled': 1, 'total': '430 DH'},
    {'firstName': 'Youssef', 'lastName': 'Amrani', 'email': 'youssef.amrani@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 18, 'cancelled': 2, 'total': '3,500 DH'},
    {'firstName': 'Fatima', 'lastName': 'Zahraoui', 'email': 'fatima.zahraoui@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 2, 'cancelled': 1, 'total': '250 DH'},
    {'firstName': 'Hassan', 'lastName': 'Mansouri', 'email': 'hassan.mansouri@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 6, 'cancelled': 1, 'total': '780 DH'},
    {'firstName': 'Nadia', 'lastName': 'Fassi', 'email': 'nadia.fassi@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 9, 'cancelled': 0, 'total': '1,150 DH'},
    {'firstName': 'Karim', 'lastName': 'Tazi', 'email': 'karim.tazi@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 5, 'cancelled': 3, 'total': '620 DH'},
    {'firstName': 'Leila', 'lastName': 'Bennani', 'email': 'leila.bennani@email.com', 'phone': '+212 6XX XXX XXX', 'delivered': 11, 'cancelled': 1, 'total': '1,890 DH'},
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_searchQuery.isEmpty) return sampleCustomers;
    final q = _searchQuery.toLowerCase();
    return sampleCustomers.where((c) =>
      (c['firstName'] as String).toLowerCase().contains(q) ||
      (c['lastName'] as String).toLowerCase().contains(q) ||
      (c['email'] as String).toLowerCase().contains(q) ||
      (c['phone'] as String).toLowerCase().contains(q)
    ).toList();
  }

  String _getInitials(String first, String last) => '${first[0]}${last[0]}';

  int get _totalDelivered => sampleCustomers.fold(0, (sum, c) => sum + (c['delivered'] as int));
  int get _totalCancelled => sampleCustomers.fold(0, (sum, c) => sum + (c['cancelled'] as int));

  Color _getColor(String name) {
    final colors = [DeliVipColors.teal, Colors.orange, Colors.purple, Colors.blue, Colors.red, Colors.green, Colors.indigo, Colors.pink, Colors.cyan, Colors.amber];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
      final strs = context.watch<LanguageProvider>().strings;
    final customers = _filteredCustomers;
    return Column(
      children: [
        // ── Search bar ──
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Container(
            height: 38, width: double.infinity,
            decoration: BoxDecoration(
              color: context.adminSearchBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.inter(fontSize: 13, color: context.adminTextPrimary),
              decoration: InputDecoration(
                hintText: strs.searchCustomers,
                hintStyle: TextStyle(color: context.adminTextMuted),
                prefixIcon: Icon(Icons.search, size: 18, color: context.adminTextMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
        // ── Stats badges ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              _badge(context, '${customers.length}', strs.totalCustomers),
              const SizedBox(width: 8),
              _badge(context, '$_totalDelivered', 'مُوصَلة'),
              const SizedBox(width: 8),
              _badge(context, '$_totalCancelled', 'مُلغاة'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // ── Customers list ──
        Expanded(
          child: customers.isEmpty
            ? Center(
                child: Text(strs.noStoresFound, style: GoogleFonts.inter(fontSize: 14, color: context.adminGreyText)),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: customers.length,
                itemBuilder: (_, i) {
                  final c = customers[i];
                  final fullName = '${c['firstName']} ${c['lastName']}';
                  final color = _getColor(fullName);
                  final delivered = c['delivered'] as int;
                  final cancelled = c['cancelled'] as int;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.adminCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.adminBorder),
                      boxShadow: [
                        BoxShadow(color: context.adminShadowLight, blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Text(
                            _getInitials(c['firstName'] as String, c['lastName'] as String),
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: color),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full name
                              Text(fullName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                              const SizedBox(height: 2),
                              // Email
                              Row(
                                children: [
                                  Icon(Icons.email_outlined, size: 12, color: context.adminGreyText),
                                  const SizedBox(width: 4),
                                  Text(c['email'] as String, style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              // Phone
                              Row(
                                children: [
                                  Icon(Icons.phone_outlined, size: 12, color: context.adminGreyText),
                                  const SizedBox(width: 4),
                                  Text(c['phone'] as String, style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Stats row: delivered | cancelled | total
                              Row(
                                children: [
                                  // Delivered
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, size: 12, color: Colors.green.shade600),
                                        const SizedBox(width: 3),
                                        Text('$delivered', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green.shade600)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Cancelled
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.cancel, size: 12, color: Colors.red.shade400),
                                        const SizedBox(width: 3),
                                        Text('$cancelled', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red.shade400)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Total
                                  Text(c['total'] as String, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: DeliVipColors.teal)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _badge(BuildContext context, String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: DeliVipColors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(count, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: DeliVipColors.teal)),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: DeliVipColors.teal)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CATEGORIES PANEL
// ═══════════════════════════════════════════════════════════════════
class _CategoriesPanel extends StatefulWidget {
  final List<AdminCategory> categories;
  final ValueChanged<List<AdminCategory>> onUpdate;
  const _CategoriesPanel({required this.categories, required this.onUpdate});

  @override
  State<_CategoriesPanel> createState() => _CategoriesPanelState();
}

class _CategoriesPanelState extends State<_CategoriesPanel> {
  AdminStrings get s => context.watch<LanguageProvider>().strings;

  void _addCategory(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emojiCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.adminCard,
        title: Text(s.newCategory, style: TextStyle(color: context.adminTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: context.adminTextPrimary),
              decoration: InputDecoration(
                labelText: s.categoryName,
                labelStyle: TextStyle(color: context.adminGreyText),
                border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                fillColor: context.adminCard,
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emojiCtrl,
              style: TextStyle(color: context.adminTextPrimary),
              decoration: InputDecoration(
                labelText: s.categoryEmoji,
                labelStyle: TextStyle(color: context.adminGreyText),
                border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                fillColor: context.adminCard,
                filled: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: TextStyle(color: context.adminTextSecondary))),
          TextButton(onPressed: () {
            final cat = AdminCategory(name: nameCtrl.text, emoji: emojiCtrl.text.isEmpty ? '📁' : emojiCtrl.text, displayOrder: widget.categories.length);
            widget.onUpdate([...widget.categories, cat]);
            Navigator.pop(ctx);
          }, child: Text(s.add, style: const TextStyle(color: DeliVipColors.teal))),
        ],
      ),
    );
  }

  void _editCategory(BuildContext context, AdminCategory cat) {
    final nameCtrl = TextEditingController(text: cat.name);
    final emojiCtrl = TextEditingController(text: cat.emoji);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.adminCard,
        title: Text(s.editCategory, style: TextStyle(color: context.adminTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: context.adminTextPrimary),
              decoration: InputDecoration(
                labelText: s.categoryName,
                labelStyle: TextStyle(color: context.adminGreyText),
                border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                fillColor: context.adminCard,
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emojiCtrl,
              style: TextStyle(color: context.adminTextPrimary),
              decoration: InputDecoration(
                labelText: s.categoryEmoji,
                labelStyle: TextStyle(color: context.adminGreyText),
                border: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.adminBorder)),
                fillColor: context.adminCard,
                filled: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: TextStyle(color: context.adminTextSecondary))),
          TextButton(onPressed: () {
            cat.name = nameCtrl.text;
            cat.emoji = emojiCtrl.text.isEmpty ? '📁' : emojiCtrl.text;
            widget.onUpdate(widget.categories);
            Navigator.pop(ctx);
          }, child: Text(s.save.replaceAll('💾 ', ''), style: const TextStyle(color: DeliVipColors.teal))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.adminCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.adminBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.category, color: DeliVipColors.teal, size: 24),
                      const SizedBox(width: 12),
                      Text('${widget.categories.length} ${s.categoriesCount}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                heroTag: 'add_category',
                onPressed: () => _addCategory(context),
                backgroundColor: DeliVipColors.teal,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.categories.length,
            itemBuilder: (_, i) {
              final cat = widget.categories[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: context.adminCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.adminBorder),
                ),
                child: Row(
                  children: [
                    Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
                          Text('${s.orderDisplay}: ${cat.displayOrder}', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                        ],
                      ),
                    ),
                    Switch(
                      value: cat.isActive,
                      activeThumbColor: DeliVipColors.teal,
                      onChanged: (v) {
                        cat.isActive = v;
                        widget.onUpdate(widget.categories);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 18, color: context.adminTextMuted),
                      onPressed: () => _editCategory(context, cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () {
                        widget.onUpdate(widget.categories.where((c) => c.id != cat.id).toList());
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SETTINGS PANEL
// ═══════════════════════════════════════════════════════════════════
class _SettingsPanel extends StatefulWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdate;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const _SettingsPanel({
    required this.settings,
    required this.onUpdate,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<_SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<_SettingsPanel> {
  late TextEditingController _nameCtrl, _phoneCtrl, _emailCtrl, _feeCtrl, _minCtrl, _freeCtrl;

  AdminStrings get s => context.watch<LanguageProvider>().strings;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.settings.appName);
    _phoneCtrl = TextEditingController(text: widget.settings.supportPhone);
    _emailCtrl = TextEditingController(text: widget.settings.supportEmail);
    _feeCtrl = TextEditingController(text: widget.settings.deliveryFee.toString());
    _minCtrl = TextEditingController(text: widget.settings.minOrderAmount.toString());
    _freeCtrl = TextEditingController(text: widget.settings.freeDeliveryThreshold.toString());
  }

  @override
  void dispose() {
    for (var c in [_nameCtrl, _phoneCtrl, _emailCtrl, _feeCtrl, _minCtrl, _freeCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ss = widget.settings;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.appSettings, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 8),
          Text(s.settingsDesc, style: GoogleFonts.inter(fontSize: 13, color: context.adminGreyText)),
          const SizedBox(height: 24),

          _sectionTitle(context, s.appearance),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: context.adminCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.adminBorder),
            ),
            child: Row(
              children: [
                Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: DeliVipColors.teal, size: 20),
                const SizedBox(width: 12),
                Text(widget.isDarkMode ? s.modeDark : s.modeLight, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextPrimary)),
                const Spacer(),
                Switch(
                  value: widget.isDarkMode,
                  activeThumbColor: DeliVipColors.teal,
                  onChanged: (_) => widget.onThemeToggle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle(context, s.general),
          const SizedBox(height: 12),
          _settingField(context, s.appName, _nameCtrl),
          const SizedBox(height: 12),
          _settingField(context, s.supportPhone, _phoneCtrl),
          const SizedBox(height: 12),
          _settingField(context, s.supportEmail, _emailCtrl),
          const SizedBox(height: 24),

          _sectionTitle(context, s.pricing),
          const SizedBox(height: 12),
          _settingField(context, s.deliveryFee, _feeCtrl, isNumber: true),
          const SizedBox(height: 12),
          _settingField(context, s.minOrderAmount, _minCtrl, isNumber: true),
          const SizedBox(height: 12),
          _settingField(context, s.freeDeliveryThreshold, _freeCtrl, isNumber: true),
          const SizedBox(height: 24),

          _sectionTitle(context, s.features),
          const SizedBox(height: 12),
          _toggleOption(context, s.enablePickup, ss.enablePickup, (v) => setState(() => ss.enablePickup = v)),
          _toggleOption(context, s.enableDineIn, ss.enableDineIn, (v) => setState(() => ss.enableDineIn = v)),
          _toggleOption(context, s.enableGrocery, ss.enableGrocery, (v) => setState(() => ss.enableGrocery = v)),
          _toggleOption(context, s.enablePromotions, ss.enablePromotions, (v) => setState(() => ss.enablePromotions = v)),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ss.appName = _nameCtrl.text;
                ss.supportPhone = _phoneCtrl.text;
                ss.supportEmail = _emailCtrl.text;
                ss.deliveryFee = double.tryParse(_feeCtrl.text) ?? 5.0;
                ss.minOrderAmount = double.tryParse(_minCtrl.text) ?? 20.0;
                ss.freeDeliveryThreshold = double.tryParse(_freeCtrl.text) ?? 100.0;
                widget.onUpdate(ss);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(s.settingsSaved),
                    backgroundColor: DeliVipColors.teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: DeliVipColors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(s.saveSettings, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: context.adminTextBlackOrLight));
  }

  Widget _settingField(BuildContext context, String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.adminBorder),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.inter(fontSize: 14, color: context.adminTextPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(fontSize: 13, color: context.adminGreyText),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _toggleOption(BuildContext context, String label, bool value, ValueChanged<bool> onChange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.adminBorder),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextBlackOrLight))),
          Switch(value: value, activeThumbColor: DeliVipColors.teal, onChanged: onChange),
        ],
      ),
    );
  }
}
