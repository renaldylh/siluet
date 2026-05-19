import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../models/attire_item.dart';
import '../widgets/attire_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<String> _categories = [
    'Akad CPP', 'Akad CPW', 'Resepsi CPW', 'Resepsi CPP', 
    'Baju Ibu', 'Baju Bapak', 'Pagar Ayu', 'Pagar Bagus'
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  List<String> _getDefaultItems(String category) {
    switch (category) {
      case 'Akad CPP':
        return ['Beskap', 'Celana', 'Samping', 'Bendo', 'Boro', 'Kris', 'Selop'];
      case 'Akad CPW':
      case 'Resepsi CPW':
        return ['Kebaya', 'Samping', 'Kemben', 'Manset', 'Hijab', 'Slayer', 'Selop', 'Ekor'];
      case 'Resepsi CPP':
        return ['Baju', 'Celana', 'Rompi', 'Kemeja', 'Dasi'];
      case 'Baju Ibu':
        return ['Kebaya', 'Samping', 'Kemben', 'Manset', 'Hijab', 'Slayer', 'Selop', 'Ekor'];
      case 'Baju Bapak':
        return ['Jas atau Beskap', 'Samping', 'Peci', 'Selop'];
      case 'Pagar Ayu':
        return ['Samping', 'Kebaya', 'Hijab'];
      case 'Pagar Bagus':
        return ['Beskap dan Celana', 'Samping', 'Peci', 'Selop'];
      default:
        return ['Pakaian Utama'];
    }
  }

  void _showAddAttireDialog(BuildContext context) {
    final vm = context.read<AppViewModel>();
    final nameController = TextEditingController();
    String selectedCategory = _categories.first;
    List<String> printilanItems = List.from(_getDefaultItems(selectedCategory));
    List<String> mediaPaths = [];
    String model3dPath = 'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
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
                          'Koleksi Baju Baru',
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
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Nama Set Baju',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE5A93B))),
                            hintText: 'Contoh: Kebaya Resepsi Sunda Silver',
                            hintStyle: const TextStyle(color: Colors.white24),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          dropdownColor: const Color(0xFF14161D),
                          style: const TextStyle(color: Colors.white),
                          items: _categories.map((cat) {
                            return DropdownMenuItem(value: cat, child: Text(cat));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedCategory = val;
                                printilanItems = List.from(_getDefaultItems(selectedCategory));
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Kategori Baju',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Media Foto & Video (Cloudinary):',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        if (mediaPaths.isEmpty)
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.02),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                            ),
                            child: const Center(
                              child: Text(
                                'Belum ada media. Tambah minimal 1 media di bawah.',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mediaPaths.length,
                              itemBuilder: (context, idx) {
                                final path = mediaPaths[idx];
                                final isVideo = path.toLowerCase().contains('.mp4') ||
                                                path.toLowerCase().contains('.mov') ||
                                                path.toLowerCase().contains('/video/upload/');
                                return Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFF262626)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            isVideo
                                                ? 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?auto=format&fit=crop&w=150'
                                                : path
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (isVideo)
                                      const Positioned.fill(
                                        child: Center(
                                          child: Icon(Icons.play_circle, color: Color(0xFFE5A93B), size: 28),
                                        ),
                                      ),
                                    Positioned(
                                      top: 2,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            mediaPaths.removeAt(idx);
                                          });
                                        },
                                        child: const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close, size: 12, color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Quick add a mock premium wedding image
                                  final mockImages = [
                                    'https://images.unsplash.com/photo-1591555200889-aa8413158c5a?auto=format&fit=crop&w=500',
                                    'https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=500',
                                    'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?auto=format&fit=crop&w=500',
                                    'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=500',
                                  ];
                                  final nextMock = mockImages[mediaPaths.length % mockImages.length];
                                  setState(() {
                                    mediaPaths.add(nextMock);
                                  });
                                },
                                icon: const Icon(Icons.image_outlined, size: 16),
                                label: const Text('Tambah Foto', style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C1E26),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: Color(0xFF262626)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Add a mock wedding video URL
                                  setState(() {
                                    mediaPaths.add('https://assets.mixkit.co/videos/preview/mixkit-wedding-rings-on-a-table-40118-large.mp4');
                                  });
                                },
                                icon: const Icon(Icons.videocam_outlined, size: 16),
                                label: const Text('Tambah Video', style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C1E26),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: Color(0xFF262626)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Model 3D (.glb) Path/URL:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: model3dPath,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tautan file .glb model 3D',
                            hintStyle: const TextStyle(color: Colors.white24),
                            filled: true,
                            fillColor: const Color(0xFF1C1E26),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF262626)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFE5A93B)),
                            ),
                          ),
                          onChanged: (val) {
                            model3dPath = val.trim();
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Kelengkapan Item (Printilan):',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        // Checklist Item
                        ...printilanItems.map((item) {
                          return Theme(
                            data: ThemeData.dark().copyWith(unselectedWidgetColor: Colors.grey[600]),
                            child: CheckboxListTile(
                              title: Text(item, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              value: true,
                              activeColor: const Color(0xFFE5A93B),
                              checkColor: Colors.black,
                              onChanged: (val) {
                                if (val == false) {
                                  setState(() => printilanItems.remove(item));
                                }
                              },
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 10),
                        // Tambah Kustom Item
                        TextButton.icon(
                          onPressed: () {
                            final customItemController = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF14161D),
                                title: const Text('Kelengkapan Kustom', style: TextStyle(color: Colors.white)),
                                content: TextField(
                                  controller: customItemController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Misal: Kalung Rantai Emas',
                                    hintStyle: TextStyle(color: Colors.white30),
                                  ),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (customItemController.text.isNotEmpty) {
                                        setState(() {
                                          printilanItems.add(customItemController.text);
                                        });
                                      }
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Tambah'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE5A93B)),
                          label: const Text('Tambah Kelengkapan Kustom', style: TextStyle(color: Color(0xFFE5A93B))),
                        )
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF262626)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty || mediaPaths.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nama Baju dan minimal 1 media harus diisi!')),
                          );
                          return;
                        }
                        final success = await vm.addAttireItem(
                          name: nameController.text,
                          category: selectedCategory,
                          items: printilanItems,
                          localMediaPaths: mediaPaths,
                          local3DPath: model3dPath,
                        );

                        if (success && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Berhasil mengunggah koleksi ke Cloudinary dan disinkronkan ke database!')),
                          );
                        }
                      },
                      child: const Text('Simpan Koleksi Baru'),
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
    final catalog = context.watch<AppViewModel>().catalog;

    // Filter & Search logik
    final filteredCatalog = catalog.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Semua' || item.category == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksplorasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Sleek Search Bar ala Instagram iPhone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1E26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Cari baju akad, resepsi, pagar ayu...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),

          // 2. Kategori Filter Scrollable
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterTag('Semua'),
                ..._categories.map((cat) => _buildFilterTag(cat)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),

          // 3. Grid Hasil Pencarian / Galeri Feed
          Expanded(
            child: filteredCatalog.isEmpty
                ? const Center(
                    child: Text('Koleksi tidak ditemukan', style: TextStyle(color: Colors.grey)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Full width ala Instagram Feed
                      childAspectRatio: 0.72,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredCatalog.length,
                    itemBuilder: (context, index) {
                      return AttireCard(item: filteredCatalog[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAttireDialog(context),
        backgroundColor: const Color(0xFFE5A93B),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildFilterTag(String name) {
    final active = _selectedFilter == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = name;
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
}
