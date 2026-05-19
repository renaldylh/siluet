import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/app_viewmodel.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedStatusFilter = 'Semua';

  void _showAddRentalBottomSheet(BuildContext context) {
    final vm = context.read<AppViewModel>();
    final availableAttires = vm.catalog.where((element) => element.status == 'Tersedia').toList();

    if (availableAttires.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua koleksi baju sedang disewa atau belum siap! 👗')),
      );
      return;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final priceController = TextEditingController();
    String? selectedAttireId = availableAttires.first.id;
    DateTime selectedReturnDate = DateTime.now().add(const Duration(days: 3));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF14161D),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Buat Transaksi Sewa Baru',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF262626)),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedAttireId,
                          dropdownColor: const Color(0xFF14161D),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          items: availableAttires.map((item) {
                            return DropdownMenuItem(value: item.id, child: Text(item.name));
                          }).toList(),
                          onChanged: (val) => setState(() => selectedAttireId = val),
                          decoration: InputDecoration(
                            labelText: 'Pilih Pakaian Pengantin',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Nama Klien (Pengantin)',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE5A93B))),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'No. WhatsApp Klien',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE5A93B))),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: priceController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Harga Sewa (Rp)',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE5A93B))),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tanggal Pengembalian:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMMM yyyy').format(selectedReturnDate),
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedReturnDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: Color(0xFFE5A93B),
                                          onPrimary: Colors.black,
                                          surface: Color(0xFF14161D),
                                          onSurface: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setState(() => selectedReturnDate = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_month, color: Color(0xFFE5A93B)),
                              label: const Text('Pilih Tanggal', style: TextStyle(color: Color(0xFFE5A93B))),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF262626)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty || priceController.text.isEmpty) return;
                        vm.createRentalOrder(
                          clientName: nameController.text,
                          clientPhone: phoneController.text,
                          attireId: selectedAttireId!,
                          returnDate: selectedReturnDate,
                          price: int.tryParse(priceController.text) ?? 0,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sewa berhasil dibuat & nota otomatis dikirim via WhatsApp! 📲')),
                        );
                      },
                      child: const Text('Konfirmasi & Buat Sewa'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AppViewModel>();
    final rentals = vm.rentals;

    // Filter logik
    final filteredRentals = rentals.where((order) {
      final isOverdue = DateTime.now().isAfter(order.returnDate) && order.status == 'Disewa';
      if (_selectedStatusFilter == 'Semua') return true;
      if (_selectedStatusFilter == 'Disewa') return order.status == 'Disewa' && !isOverdue;
      if (_selectedStatusFilter == 'Terlambat') return isOverdue;
      if (_selectedStatusFilter == 'Selesai') return order.status == 'Dikembalikan';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kegiatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Status Filter Pills ala Instagram
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildStatusPill('Semua'),
                _buildStatusPill('Disewa'),
                _buildStatusPill('Terlambat'),
                _buildStatusPill('Selesai'),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),

          // 2. Daftar List Transaksi Sewa
          Expanded(
            child: filteredRentals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_outlined, size: 64, color: Colors.grey[800]),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada transaksi sewa',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRentals.length,
                    itemBuilder: (context, index) {
                      final order = filteredRentals[index];
                      final isOverdue = DateTime.now().isAfter(order.returnDate) && order.status == 'Disewa';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14161D),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF262626), width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card Header
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isOverdue 
                                        ? Colors.red.withOpacity(0.1) 
                                        : (order.status == 'Disewa' ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1)),
                                    child: Icon(
                                      isOverdue 
                                          ? Icons.error_outline 
                                          : (order.status == 'Disewa' ? Icons.login_outlined : Icons.check_circle_outline),
                                      color: isOverdue 
                                          ? Colors.red[400] 
                                          : (order.status == 'Disewa' ? Colors.blue[400] : Colors.green[400]),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.attireName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Klien: ${order.clientName} (${order.clientPhone})',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildBadge(isOverdue, order.status),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 0.5, color: Color(0xFF262626)),
                            // Card Details
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('TANGGAL PINJAM', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text(DateFormat('dd MMM yyyy').format(order.rentDate), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('BATAS KEMBALI', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd MMM yyyy').format(order.returnDate),
                                        style: TextStyle(
                                          color: isOverdue ? Colors.red[400] : Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('TOTAL BIAYA', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${NumberFormat('#,###').format(order.price)}',
                                        style: const TextStyle(color: Color(0xFFE5A93B), fontSize: 13, fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Action Button jika masih Disewa
                            if (order.status == 'Disewa') ...[
                              const Divider(height: 1, thickness: 0.5, color: Color(0xFF262626)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    vm.completeRentalOrder(order.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Baju berhasil dikembalikan & terdata masuk kembali! 👗')),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green[400],
                                    side: BorderSide(color: Colors.green[400]!.withOpacity(0.5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Konfirmasi Pengembalian Baju', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              )
                            ]
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRentalBottomSheet(context),
        backgroundColor: const Color(0xFFE5A93B),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildStatusPill(String name) {
    final active = _selectedStatusFilter == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: active ? Colors.white : const Color(0xFF14161D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? Colors.white : const Color(0xFF262626),
            width: 0.8,
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(bool isOverdue, String status) {
    Color bg = Colors.green.withOpacity(0.1);
    Color fg = Colors.green[400]!;
    String label = 'Kembali';

    if (status == 'Disewa') {
      if (isOverdue) {
        bg = Colors.red.withOpacity(0.1);
        fg = Colors.red[400]!;
        label = 'Terlambat';
      } else {
        bg = Colors.blue.withOpacity(0.1);
        fg = Colors.blue[400]!;
        label = 'Disewa';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: fg.withOpacity(0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
