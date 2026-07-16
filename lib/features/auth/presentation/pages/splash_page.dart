import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/auth_provider.dart';

/// Shown briefly on app launch while [AuthNotifier] restores any
/// existing session. Holds no logic itself — the router (see
/// app_router.dart) watches [authProvider] and redirects away from
/// here once the status resolves to authenticated/unauthenticated.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching here ensures this page rebuilds (and the router
    // re-evaluates redirects) the moment the auth status resolves.
    ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_creation_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 16),
            Text('WatchLog', style: AppTextStyles.displayLarge),
            const SizedBox(height: 32),
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
