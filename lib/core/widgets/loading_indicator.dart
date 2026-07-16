import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Centered circular loading indicator, styled with the app's accent
/// color. Used for full-page and inline loading states.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
        ),
      ),
    );
  }
}
