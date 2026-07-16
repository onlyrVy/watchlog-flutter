import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_names.dart';

/// Wraps every top-level tab in a persistent bottom nav bar via
/// go_router's [StatefulShellRoute]. Using a shell route (rather than
/// a plain BottomNavigationBar + IndexedStack built by hand) means
/// each tab keeps its own navigation stack and scroll position when
/// you switch away and back — standard behavior for apps like this.
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search'),
    (icon: Icons.video_library_outlined, activeIcon: Icons.video_library, label: 'Library'),
    (icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Stats'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tapping the already-active tab pops it back to its root,
          // matching the behavior users expect from Instagram/Letterboxd-style apps.
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.activeIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
