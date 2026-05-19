import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.diamond_outlined, size: 48, color: Colors.amber),
                  SizedBox(height: 12),
                  Text('SILUET ATTIRE', style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
                ],
              ),
            ),
            _buildItem(context, Icons.dashboard, 'Dashboard', '/'),
            _buildItem(context, Icons.inventory_2, 'Catalog Barang', '/catalog'),
            _buildItem(context, Icons.calendar_month, 'Penjadwalan', '/schedule'),
            _buildItem(context, Icons.accessibility_new, '3D Fitting', '/fitting'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        context.pop(); // tutup drawer
        context.go(route);
      },
    );
  }
}
