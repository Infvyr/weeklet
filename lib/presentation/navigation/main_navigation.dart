import 'package:flutter/material.dart';
import 'package:weeklet/presentation/screens/expenses/expenses_screen.dart';
import 'package:weeklet/presentation/screens/income/income_screen.dart';
import 'package:weeklet/presentation/screens/settings/settings_screen.dart';
import 'package:weeklet/presentation/screens/stats/stats_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ExpensesScreen(),
    const IncomeScreen(),
    const StatsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) => setState(
    () => _selectedIndex = index,
  );

  @override
  Widget build(
    BuildContext context,
  ) => Scaffold(
    body: _screens[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.trending_up,
          ),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
