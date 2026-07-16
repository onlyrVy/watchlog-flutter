import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Dashboard shell. Sections are laid out now with placeholder/empty
/// states; real data (recently added, watchlist count, average
/// rating, etc.) gets wired in during Phase 5 once the Laravel
/// stats endpoint exists.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.username ?? 'there'}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        children: [
          Text('Continue Watching', style: AppTextStyles.titleLarge),
          const SizedBox(height: AppConstants.spaceMd),
          _EmptyStateCard(
            icon: Icons.play_circle_outline,
            message: 'Movies you\'re currently watching will show up here.',
          ),
          const SizedBox(height: AppConstants.spaceXl),
          Text('Recently Added', style: AppTextStyles.titleLarge),
          const SizedBox(height: AppConstants.spaceMd),
          _EmptyStateCard(
            icon: Icons.movie_outlined,
            message: 'Search for a movie to add it to your library.',
          ),
          const SizedBox(height: AppConstants.spaceXl),
          Row(
            children: [
              Expanded(child: _QuickStatCard(label: 'Watchlist', value: '0')),
              const SizedBox(width: AppConstants.spaceMd),
              Expanded(child: _QuickStatCard(label: 'Watched', value: '0')),
              const SizedBox(width: AppConstants.spaceMd),
              Expanded(child: _QuickStatCard(label: 'Avg. Rating', value: '—')),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: AppConstants.spaceSm),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceMd, horizontal: AppConstants.spaceSm),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
