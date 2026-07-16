import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Library UI shell with the three status tabs (Watchlist / Watching /
/// Watched). Sort/filter controls are laid out now; querying
/// saved_movies from the Laravel API happens in Phase 4.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Watchlist'),
            Tab(text: 'Watching'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LibraryEmptyState(status: 'Watchlist', color: AppColors.watchlist),
          _LibraryEmptyState(status: 'Watching', color: AppColors.watching),
          _LibraryEmptyState(status: 'Watched', color: AppColors.watched),
        ],
      ),
    );
  }
}

class _LibraryEmptyState extends StatelessWidget {
  const _LibraryEmptyState({required this.status, required this.color});

  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(Icons.bookmark_border, color: color),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Text('No movies in $status yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppConstants.spaceXs),
            Text(
              'Movies you mark as $status will show up here.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
