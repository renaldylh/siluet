import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attire_item.dart';
import '../models/rental_order.dart';
import '../models/fitting_measurement.dart';
import '../core/services/firebase_service.dart';
import '../core/services/cloudinary_service.dart';
import '../core/services/whatsapp_service.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final WhatsAppService _whatsAppService = WhatsAppService();

  List<AttireItem> _catalog = [];
  List<RentalOrder> _rentals = [];
  List<FittingMeasurement> _fittings = [];
  
  bool _isLoading = false;
  String? _currentUser;

  List<AttireItem> get catalog => _catalog;
  List<RentalOrder> get rentals => _rentals;
  List<FittingMeasurement> get fittings => _fittings;
  bool get isLoading => _isLoading;
  String? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _firebaseService.loginUser(username, password);
      if (success) {
        _currentUser = username;
      }
      return success;
    } catch (e) {
      print("Login error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _firebaseService.registerUser(username, password);
    } catch (e) {
      print("Register error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }


  AppViewModel() {
    initializeData();
  }

  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();
    try {
      // 1. Fetch catalog
      final remoteCatalog = await _firebaseService.getCatalog();
      if (remoteCatalog.isEmpty) {
        // Seed catalog with initial mock data
        _catalog = [
          AttireItem(
            id: 'A1',
            name: 'Satu Set Baju Akad CPP (Sunda)',
            category: 'Akad CPP',
            items: ['Beskap', 'Celana', 'Samping', 'Bendo', 'Boro', 'Kris', 'Selop'],
            photoUrl: 'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?auto=format&fit=crop&w=500',
            mediaUrls: ['https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?auto=format&fit=crop&w=500'],
            model3dUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
            status: 'Tersedia',
          ),
          AttireItem(
            id: 'A2',
            name: 'Satu Set Baju Akad CPW (Kebaya)',
            category: 'Akad CPW',
            items: ['Kebaya', 'Samping', 'Kemben', 'Manset', 'Hijab', 'Slayer', 'Selop', 'Ekor'],
            photoUrl: 'https://images.unsplash.com/photo-1591555200889-aa8413158c5a?auto=format&fit=crop&w=500',
            mediaUrls: ['https://images.unsplash.com/photo-1591555200889-aa8413158c5a?auto=format&fit=crop&w=500'],
            model3dUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
            status: 'Tersedia',
          ),
          AttireItem(
            id: 'A3',
            name: 'Satu Set Baju Resepsi CPW',
            category: 'Resepsi CPW',
            items: ['Kebaya Modern', 'Samping Premium', 'Kemben', 'Manset', 'Hijab', 'Slayer Labuh', 'Selop Payet', 'Ekor Panjang'],
            photoUrl: 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=500',
            mediaUrls: ['https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=500'],
            status: 'Disewa',
          ),
        ];
        for (var item in _catalog) {
          await _firebaseService.saveAttireItem(item);
        }
      } else {
        _catalog = remoteCatalog;
      }

      // 2. Fetch rentals
      final remoteRentals = await _firebaseService.getRentals();
      if (remoteRentals.isEmpty) {
        _rentals = [
          RentalOrder(
            id: 'R1',
            clientName: 'Siti Rahma',
            clientPhone: '08123456789',
            attireId: 'A3',
            attireName: 'Satu Set Baju Resepsi CPW',
            rentDate: DateTime.now().subtract(const Duration(days: 2)),
            returnDate: DateTime.now().add(const Duration(days: 2)),
            status: 'Disewa',
            price: 3500000,
          )
        ];
        for (var order in _rentals) {
          await _firebaseService.saveRentalOrder(order);
        }
      } else {
        _rentals = remoteRentals;
      }

      // 3. Fetch fittings
      final remoteFittings = await _firebaseService.getFittings();
      _fittings = remoteFittings;

      // 4. Start catalog stream to stay synced in background
      _firebaseService.streamCatalog().listen((items) {
        if (items.isNotEmpty) {
          _catalog = items;
          notifyListeners();
        }
      });
    } catch (e) {
      print("Error initializing Firebase data, loading mock: $e");
      _loadMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadMockData() {
    _catalog = [
      AttireItem(
        id: 'A1',
        name: 'Satu Set Baju Akad CPP (Sunda)',
        category: 'Akad CPP',
        items: ['Beskap', 'Celana', 'Samping', 'Bendo', 'Boro', 'Kris', 'Selop'],
        photoUrl: 'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?auto=format&fit=crop&w=500',
        mediaUrls: ['https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?auto=format&fit=crop&w=500'],
        model3dUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        status: 'Tersedia',
      ),
      AttireItem(
        id: 'A2',
        name: 'Satu Set Baju Akad CPW (Kebaya)',
        category: 'Akad CPW',
        items: ['Kebaya', 'Samping', 'Kemben', 'Manset', 'Hijab', 'Slayer', 'Selop', 'Ekor'],
        photoUrl: 'https://images.unsplash.com/photo-1591555200889-aa8413158c5a?auto=format&fit=crop&w=500',
        mediaUrls: ['https://images.unsplash.com/photo-1591555200889-aa8413158c5a?auto=format&fit=crop&w=500'],
        model3dUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        status: 'Tersedia',
      ),
      AttireItem(
        id: 'A3',
        name: 'Satu Set Baju Resepsi CPW',
        category: 'Resepsi CPW',
        items: ['Kebaya Modern', 'Samping Premium', 'Kemben', 'Manset', 'Hijab', 'Slayer Labuh', 'Selop Payet', 'Ekor Panjang'],
        photoUrl: 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=500',
        mediaUrls: ['https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=500'],
        status: 'Disewa',
      ),
    ];

    _rentals = [
      RentalOrder(
        id: 'R1',
        clientName: 'Siti Rahma',
        clientPhone: '08123456789',
        attireId: 'A3',
        attireName: 'Satu Set Baju Resepsi CPW',
        rentDate: DateTime.now().subtract(const Duration(days: 2)),
        returnDate: DateTime.now().add(const Duration(days: 2)),
        status: 'Disewa',
        price: 3500000,
      )
    ];
    notifyListeners();
  }

  // Mengirim Pesan WhatsApp Manual/Notifikasi
  Future<bool> sendWhatsApp(String target, String message) async {
    return await _whatsAppService.sendWhatsAppMessage(target, message);
  }

  // Menambah Pakaian Baru
  Future<bool> addAttireItem({
    required String name,
    required String category,
    required List<String> items,
    required List<String> localMediaPaths,
    String? local3DPath,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<String> mediaUrls = [];
      for (var path in localMediaPaths) {
        if (path.isNotEmpty && path.startsWith('http')) {
          // If it's already an uploaded URL (default/mock)
          mediaUrls.add(path);
        } else if (path.isNotEmpty) {
          String? url = await _cloudinaryService.uploadFile(path);
          if (url != null) {
            mediaUrls.add(url);
          }
        }
      }

      if (mediaUrls.isEmpty) throw Exception("Gagal mengunggah media ke Cloudinary");

      String? model3dUrl;
      if (local3DPath != null && local3DPath.isNotEmpty) {
        if (local3DPath.startsWith('http')) {
          model3dUrl = local3DPath;
        } else {
          model3dUrl = await _cloudinaryService.uploadFile(local3DPath, is3DModel: true);
        }
      }

      final newItem = AttireItem(
        id: 'A${_catalog.length + 1}',
        name: name,
        category: category,
        items: items,
        photoUrl: mediaUrls.first,
        mediaUrls: mediaUrls,
        model3dUrl: model3dUrl,
        status: 'Tersedia',
      );

      await _firebaseService.saveAttireItem(newItem);
      
      // Update local state
      _catalog.add(newItem);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Gagal menambahkan barang: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Membuat Order Sewa (Keluar Barang) + Kirim Nota WA Otomatis
  Future<void> createRentalOrder({
    required String clientName,
    required String clientPhone,
    required String attireId,
    required DateTime returnDate,
    required int price,
  }) async {
    final attire = _catalog.firstWhere((element) => element.id == attireId);
    
    final newOrder = RentalOrder(
      id: 'R${_rentals.length + 1}',
      clientName: clientName,
      clientPhone: clientPhone,
      attireId: attireId,
      attireName: attire.name,
      rentDate: DateTime.now(),
      returnDate: returnDate,
      status: 'Disewa',
      price: price,
    );

    // Save to Firebase
    await _firebaseService.saveRentalOrder(newOrder);
    await _firebaseService.updateAttireStatus(attireId, 'Disewa');

    // Update local state
    _rentals.add(newOrder);
    final index = _catalog.indexWhere((element) => element.id == attireId);
    if (index != -1) {
      _catalog[index] = AttireItem(
        id: attire.id,
        name: attire.name,
        category: attire.category,
        items: attire.items,
        photoUrl: attire.photoUrl,
        mediaUrls: attire.mediaUrls,
        model3dUrl: attire.model3dUrl,
        status: 'Disewa',
      );
    }
    notifyListeners();

    // KIRIM NOTA KONFIRMASI WA OTOMATIS
    final formattedPrice = NumberFormat('#,###').format(price);
    final formattedReturnDate = DateFormat('dd MMMM yyyy').format(returnDate);
    final waMessage = "Halo Kak *$clientName*,\n\n"
        "Terima kasih telah menyewa pakaian di *Siluet Wedding Attire*! ✨\n\n"
        "Berikut adalah detail sewa Anda:\n"
        "Baju: *${attire.name}*\n"
        "Harga Sewa: *Rp $formattedPrice*\n"
        "Tanggal Sewa: *${DateFormat('dd MMMM yyyy').format(DateTime.now())}*\n"
        "Batas Pengembalian: *$formattedReturnDate*\n\n"
        "Mohon jaga kebersihan dan keutuhan kelengkapan baju. Sampai jumpa di hari H pernikahan Anda! 👰🤵";
    
    await sendWhatsApp(clientPhone, waMessage);
  }

  // Pengembalian Sewa (Masuk Barang) + Kirim Terima Kasih WA Otomatis
  Future<void> completeRentalOrder(String orderId) async {
    final orderIndex = _rentals.indexWhere((element) => element.id == orderId);
    if (orderIndex != -1) {
      final order = _rentals[orderIndex];

      final updatedOrder = RentalOrder(
        id: order.id,
        clientName: order.clientName,
        clientPhone: order.clientPhone,
        attireId: order.attireId,
        attireName: order.attireName,
        rentDate: order.rentDate,
        returnDate: order.returnDate,
        status: 'Dikembalikan',
        price: order.price,
      );

      // Save to Firebase
      await _firebaseService.saveRentalOrder(updatedOrder);
      await _firebaseService.updateAttireStatus(order.attireId, 'Tersedia');

      // Update local state
      _rentals[orderIndex] = updatedOrder;
      final attireIndex = _catalog.indexWhere((element) => element.id == order.attireId);
      if (attireIndex != -1) {
        final attire = _catalog[attireIndex];
        _catalog[attireIndex] = AttireItem(
          id: attire.id,
          name: attire.name,
          category: attire.category,
          items: attire.items,
          photoUrl: attire.photoUrl,
          mediaUrls: attire.mediaUrls,
          model3dUrl: attire.model3dUrl,
          status: 'Tersedia',
        );
      }
      notifyListeners();

      // KIRIM WA NOTIFIKASI PENGEMBALIAN SUKSES
      final waMessage = "Halo Kak *${order.clientName}*,\n\n"
          "Kami mengonfirmasi bahwa pakaian sewa *${order.attireName}* telah kami terima kembali dengan lengkap dan baik. \n\n"
          "Terima kasih telah mempercayakan momen bahagia Anda bersama *Siluet Wedding Attire*! ❤️";
      
      await sendWhatsApp(order.clientPhone, waMessage);
    }
  }

  // Menyimpan Ukuran Badan Fitting Pengantin CPW + Kirim Detail WA Otomatis
  Future<void> saveFittingMeasurement({
    required String clientName,
    required String clientPhone,
    required double chest,
    required double waist,
    required double height,
    required double shoulder,
  }) async {
    final newFitting = FittingMeasurement(
      id: 'F${_fittings.length + 1}',
      clientName: clientName,
      clientPhone: clientPhone,
      chestCircumference: chest,
      waistCircumference: waist,
      height: height,
      shoulderWidth: shoulder,
      date: DateTime.now(),
    );

    // Save to Firebase
    await _firebaseService.saveFitting(newFitting);

    // Update local state
    _fittings.add(newFitting);
    notifyListeners();

    // KIRIM SPESIFIKASI UKURAN FITTING LANGSUNG KE WA KLIEN
    final waMessage = "Halo Kak *$clientName*,\n\n"
        "Berikut adalah rangkuman data ukuran fitting Anda di *Siluet Wedding Attire*:\n\n"
        "📏 *Detail Ukuran Badan (CPW)*:\n"
        "• Lingkar Dada: *$chest cm*\n"
        "• Lingkar Pinggang: *$waist cm*\n"
        "• Tinggi Badan: *$height cm*\n"
        "• Lebar Bahu: *$shoulder cm*\n\n"
        "Data ini telah tersimpan aman di database kami untuk penyesuaian baju akad/resepsi Anda. Terimakasih! ✨";

    await sendWhatsApp(clientPhone, waMessage);
  }

  Future<void> updateAttireStatus(String attireId, String newStatus) async {
    await _firebaseService.updateAttireStatus(attireId, newStatus);
    final index = _catalog.indexWhere((element) => element.id == attireId);
    if (index != -1) {
      final attire = _catalog[index];
      _catalog[index] = AttireItem(
        id: attire.id,
        name: attire.name,
        category: attire.category,
        items: attire.items,
        photoUrl: attire.photoUrl,
        mediaUrls: attire.mediaUrls,
        model3dUrl: attire.model3dUrl,
        status: newStatus,
      );
      notifyListeners();
    }
  }

  Future<void> deleteAttireItem(String attireId) async {
    await _firebaseService.deleteAttireItem(attireId);
    _catalog.removeWhere((element) => element.id == attireId);
    notifyListeners();
  }
}

