import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static const _stats = [
    (label: 'Movies Watched', value: '0', icon: Icons.check_circle_outline),
    (label: 'Watchlist Size', value: '0', icon: Icons.bookmark_border),
    (label: 'Average Rating', value: '—', icon: Icons.star_border),
    (label: 'Favorite Genre', value: '—', icon: Icons.category_outlined),
    (label: 'Most Watched Year', value: '—', icon: Icons.calendar_today_outlined),
    (label: 'Added This Month', value: '0', icon: Icons.trending_up),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppConstants.spaceMd,
          crossAxisSpacing: AppConstants.spaceMd,
          childAspectRatio: 1.3,
        ),
        itemCount: _stats.length,
        itemBuilder: (context, index) {
          final stat = _stats[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(stat.icon, color: Theme.of(context).colorScheme.primary),
                  const Spacer(),
                  Text(stat.value, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text(stat.label, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
