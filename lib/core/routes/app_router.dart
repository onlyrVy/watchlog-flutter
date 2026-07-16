import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_shell_page.dart';
import '../../features/movie/presentation/pages/movie_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/watchlist/presentation/pages/library_page.dart';
import 'route_names.dart';

/// Router is exposed as a provider (rather than a global constant) so
/// it can watch [authProvider] and redirect on auth changes — e.g.
/// logging out from Profile immediately kicks the user to /login
/// with no manual navigation calls needed anywhere else in the app.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final isAuthResolved = authState.status != AuthStatus.unknown;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isOnSplash = state.matchedLocation == RouteNames.splash;
      final isOnAuthPage = state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register;

      if (!isAuthResolved) {
        // Still restoring session — stay on splash regardless of target.
        return isOnSplash ? null : RouteNames.splash;
      }
      if (!isAuthenticated && !isOnAuthPage) return RouteNames.login;
      if (isAuthenticated && (isOnAuthPage || isOnSplash)) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashPage()),
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: RouteNames.register, builder: (context, state) => const RegisterPage()),
      GoRoute(
        path: RouteNames.movieDetail,
        builder: (context, state) => MovieDetailPage(movieId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.home, builder: (context, state) => const HomePage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.search, builder: (context, state) => const SearchPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.library, builder: (context, state) => const LibraryPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.statistics, builder: (context, state) => const StatisticsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.profile, builder: (context, state) => const ProfilePage()),
          ]),
        ],
      ),
    ],
  );
});
