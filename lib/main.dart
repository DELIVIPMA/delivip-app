import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'data/address_provider.dart';
import 'data/cart_provider.dart';
import 'data/theme_provider.dart';
import 'screens/main_layout_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeliVipApp());
}

class DeliVipApp extends StatelessWidget {
  const DeliVipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()..load()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'DELIVIP',
            debugShowCheckedModeBanner: false,
            // ═══════════════════════════════════════════════════════════
            //  FORCE LIGHT MODE — Pure White Uber Eats Style
            //  darkTheme est commenté pour empêcher tout rendu dark.
            // ═══════════════════════════════════════════════════════════
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme,   ← désactivé
            // themeMode: themeProvider.themeMode, ← désactivé
            themeMode: ThemeMode.light, // ← forcé LIGHT en permanence
            home: const MainLayoutScreen(),
          );
        },
      ),
    );
  }
}
