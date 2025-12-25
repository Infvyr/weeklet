import 'package:flutter/material.dart';
import 'package:weeklet/presentation/screens/expenses/expenses_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ExpensesScreen(),
    const Center(child: Text('Stats')),
    const Center(
      child: Text('Settings'),
    ),
  ];

  @override
  Widget build(
    BuildContext context,
  ) => Scaffold(
    body: IndexedStack(
      index: _currentIndex,
      children: _pages,
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(
        () => _currentIndex = index,
      ),
      type: BottomNavigationBarType.fixed,
      useLegacyColorScheme: false,
      iconSize: 20,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Expenses',
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
    ),
  );
}
