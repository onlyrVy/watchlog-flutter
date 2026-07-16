import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Placeholder route target. Full poster/overview/cast layout, save
/// controls (status, rating, review) get built in Phase 3 (TMDb
/// detail fetch) and Phase 4 (save/rate/review CRUD).
class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Center(
        child: Text('Movie #$movieId — details coming in Phase 3', style: AppTextStyles.bodyMedium),
      ),
    );
  }
}
