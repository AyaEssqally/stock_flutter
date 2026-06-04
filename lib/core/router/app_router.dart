import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/repository_providers.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/home/home_shell.dart';
import '../../presentation/screens/mouvements/mouvements_screen.dart';
import '../../presentation/screens/products/products_screen.dart';
import '../../presentation/screens/setup/firebase_setup_screen.dart';
import '../providers/app_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final firebaseReady = ref.watch(firebaseReadyProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      if (!firebaseReady) {
        if (loc != '/setup') return '/setup';
        return null;
      }

      if (loc == '/setup') {
        return authAsync.valueOrNull != null ? '/home/products' : '/login';
      }

      final userId = authAsync.valueOrNull;
      final loggingIn = isAuthRoute;

      if (userId == null) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) return '/home/products';
      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        builder: (_, __) => const FirebaseSetupScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home/products',
            builder: (_, __) => const ProductsScreen(),
          ),
          GoRoute(
            path: '/home/categories',
            builder: (_, __) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/home/mouvements',
            builder: (_, __) => const MouvementsScreen(),
          ),
          GoRoute(
            path: '/home/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
        ],
      ),
    ],
  );
});
