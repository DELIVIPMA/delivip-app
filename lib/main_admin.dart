import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/admin_dashboard_screen.dart';
import 'data/app_data_provider.dart';
import 'data/localization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppDataProvider()..loadSampleData()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const DeliVipAdminApp(),
    ),
  );
}

class DeliVipAdminApp extends StatefulWidget {
  const DeliVipAdminApp({super.key});

  @override
  State<DeliVipAdminApp> createState() => _DeliVipAdminAppState();
}

class _DeliVipAdminAppState extends State<DeliVipAdminApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _onThemeModeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DELIVIP Admin',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DeliVipColors.teal,
          primary: DeliVipColors.teal,
          secondary: DeliVipColors.gold,
          tertiary: DeliVipColors.purple,
          surface: DeliVipColors.surface,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: DeliVipColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: DeliVipColors.textPrimary,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DeliVipColors.textPrimary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: DeliVipColors.textSecondary,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: DeliVipColors.textMuted,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DeliVipColors.teal,
          primary: DeliVipColors.teal,
          secondary: DeliVipColors.gold,
          tertiary: DeliVipColors.purple,
          surface: DeliVipDarkColors.surface,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: DeliVipDarkColors.surface,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: DeliVipDarkColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: DeliVipDarkColors.textPrimary,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DeliVipDarkColors.textPrimary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: DeliVipDarkColors.textSecondary,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: DeliVipDarkColors.textMuted,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          color: DeliVipDarkColors.card,
        ),
      ),
      home: AdminDashboardScreen(
        initialThemeMode: _themeMode,
        onThemeModeChanged: _onThemeModeChanged,
      ),
    );
  }
}
