import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/models.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/customer_profile_screen.dart';
import 'screens/restaurant_menu_screen.dart';
import 'pages/category_list_page.dart';
import 'widgets/main_navigation_scaffold.dart';

// ─── Keys for preserving tab state ────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Build the app router with a StatefulShellRoute for persistent bottom nav.
GoRouter buildAppRouter({String? initialAddress}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScaffold(
          navigationShell: navigationShell,
          initialAddress: initialAddress,
        );
      },
      branches: [
        // ── Tab 0 : Home ──────────────────
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => HomeScreen(
                initialAddress: initialAddress,
                onOpenRestaurant: (r) => context.push('/restaurant/${r.id}'),
                onOpenCategory: (cat) =>
                    context.push('/category/${Uri.encodeComponent(cat)}'),
                onOpenSearch: () => context.go('/search'),
              ),
              routes: [
                // Sub‑page: Restaurant details (pushed inside shell)
                GoRoute(
                  path: 'restaurant/:id',
                  parentNavigatorKey: _shellNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final restaurant = _findRestaurant(id);
                    return RestaurantMenuScreen(restaurant: restaurant);
                  },
                ),
                // Sub‑page: Category listing
                GoRoute(
                  path: 'category/:name',
                  parentNavigatorKey: _shellNavigatorKey,
                  builder: (context, state) {
                    final name = Uri.decodeComponent(
                      state.pathParameters['name']!,
                    );
                    return CategoryListPage(category: name);
                  },
                ),
              ],
            ),
          ],
        ),

        // ── Tab 1 : Search ────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),

        // ── Tab 2 : Cart Tab ──────────────
        // This branch exists so the bottom nav pill has a Cart button,
        // but it immediately redirects to the full‑screen /cart route.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart-tab',
              builder: (context, state) {
                // Immediately push the full‑screen cart page
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.pushReplacement('/cart');
                });
                return const SizedBox.shrink();
              },
            ),
          ],
        ),

        // ── Tab 3 : Account ───────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const CustomerProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // ─── Full‑screen cart route (outside shell → no bottom nav) ──
    GoRoute(
      path: '/cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
  ],
);

/// Minimal helper – in a real app you'd use a repository or database.
Restaurant _findRestaurant(String id) {
  try {
    return sampleRestaurants.firstWhere((r) => r.id == id);
  } catch (_) {
    return sampleRestaurants.first;
  }
}

// ═══════════════════════════════════════════════════════
//  Convenience extension for navigating within the shell
// ═══════════════════════════════════════════════════════
extension ShellContext on BuildContext {
  /// Push a sub‑page that stays inside the shell (bottom nav preserved).
  void pushShell(String location, {Object? extra}) {
    final shell = _shellNavigatorKey.currentContext;
    if (shell != null) {
      GoRouter.of(shell).push(location, extra: extra);
    } else {
      GoRouter.of(this).push(location, extra: extra);
    }
  }

  /// Replace / pop to location inside the shell.
  void goShell(String location, {Object? extra}) {
    final shell = _shellNavigatorKey.currentContext;
    if (shell != null) {
      GoRouter.of(shell).go(location, extra: extra);
    } else {
      GoRouter.of(this).go(location, extra: extra);
    }
  }
}
