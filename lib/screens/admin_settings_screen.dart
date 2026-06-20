import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data/admin_models.dart';
import '../data/localization.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADMIN SETTINGS SCREEN — Full App Configuration Backoffice
//  Sections: Appearance, General, Pricing, Features, Delivery Zones,
//  Security, Backups, Danger Zone — with 2-column layout ≥900px
// ═══════════════════════════════════════════════════════════════════

class AdminSettingsScreen extends StatefulWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdate;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const AdminSettingsScreen({
    super.key,
    required this.settings,
    required this.onUpdate,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  // ── Colors ──────────────────────────────────────────
  static const Color teal = Color(0xFF1AA49B);
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color danger = Color(0xFFA32D2D);
  static const Color dangerLight = Color(0xFFFCEBEB);

  // ── Controllers ─────────────────────────────────────
  late TextEditingController _nameCtrl, _phoneCtrl, _emailCtrl, _feeCtrl, _minCtrl, _freeCtrl;

  // ── New state variables ─────────────────────────────
  bool _twoFactorAuth = false;
  bool _forcePhoneVerification = true;
  bool _autoBlockFailedOrders = true;
  bool _maintenanceMode = false;
  List<String> _deliveryZones = ['Hay Salam', 'Founty', 'Inezgane', 'Charaf'];

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

  // ──────────────────────────────────────────────────────────────
  //  BUILD
  // ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final ss = widget.settings;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page header ──────────────────────────────
          Text(s.appSettings, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: context.adminTextPrimary)),
          const SizedBox(height: 8),
          Text(s.settingsDesc, style: GoogleFonts.inter(fontSize: 13, color: context.adminGreyText)),
          const SizedBox(height: 20),

          // ── 1. Status strip ──────────────────────────
          _buildStatusStrip(context),
          const SizedBox(height: 24),

          // ── 2. Two-column layout ─────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN
                    Expanded(child: _buildLeftColumn(context, ss)),
                    const SizedBox(width: 24),
                    // RIGHT COLUMN
                    Expanded(child: _buildRightColumn(context, ss)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildLeftColumn(context, ss),
                    const SizedBox(height: 24),
                    _buildRightColumn(context, ss),
                  ],
                );
              }
            },
          ),

          // ── Save button (below both columns) ─────────
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
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
                    backgroundColor: teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.save, color: Colors.white, size: 18),
              label: Text(s.saveSettings, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  LEFT COLUMN — Existing sections
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildLeftColumn(BuildContext context, AppSettings ss) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Appearance ──
        _SettingsSection(
          icon: Icons.palette,
          title: s.appearance,
          child: _buildAppearance(context, ss),
        ),
        const SizedBox(height: 20),

        // ── General ──
        _SettingsSection(
          icon: Icons.store,
          title: s.general,
          child: _buildGeneral(context),
        ),
        const SizedBox(height: 20),

        // ── Pricing ──
        _SettingsSection(
          icon: Icons.attach_money,
          title: s.pricing,
          child: _buildPricing(context),
        ),
        const SizedBox(height: 20),

        // ── Features ──
        _SettingsSection(
          icon: Icons.toggle_on_outlined,
          title: s.features,
          child: _buildFeatures(context, ss),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  RIGHT COLUMN — New sections
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildRightColumn(BuildContext context, AppSettings ss) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Delivery zones ──
        _SettingsSection(
          icon: Icons.location_on,
          title: 'Delivery zones',
          child: _buildDeliveryZones(context),
        ),
        const SizedBox(height: 20),

        // ── Security ──
        _SettingsSection(
          icon: Icons.shield,
          title: 'Security',
          child: _buildSecurity(),
        ),
        const SizedBox(height: 20),

        // ── Backups ──
        _SettingsSection(
          icon: Icons.storage,
          title: 'Backups',
          child: _buildBackups(context),
        ),
        const SizedBox(height: 20),

        // ── Danger Zone ──
        _buildDangerZone(context),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  1. STATUS STRIP
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildStatusStrip(BuildContext context) {
    final statuses = [
      ('API status', 'Operational', Colors.green),
      ('App version', 'v2.4.1', Colors.green),
      ('Last backup', '2h ago', Colors.amber),
      ('Uptime 30d', '99.9%', Colors.green),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: 2 columns on narrow, 4 on wide
        final isWide = constraints.maxWidth >= 600;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: statuses.map((s) {
            final label = s.$1;
            final value = s.$2;
            final dotColor = s.$3;
            return SizedBox(
              width: isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: context.adminCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.adminBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: context.adminTextPrimary)),
                          Text(label, style: GoogleFonts.inter(fontSize: 10, color: context.adminGreyText)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  APPEARANCE
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildAppearance(BuildContext context, AppSettings ss) {
    return Row(
      children: [
        Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: teal, size: 20),
        const SizedBox(width: 12),
        Text(widget.isDarkMode ? s.modeDark : s.modeLight, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextPrimary)),
        const Spacer(),
          Switch(
          value: widget.isDarkMode,
          activeThumbColor: teal,
          onChanged: (_) => widget.onThemeToggle(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  GENERAL
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildGeneral(BuildContext context) {
    return Column(
      children: [
        _settingField(context, s.appName, _nameCtrl),
        const SizedBox(height: 12),
        _settingField(context, s.supportPhone, _phoneCtrl),
        const SizedBox(height: 12),
        _settingField(context, s.supportEmail, _emailCtrl),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PRICING
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildPricing(BuildContext context) {
    return Column(
      children: [
        _settingField(context, s.deliveryFee, _feeCtrl, isNumber: true),
        const SizedBox(height: 12),
        _settingField(context, s.minOrderAmount, _minCtrl, isNumber: true),
        const SizedBox(height: 12),
        _settingField(context, s.freeDeliveryThreshold, _freeCtrl, isNumber: true),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  FEATURES
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFeatures(BuildContext context, AppSettings ss) {
    return Column(
      children: [
        _ToggleRow(
          title: s.enablePickup,
          subtitle: 'Allow customers to pick up orders',
          value: ss.enablePickup,
          teal: teal,
          onChanged: (v) => setState(() => ss.enablePickup = v),
        ),
        _ToggleRow(
          title: s.enableDineIn,
          subtitle: 'Allow dine-in experience',
          value: ss.enableDineIn,
          teal: teal,
          onChanged: (v) => setState(() => ss.enableDineIn = v),
        ),
        _ToggleRow(
          title: s.enableGrocery,
          subtitle: 'Enable grocery module',
          value: ss.enableGrocery,
          teal: teal,
          onChanged: (v) => setState(() => ss.enableGrocery = v),
        ),
        _ToggleRow(
          title: s.enablePromotions,
          subtitle: 'Show promotions & offers',
          value: ss.enablePromotions,
          teal: teal,
          onChanged: (v) => setState(() => ss.enablePromotions = v),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  3. DELIVERY ZONES
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildDeliveryZones(BuildContext context) {
    final zoneOrders = <String, int>{
      'Hay Salam': 42,
      'Founty': 38,
      'Inezgane': 29,
      'Charaf': 21,
    };

    return Column(
      children: [
        ...(_deliveryZones.map((zone) {
          final orders = zoneOrders[zone] ?? 0;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.adminBorder, width: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: teal, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(zone, style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary)),
                ),
                Text('$orders/week', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
              ],
            ),
          );
        })),
        const SizedBox(height: 8),
        // Add zone row
        Row(
          children: [
            Icon(Icons.add_circle_outline, size: 16, color: context.adminGreyText),
            const SizedBox(width: 8),
            Expanded(
              child: Text('+ Add zone', style: GoogleFonts.inter(fontSize: 12, color: context.adminGreyText)),
            ),
            GestureDetector(
              onTap: () => _showAddZoneDialog(context),
              child: Text('Add', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: teal)),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddZoneDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Add delivery zone', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Zone name',
            hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() => _deliveryZones.add(name));
              }
              Navigator.pop(ctx);
            },
            child: Text('Save', style: GoogleFonts.inter(color: teal, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  4. SECURITY
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildSecurity() {
    return Column(
      children: [
        _ToggleRow(
          title: 'Two-factor auth (admin)',
          subtitle: 'Require OTP on login',
          value: _twoFactorAuth,
          teal: teal,
          onChanged: (v) => setState(() => _twoFactorAuth = v),
        ),
        _ToggleRow(
          title: 'Force phone verification',
          subtitle: 'For new customer accounts',
          value: _forcePhoneVerification,
          teal: teal,
          onChanged: (v) => setState(() => _forcePhoneVerification = v),
        ),
        _ToggleRow(
          title: 'Auto-block after failed orders',
          subtitle: '3 cancellations in 24h',
          value: _autoBlockFailedOrders,
          teal: teal,
          onChanged: (v) => setState(() => _autoBlockFailedOrders = v),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  5. BACKUPS
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildBackups(BuildContext context) {
    final backups = [
      ('Backup_2026-06-19_03h00.zip', '3.2 MB', 'Automatic'),
      ('Backup_2026-06-18_03h00.zip', '3.1 MB', 'Automatic'),
    ];

    return Column(
      children: [
        ...(backups.map((b) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.adminBorder, width: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.description_outlined, size: 18, color: teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.$1, style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary)),
                      const SizedBox(height: 2),
                      Text('${b.$2} · ${b.$3}', style: GoogleFonts.inter(fontSize: 10, color: context.adminGreyText)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Downloading...'),
                        backgroundColor: teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text('Download', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: teal)),
                ),
              ],
            ),
          );
        })),
        const SizedBox(height: 8),
        // Run backup now
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Backup started'),
                backgroundColor: teal,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          child: Row(
            children: [
              Icon(Icons.refresh, size: 16, color: teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Run backup now', style: GoogleFonts.inter(fontSize: 12, color: context.adminTextPrimary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tealLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Run', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: teal)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  6. DANGER ZONE
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildDangerZone(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: danger.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.adminBorder)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 20, color: danger),
                const SizedBox(width: 10),
                Text('Danger zone', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: danger)),
              ],
            ),
          ),
          // ── Content ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Maintenance mode
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Maintenance mode', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: context.adminTextPrimary)),
                          const SizedBox(height: 2),
                          Text('Temporarily disable the customer app', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _showConfirmDialog(
                        context,
                        title: 'Enable maintenance mode',
                        message: 'The customer app will be disabled. Are you sure?',
                        isDanger: true,
                        onConfirm: () => setState(() => _maintenanceMode = true),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: danger,
                        backgroundColor: dangerLight,
                        side: const BorderSide(color: danger),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_maintenanceMode ? 'Enabled' : 'Enable', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Clear test data
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Clear all test data', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: context.adminTextPrimary)),
                          const SizedBox(height: 2),
                          Text('Removes mock orders and customers', style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _showConfirmDialog(
                        context,
                        title: 'Clear test data',
                        message: 'This cannot be undone. All mock orders and customers will be deleted.',
                        isDanger: true,
                        isDestructive: true,
                        onConfirm: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Test data cleared'),
                              backgroundColor: teal,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: danger,
                        backgroundColor: dangerLight,
                        side: const BorderSide(color: danger),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Clear', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
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

  void _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDanger = false,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(message, style: GoogleFonts.inter(fontSize: 13, color: context.adminTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              isDestructive ? 'Delete' : 'Confirm',
              style: GoogleFonts.inter(
                color: isDanger ? danger : teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SHARED HELPERS
  // ═══════════════════════════════════════════════════════════════════

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
}

// ═══════════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════

/// Reusable settings card wrapper with icon header and border
class _SettingsSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adminBorder, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.adminBorder)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF1AA49B)),
                const SizedBox(width: 10),
                Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: context.adminTextPrimary)),
              ],
            ),
          ),
          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Reusable toggle row with title, subtitle, and Switch
class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Color teal;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.teal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, color: context.adminTextBlackOrLight)),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: context.adminGreyText)),
                  ),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: teal, onChanged: onChanged),
        ],
      ),
    );
  }
}


