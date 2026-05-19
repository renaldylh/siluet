import 'package:flutter/material.dart';
import '../../models/attire_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_viewmodel.dart';


class AttireCard extends StatefulWidget {
  final AttireItem item;
  const AttireCard({super.key, required this.item});

  @override
  State<AttireCard> createState() => _AttireCardState();
}

class _AttireCardState extends State<AttireCard> {
  int _currentMediaIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias, // Memastikan gambar rounded
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Internal (Kategori & ID Paket)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, color: Color(0xFFE5A93B), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kategori: ${widget.item.category} • ID: ${widget.item.id}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Status Badge (Tersedia / Disewa)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.item.status == 'Tersedia' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: widget.item.status == 'Tersedia' ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    widget.item.status,
                    style: TextStyle(
                      color: widget.item.status == 'Tersedia' ? Colors.green[400] : Colors.orange[400],
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              ],
            ),
          ),

          // 2. Foto Utama / Carousel Media (PageView untuk banyak Gambar & Video)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  itemCount: widget.item.mediaUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentMediaIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final mediaUrl = widget.item.mediaUrls[index];
                    final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
                                    mediaUrl.toLowerCase().contains('.mov') ||
                                    mediaUrl.toLowerCase().contains('/video/upload/');

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: isVideo
                              ? "https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?auto=format&fit=crop&w=500" // Placeholder video
                              : mediaUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: Color(0xFFE5A93B)),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        if (isVideo)
                          Container(
                            color: Colors.black.withOpacity(0.4),
                            child: const Center(
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.play_arrow, size: 36, color: Color(0xFFE5A93B)),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                // Indicator Dots ala Instagram
                if (widget.item.mediaUrls.length > 1)
                  Positioned(
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.item.mediaUrls.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentMediaIndex == index ? 8 : 5,
                          height: _currentMediaIndex == index ? 8 : 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentMediaIndex == index
                                ? const Color(0xFFE5A93B)
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 3. Deskripsi Kelengkapan Baju
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kelengkapan Item:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                    Text(
                      '${widget.item.items.length} Item',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFE5A93B), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Wrap chips untuk printilan set baju pernikahan
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.item.items.map((printilan) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
                      ),
                      child: Text(
                        printilan,
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 0.5, color: Color(0xFF262626)),
                const SizedBox(height: 12),
                
                // 4. Action Buttons Internal (Edit, Status, WA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.delete_outline, 'Hapus', () {
                      _confirmDelete(context);
                    }),
                    _buildActionButton(Icons.sync_alt, 'Status', () {
                      final newStatus = widget.item.status == 'Tersedia' ? 'Disewa' : 'Tersedia';
                      context.read<AppViewModel>().updateAttireStatus(widget.item.id, newStatus);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Status diubah menjadi $newStatus')),
                      );
                    }),
                    _buildActionButton(Icons.send_outlined, 'Kirim WA', () {
                      _showWhatsAppDialog(context);
                    }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14161D),
        title: const Text('Hapus Item', style: TextStyle(color: Colors.white)),
        content: Text('Apakah Anda yakin ingin menghapus "${widget.item.name}" dari katalog?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AppViewModel>().deleteAttireItem(widget.item.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showWhatsAppDialog(BuildContext context) {
    final phoneController = TextEditingController();
    final messageController = TextEditingController(
      text: "Halo, set baju *${widget.item.name}* saat ini berstatus *${widget.item.status}* di Siluet Wedding Attire! ✨"
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14161D),
        title: const Text('Kirim Info via WA', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nomor WA (contoh: 0812...)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Pesan',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (phoneController.text.isNotEmpty) {
                final success = await context.read<AppViewModel>().sendWhatsApp(
                  phoneController.text,
                  messageController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Pesan terkirim via WA!' : 'Gagal mengirim pesan.')),
                );
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

