import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/glass_container.dart';
import '../widgets/responsive_helper.dart';

// ═══════════════════════════════════════════════════════
//  CUSTOMER PROFILE SCREEN — Uber Eats Style
//  Premium Glassmorphism UI — Fully Interactive
// ═══════════════════════════════════════════════════════

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  // ─── State ──────────────────────────────────────────
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  static const _languages = ['English', 'French', 'Arabic'];

  // ─── WhatsApp dummy number ──────────────────────────
  static const _whatsappNumber = '+212600000000';
  static final _whatsappMessage = Uri.encodeComponent(
    'Hello DeliVIP! I need help.',
  );

  // ═══════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ResponsiveHelper.constrainWidth(
            context,
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ─── Uber Eats Style Header ────────────
                  _buildUberEatsHeader(),
                  const SizedBox(height: 28),

                  // ─── Quick Action Cards ─────────────────
                  _buildQuickActionRow(),
                  const SizedBox(height: 28),

                  // ─── Settings Menu ──────────────────────
                  _buildSettingsSection(),
                  const SizedBox(height: 24),

                  // ─── Logout ─────────────────────────────
                  _buildLogoutButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  1. UBER EATS STYLE HEADER
  // ═══════════════════════════════════════════════════════
  Widget _buildUberEatsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _dark.withValues(alpha: 0.5),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ahmed Haddad',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_teal, Color(0xFF6ED4C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _teal.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'A',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  2. HORIZONTAL QUICK ACTIONS
  // ═══════════════════════════════════════════════════════
  Widget _buildQuickActionRow() {
    return Row(
      children: [
        Expanded(
          child: _quickCard(
            Icons.wallet_outlined,
            'Wallet',
            '245.50 DH',
            () => _showSnackBar('Navigating to Wallet...'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickCard(
            Icons.receipt_outlined,
            'Orders',
            '3',
            () => _showSnackBar('Navigating to My Orders...'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickCard(
            Icons.favorite_border_rounded,
            'Favorites',
            '12',
            () => _showSnackBar('Navigating to Favorites...'),
          ),
        ),
      ],
    );
  }

  Widget _quickCard(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      borderRadius: BorderRadius.circular(18),
      opacity: 0.18,
      tintColor: Colors.white,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: _teal),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _dark.withValues(alpha: 0.55),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  3. SETTINGS LIST
  // ═══════════════════════════════════════════════════════
  Widget _buildSettingsSection() {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      borderRadius: BorderRadius.circular(22),
      opacity: 0.20,
      tintColor: Colors.white,
      child: Column(
        children: [
          _settingTile(
            icon: Icons.local_offer_outlined,
            title: 'Promotions',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '2 new',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
            onTap: () => _showSnackBar('Navigating to Promotions...'),
          ),
          _divider(),
          _settingTile(
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            trailing: Text(
              'Cash on Delivery',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _dark.withValues(alpha: 0.45),
              ),
            ),
            onTap: () => _showSnackBar('Navigating to Payment Methods...'),
          ),
          _divider(),
          _settingTile(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            trailing: Text(
              '2 saved',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _dark.withValues(alpha: 0.45),
              ),
            ),
            onTap: () => _showSnackBar('Navigating to Addresses...'),
          ),
          _divider(),
          _buildNotificationTile(),
          _divider(),
          _settingTile(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: Text(
              _selectedLanguage,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _dark.withValues(alpha: 0.45),
              ),
            ),
            onTap: _showLanguagePicker,
          ),
          _divider(),
          _settingTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'WhatsApp Support',
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
            onTap: _openWhatsApp,
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: _teal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _dark,
                ),
              ),
            ),
            if (trailing != null) trailing,
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: _dark.withValues(alpha: 0.20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Divider(height: 1, color: _dark.withValues(alpha: 0.06)),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  NOTIFICATIONS TOGGLE
  // ═══════════════════════════════════════════════════════
  Widget _buildNotificationTile() {
    return InkWell(
      onTap: () =>
          setState(() => _notificationsEnabled = !_notificationsEnabled),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.notifications_outlined, size: 20, color: _teal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _dark,
                ),
              ),
            ),
            CupertinoSwitch(
              value: _notificationsEnabled,
              activeTrackColor: _teal,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  4. LOGOUT
  // ═══════════════════════════════════════════════════════
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showLogoutDialog,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.3),
            width: 1.2,
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.04),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  INTERACTIONS — LANGUAGE PICKER
  // ═══════════════════════════════════════════════════════
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _LanguageSheet(
        languages: _languages,
        selected: _selectedLanguage,
        onSelected: (lang) {
          setState(() => _selectedLanguage = lang);
          Navigator.pop(ctx);
          _showSnackBar('Language changed to $lang');
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  INTERACTIONS — WHATSAPP
  // ═══════════════════════════════════════════════════════
  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/$_whatsappNumber?text=$_whatsappMessage',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Could not open WhatsApp. Please check your device.');
    }
  }

  // ═══════════════════════════════════════════════════════
  //  INTERACTIONS — LOGOUT DIALOG
  // ═══════════════════════════════════════════════════════
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: _teal,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('You have been logged out.');
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HELPER — SNACKBAR
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

// ═══════════════════════════════════════════════════════
//  LANGUAGE PICKER BOTTOM SHEET
// ═══════════════════════════════════════════════════════

class _LanguageSheet extends StatelessWidget {
  final List<String> languages;
  final String selected;
  final ValueChanged<String> onSelected;

  const _LanguageSheet({
    required this.languages,
    required this.selected,
    required this.onSelected,
  });

  static const _teal = Color(0xFF39BCA8);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: _teal.withValues(alpha: 0.04),
              blurRadius: 60,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Choose Language',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1E24),
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.black.withValues(alpha: 0.06)),
            const SizedBox(height: 4),
            ...languages.map((lang) => _languageTile(lang)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(String lang) {
    final isSelected = lang == selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: () => onSelected(lang),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Flag emoji (simple mapping)
              Text(
                lang == 'English'
                    ? '🇬🇧'
                    : lang == 'French'
                    ? '🇫🇷'
                    : '🇸🇦',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  lang,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? _teal : const Color(0xFF1E1E24),
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check, size: 15, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
