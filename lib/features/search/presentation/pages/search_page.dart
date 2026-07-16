import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Search UI shell. The text field and layout are functional now;
/// the actual TMDb query + results grid get wired in during Phase 3
/// (SearchRepository -> TMDb API -> paginated results).
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for a movie…',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppConstants.spaceXl * 2),
            Icon(Icons.local_movies_outlined, size: 40, color: AppColors.textDisabled),
            const SizedBox(height: AppConstants.spaceMd),
            Text(
              'Search results from TMDb will appear here.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
