import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/account_screen.dart';
import 'screens/search_screen.dart';
import 'data/models.dart';
import 'data/cart_provider.dart';
import 'data/app_data_provider.dart';
import 'data/oauth_config.dart';
import 'services/google_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleAuthService.initialize(clientId: GoogleOAuthConfig.webClientId);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppDataProvider()..loadSampleData(),
      child: const DeliVipApp(),
    ),
  );
}

class DeliVipApp extends StatefulWidget {
  const DeliVipApp({super.key});

  @override
  State<DeliVipApp> createState() => _DeliVipAppState();
}

class _DeliVipAppState extends State<DeliVipApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _onThemeModeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DELIVIP',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DeliVipColors.teal,
          primary: DeliVipColors.teal,
          secondary: DeliVipColors.gold,
          tertiary: DeliVipColors.purple,
          surface: DeliVipColors.surface,
        ),
        scaffoldBackgroundColor: DeliVipColors.surface,
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
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: DeliVipColors.teal.withValues(alpha: 0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
            .copyWith(
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
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: DeliVipDarkColors.topbarBg,
          indicatorColor: DeliVipColors.teal.withValues(alpha: 0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  MAIN SHELL — Navigation principale DeliVip
// ═══════════════════════════════════════════════════════
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final CartProvider _cart = CartProvider();
  final List<Order> _orders = [];

  static final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    CartScreen(),
    OrdersScreen(orders: const []),
    const AccountScreen(),
  ];

  void goToCart() => setState(() => _currentIndex = 3);
  void addOrder(Order o) => setState(() => _orders.add(o));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          const SearchScreen(),
          CartScreen(cart: _cart, onOrderPlaced: addOrder),
          OrdersScreen(orders: _orders),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        cartCount: _cart.items.length,
      ),
    );
  }
}

// ═══ BOTTOM NAV ═══════════════════════════════════
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.cartCount,
  });

  static const _items = [
    _Nav(Icons.home, 'Accueil'),
    _Nav(Icons.search, 'Chercher'),
    _Nav(Icons.shopping_bag_outlined, 'Épicerie'),
    _Nav(Icons.shopping_cart, 'Paniers'),
    _Nav(Icons.person, 'Compte'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: DeliVipShadows.glass,
        border: Border(
          top: BorderSide(color: DeliVipColors.border.withValues(alpha: 0.7)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (i) {
              return _NavItem(
                icon: _items[i].icon,
                label: _items[i].label,
                isSelected: currentIndex == i,
                badge: i == 3 && cartCount > 0 ? cartCount.toString() : null,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? DeliVipColors.teal.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? DeliVipColors.teal
                      : DeliVipColors.textMuted,
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: DeliVipColors.gold,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badge!,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? DeliVipColors.teal
                    : DeliVipColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Nav {
  final IconData icon;
  final String label;
  const _Nav(this.icon, this.label);
}
