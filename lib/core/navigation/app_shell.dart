import 'package:finapp/features/insights/insights_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:finapp/features/profile/profile_screen.dart';
import 'package:finapp/features/dashboard/dashboard_screen.dart';
import 'package:finapp/features/budget/budget_screen.dart';
import 'package:finapp/features/quick_entry/quick_entry_sheet_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BudgetScreen(),
    const InsightsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const QuickEntrySheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
