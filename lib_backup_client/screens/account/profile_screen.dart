import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../models/app_state.dart';
import '../../models/user.dart';
import '../../screens/login_screen.dart';
import 'personal_info_screen.dart';
import 'addresses_screen.dart';
import 'privacy_settings_screen.dart';
import 'language_screen.dart';

class AccountHomeScreen extends StatefulWidget {
  final AppState appState;

  const AccountHomeScreen({super.key, required this.appState});

  @override
  State<AccountHomeScreen> createState() => _AccountHomeScreenState();
}

class _AccountHomeScreenState extends State<AccountHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final user = widget.appState.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(loc.monCompte), centerTitle: true),
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile header
              _buildProfileHeader(context, user),
              const SizedBox(height: 24),
              // Account sections
              _buildSectionTitle(context, loc.mesInfos),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: loc.mesInfos,
                subtitle: '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                onTap: () =>
                    _navigate(PersonalInfoScreen(appState: widget.appState)),
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: loc.adresseLivraison,
                subtitle: user?.deliveryAddress ?? 'Non définie',
                onTap: () =>
                    _navigate(AddressesScreen(appState: widget.appState)),
              ),
              _buildMenuItem(
                icon: Icons.language,
                title: loc.langue,
                subtitle: _getLanguageName(widget.appState.locale),
                onTap: () =>
                    _navigate(LanguageScreen(appState: widget.appState)),
              ),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: loc.notifications,
                trailing: Switch(
                  value: widget.appState.notificationsEnabled,
                  onChanged: (_) => widget.appState.toggleNotifications(),
                  activeThumbColor: AppTheme.primaryCyan,
                ),
                onTap: () => widget.appState.toggleNotifications(),
              ),
              const Divider(height: 32),
              _buildSectionTitle(context, loc.confidentialite),
              _buildMenuItem(
                icon: Icons.shield_outlined,
                title: loc.parametresConfidentialite,
                onTap: () =>
                    _navigate(PrivacySettingsScreen(appState: widget.appState)),
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: loc.politiqueConfidentialite,
                onTap: () => _showPolicy(context),
              ),
              const Divider(height: 32),
              _buildSectionTitle(context, loc.aide),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: loc.aide,
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: loc.propos,
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Logout button
              _buildLogoutButton(context, loc),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  void _navigate(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'Français';
    }
  }

  void _showPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Politique de confidentialité'),
        content: const SingleChildScrollView(
          child: Text(
            'DeliVIP respecte votre vie privée.\n\n'
            '1. Collecte des données : Nous collectons votre nom, email, adresse '
            'et localisation pour assurer le service de livraison.\n\n'
            '2. Utilisation : Vos données sont utilisées uniquement pour traiter '
            'vos commandes et améliorer votre expérience.\n\n'
            '3. Partage : Nous ne partageons pas vos données avec des tiers sans '
            'votre consentement.\n\n'
            '4. Sécurité : Vos données sont protégées par des mesures de sécurité '
            'conformes aux standards de l\'industrie.\n\n'
            '5. Vos droits : Vous pouvez demander la suppression de vos données '
            'à tout moment depuis les paramètres de confidentialité.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        // Sur le web on utilise le chemin direct (pas de filesystem local)
        // Sur mobile, l'image est utilisée directement depuis son chemin temporaire
        await widget.appState.updateUserInfo(avatarUrl: pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Photo de profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryCyan,
                  ),
                ),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppTheme.primaryCyan,
                  ),
                ),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (widget.appState.currentUser?.avatarUrl != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text('Supprimer la photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await widget.appState.updateUserInfo(avatarUrl: null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? user) {
    final avatarUrl = user?.avatarUrl;
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryCyan, Color(0xFF009688)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryCyan.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 3),
                  ),
                  child: avatarUrl != null && File(avatarUrl).existsSync()
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.file(
                            File(avatarUrl),
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 36,
                                ),
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.white, size: 36),
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'Client DeliVIP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'client@delivip.ma',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.phone ?? '+212 6 00 00 00 00',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryCyan, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutConfirm(context, loc),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          loc.seDeconnecter,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(loc.deconnexion),
        content: Text('${loc.seDeconnecter} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.annuler),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.appState.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(appState: widget.appState),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Se déconnecter',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
