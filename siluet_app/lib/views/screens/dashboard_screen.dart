import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../widgets/attire_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<AppViewModel>().catalog;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('SILUET ATTIRE'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 22, color: Color(0xFFE5A93B)),
            onPressed: () {
              context.read<AppViewModel>().logout();
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          // 1. Akses Cepat (Visual smooth ala Stories iOS, fungsionalitas admin)
          _buildQuickAccess(),
          const Divider(height: 1, thickness: 0.5),

          // 2. Info Statistik Mini yang Premium (Capsule Info)
          _buildStatCapsules(),

          // 3. Header Bagian List
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Aktivitas Baju Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          // 4. Daftar Set Pakaian (Manajemen view premium)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: catalog.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AttireCard(item: catalog[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    final menus = [
      {'name': 'Scan QR', 'icon': Icons.qr_code, 'active': true},
      {'name': 'Jadwal', 'icon': Icons.calendar_month, 'active': false},
      {'name': 'Klien', 'icon': Icons.people_outline, 'active': false},
      {'name': 'Laporan', 'icon': Icons.analytics_outlined, 'active': true},
      {'name': 'Settings', 'icon': Icons.settings, 'active': false},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          final active = menu['active'] as bool;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran Gold Khas iOS Premium
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: active
                            ? const LinearGradient(
                                colors: [Color(0xFFE5A93B), Color(0xFFF7D070)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: active ? null : Colors.grey[800],
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF090A0F), // Sama dengan warna bg
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[900],
                      child: Icon(menu['icon'] as IconData, color: active ? const Color(0xFFE5A93B) : Colors.white70, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  menu['name'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCapsules() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          _buildCapsule('Baju Masuk', '12 Set', Colors.blue),
          _buildCapsule('Baju Keluar', '5 Set', Colors.orange),
          _buildCapsule('Fitting', '3 Klien', Colors.purple),
          _buildCapsule('Laundry', '8 Set', Colors.red),
        ],
      ),
    );
  }

  Widget _buildCapsule(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.2), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
