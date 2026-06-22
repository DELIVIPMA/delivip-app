import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../models/app_state.dart';

class LanguageScreen extends StatefulWidget {
  final AppState appState;

  const LanguageScreen({super.key, required this.appState});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<_Language> _languages = [
    _Language('Français', 'fr', '🇫🇷'),
    _Language('English', 'en', '🇬🇧'),
    _Language('العربية', 'ar', '🇲🇦'),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.langue)),
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, _) {
          final currentLocale = widget.appState.locale;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _languages.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lang = _languages[index];
              final isSelected = lang.code == currentLocale;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                leading: Text(lang.flag, style: const TextStyle(fontSize: 36)),
                title: Text(
                  lang.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryCyan,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: isSelected
                      ? const BorderSide(
                          color: AppTheme.primaryCyan,
                          width: 1.5,
                        )
                      : BorderSide.none,
                ),
                tileColor: isSelected
                    ? AppTheme.primaryCyan.withValues(alpha: 0.05)
                    : null,
                onTap: () {
                  widget.appState.setLocale(lang.code);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Language {
  final String name;
  final String code;
  final String flag;

  const _Language(this.name, this.code, this.flag);
}
