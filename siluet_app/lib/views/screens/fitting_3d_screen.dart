import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../viewmodels/app_viewmodel.dart';

class Fitting3DScreen extends StatefulWidget {
  final String modelUrl;
  const Fitting3DScreen({super.key, required this.modelUrl});

  @override
  State<Fitting3DScreen> createState() => _Fitting3DScreenState();
}

class _Fitting3DScreenState extends State<Fitting3DScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _heightController = TextEditingController();
  final _shoulderController = TextEditingController();

  void _saveFitting() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama Pengantin dan Nomor WA Wajib Diisi!')),
      );
      return;
    }

    final vm = context.read<AppViewModel>();
    vm.saveFittingMeasurement(
      clientName: _nameController.text,
      clientPhone: _phoneController.text,
      chest: double.tryParse(_chestController.text) ?? 0.0,
      waist: double.tryParse(_waistController.text) ?? 0.0,
      height: double.tryParse(_heightController.text) ?? 0.0,
      shoulder: double.tryParse(_shoulderController.text) ?? 0.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ukuran Fitting disimpan & Ringkasan dikirim otomatis via WhatsApp! 📲')),
    );

    // Clear form
    _nameController.clear();
    _phoneController.clear();
    _chestController.clear();
    _waistController.clear();
    _heightController.clear();
    _shoulderController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Fitting 3D'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: ScreenTypeLayout.builder(
        mobile: (context) => _buildMobile(),
        tablet: (context) => _buildTablet(),
      ),
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 3D Canvas Box
        Expanded(
          flex: 4,
          child: _buildModelViewer(),
        ),
        // Sliders & Forms
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF14161D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: Color(0xFF262626), width: 0.8)),
            ),
            child: _buildForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildTablet() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildModelViewer()),
        Container(
          width: 0.8,
          color: const Color(0xFF262626),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: const Color(0xFF14161D),
            child: _buildForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildModelViewer() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF090A0F),
          child: ModelViewer(
            src: widget.modelUrl,
            alt: "Model 3D Manekin Pengantin",
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: const Color(0xFF090A0F),
          ),
        ),
        // floating tag overlay
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xFFE5A93B).withOpacity(0.3), width: 0.8),
            ),
            child: const Row(
              children: [
                Icon(Icons.threed_rotation, color: Color(0xFFE5A93B), size: 14),
                SizedBox(width: 6),
                Text(
                  'INTERAKTIF 3D MANEKIN',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForm() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        const Text(
          'Ukuran Badan Pengantin CPW',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Input detail ukuran untuk memodifikasi baju akad/resepsi.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Divider(height: 32, color: Color(0xFF262626)),
        
        _buildTextField('Nama Lengkap Pengantin', _nameController, isText: true, icon: Icons.person_outline),
        _buildTextField('Nomor WhatsApp', _phoneController, isText: true, icon: Icons.phone_android_outlined),
        
        const SizedBox(height: 10),
        const Text('Dimensi Fisik (cm):', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _buildTextField('Lingkar Dada', _chestController, icon: Icons.straighten)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Lingkar Pinggang', _waistController, icon: Icons.straighten)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('Tinggi Badan', _heightController, icon: Icons.height)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Lebar Bahu', _shoulderController, icon: Icons.align_horizontal_center)),
          ],
        ),
        
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _saveFitting,
          child: const Text('Simpan & Kirim ke WhatsApp'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isText = false, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isText ? TextInputType.text : TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFFE5A93B), size: 18),
          filled: true,
          fillColor: const Color(0xFF1C1E26),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF262626), width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5A93B), width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
