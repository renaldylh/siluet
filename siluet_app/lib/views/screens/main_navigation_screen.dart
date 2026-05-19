import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'catalog_screen.dart';
import 'fitting_3d_screen.dart';
import 'schedule_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CatalogScreen(),
    const Fitting3DScreen(modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb'),
    const ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Bottom Navigation Bar Premium bergaya iOS / Instagram
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 26),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined, size: 26),
              activeIcon: Icon(Icons.search, size: 28),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new_outlined, size: 26),
              activeIcon: Icon(Icons.accessibility_new, size: 28),
              label: '3D Fitting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 26),
              activeIcon: Icon(Icons.calendar_month, size: 28),
              label: 'Schedules',
            ),
          ],
        ),
      ),
    );
  }
}
