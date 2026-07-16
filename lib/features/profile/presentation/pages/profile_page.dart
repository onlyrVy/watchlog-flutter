import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You\'ll need to log in again to access your library.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log Out')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      // Router redirect (based on authProvider status) sends the user
      // back to /login automatically — no manual navigation needed here.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Text(
                    (user?.username ?? '?').substring(0, 1).toUpperCase(),
                    style: AppTextStyles.headlineMedium,
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMd),
                Text(user?.username ?? '', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(user?.email ?? '', style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceXl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Joined', style: AppTextStyles.bodyMedium),
                  Text(
                    user != null ? _formatDate(user.joinDate) : '—',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spaceXl),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
