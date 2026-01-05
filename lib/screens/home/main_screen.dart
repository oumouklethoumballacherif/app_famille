import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../trees/trees_screen.dart';
import '../search/search_screen.dart';
import '../events/events_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../../l10n/app_localizations.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TreesScreen(),
    SearchScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];

  List<BottomNavigationBarItem> _navItems(BuildContext context) => [
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_tree_outlined),
      activeIcon: const Icon(Icons.account_tree),
      label: AppLocalizations.of(context)!.navTrees,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.search_outlined),
      activeIcon: const Icon(Icons.search),
      label: AppLocalizations.of(context)!.navSearch,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.event_outlined),
      activeIcon: const Icon(Icons.event),
      label: AppLocalizations.of(context)!.navEvents,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.person_outline),
      activeIcon: const Icon(Icons.person),
      label: AppLocalizations.of(context)!.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _navItems(context),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      // Admin FAB
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboardScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.accentColor,
              heroTag: 'admin_fab',
              child: const Icon(Icons.admin_panel_settings),
            )
          : null,
    );
  }
}
