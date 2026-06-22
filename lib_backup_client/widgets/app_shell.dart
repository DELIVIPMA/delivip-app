import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../theme/app_theme.dart';
import '../pages/home_screen.dart' as home_page;
import '../screens/search_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/account_screen.dart';
import 'three_d_icon.dart';

/// AppShell gère la BottomNavigationBar persistante
/// et les navigateurs imbriqués pour chaque tab.
/// Cela permet aux pages store de conserver la bottom nav visible.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const home_page.HomeScreen(),
      const SearchScreen(),
      const OrdersScreenShell(), // wrapper sans AppState
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // Tenter de pop dans le tab actuel
        final currentNav = _navigatorKeys[_currentIndex].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
        } else if (_currentIndex != 0) {
          // Revenir au tab Accueil
          setState(() => _currentIndex = 0);
        }
        // Sinon, on quitte l'app (comportement natif)
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(_tabs.length, (index) {
            return Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => _tabs[index],
                  settings: settings,
                );
              },
            );
          }),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GNav(
            rippleColor: const Color(0xFF1AA49B),
            hoverColor: const Color(0xFF138C84),
            haptic: true,
            tabBorderRadius: 16,
            tabActiveBorder: Border.all(
              color: const Color(0xFF1AA49B),
              width: 1.5,
            ),
            tabBorder: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
            tabShadow: [
              BoxShadow(
                color: const Color(0xFF1AA49B).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 600),
            gap: 8,
            color: const Color(0xFF9E9E9E),
            activeColor: const Color(0xFF1AA49B),
            iconSize: 24,
            tabBackgroundColor: const Color(0xFF1AA49B).withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              if (_currentIndex == index) {
                _navigatorKeys[index].currentState?.popUntil(
                  (route) => route.isFirst,
                );
              } else {
                setState(() => _currentIndex = index);
              }
            },
            tabs: [
              const GButton(icon: Icons.home_outlined, text: 'Home'),
              const GButton(icon: Icons.search_rounded, text: 'Search'),
              GButton(
                icon: Icons.shopping_bag_outlined,
                text: 'Orders',
                leading: Badge(
                  label: const Text('3'),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 24,
                    color: _currentIndex == 2
                        ? const Color(0xFF1AA49B)
                        : const Color(0xFF9E9E9E),
                  ),
                ),
              ),
              const GButton(
                icon: Icons.person_outline_rounded,
                text: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper minimal pour OrdersScreen sans dépendre d'AppState
class OrdersScreenShell extends StatelessWidget {
  const OrdersScreenShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Version simplifiée sans AppState
    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune commande',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vos commandes apparaîtront ici',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
