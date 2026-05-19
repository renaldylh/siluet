import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/attire_item.dart';
import '../../models/rental_order.dart';
import '../../models/fitting_measurement.dart';

class FirebaseService {
  static const String baseUrl = "https://mywo-9c5c6-default-rtdb.firebaseio.com";

  // Mendapatkan semua katalog pakaian dari Realtime Database
  Future<List<AttireItem>> getCatalog() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/inventory_baju.json"));
      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return [];
        }
        final Map<String, dynamic> data = json.decode(response.body);
        final List<AttireItem> items = [];
        data.forEach((key, value) {
          if (value != null) {
            final Map<String, dynamic> itemMap = Map<String, dynamic>.from(value);
            final defaultPhoto = itemMap['foto_url'] ?? itemMap['photoUrl'] ?? '';
            items.add(AttireItem(
              id: key,
              name: itemMap['nama_paket'] ?? itemMap['name'] ?? '',
              category: itemMap['kategori'] ?? itemMap['category'] ?? '',
              items: List<String>.from(itemMap['kelengkapan'] ?? itemMap['items'] ?? []),
              photoUrl: defaultPhoto,
              mediaUrls: List<String>.from(itemMap['media_urls'] ?? itemMap['mediaUrls'] ?? (defaultPhoto.isNotEmpty ? [defaultPhoto] : [])),
              model3dUrl: itemMap['model_3d_url'] ?? itemMap['model3dUrl'],
              status: itemMap['status'] ?? 'Tersedia',
            ));
          }
        });
        return items;
      } else {
        print("Gagal memuat katalog: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error getCatalog dari Firebase: $e");
      return [];
    }
  }

  // Menyimpan pakaian baru ke Realtime Database
  Future<void> saveAttireItem(AttireItem item) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/inventory_baju/${item.id}.json"),
        body: json.encode({
          'nama_paket': item.name,
          'kategori': item.category,
          'kelengkapan': item.items,
          'foto_url': item.photoUrl,
          'media_urls': item.mediaUrls,
          'model_3d_url': item.model3dUrl,
          'status': item.status,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saveAttireItem ke Firebase: $e");
    }
  }


  // Mendapatkan stream untuk mendengarkan perubahan secara berkala (polling)
  Stream<List<AttireItem>> streamCatalog() async* {
    while (true) {
      yield await getCatalog();
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  // Menyimpan fitting ukuran pengantin wanita/pria ke Realtime Database
  Future<void> saveFitting(FittingMeasurement fitting) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/fitting_orders/${fitting.id}.json"),
        body: json.encode(fitting.toFirestore()),
      );
      if (response.statusCode != 200) {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saveFitting ke Firebase: $e");
    }
  }

  // Mendapatkan semua fitting dari Realtime Database
  Future<List<FittingMeasurement>> getFittings() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/fitting_orders.json"));
      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return [];
        }
        final Map<String, dynamic> data = json.decode(response.body);
        final List<FittingMeasurement> fittings = [];
        data.forEach((key, value) {
          if (value != null) {
            fittings.add(FittingMeasurement.fromFirestore(Map<String, dynamic>.from(value), key));
          }
        });
        return fittings;
      } else {
        print("Gagal memuat fitting: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error getFittings dari Firebase: $e");
      return [];
    }
  }

  // Update status pakaian (misal: ketika disewa, diubah ke 'Disewa')
  Future<void> updateAttireStatus(String attireId, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/inventory_baju/$attireId.json"),
        body: json.encode({
          'status': newStatus,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updateAttireStatus ke Firebase: $e");
    }
  }

  // Mendapatkan semua order sewa dari Realtime Database
  Future<List<RentalOrder>> getRentals() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/rentals.json"));
      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return [];
        }
        final Map<String, dynamic> data = json.decode(response.body);
        final List<RentalOrder> rentals = [];
        data.forEach((key, value) {
          if (value != null) {
            rentals.add(RentalOrder.fromFirestore(Map<String, dynamic>.from(value), key));
          }
        });
        return rentals;
      } else {
        print("Gagal memuat rentals: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error getRentals dari Firebase: $e");
      return [];
    }
  }

  // Menyimpan/update order sewa ke Realtime Database
  Future<void> saveRentalOrder(RentalOrder order) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/rentals/${order.id}.json"),
        body: json.encode(order.toFirestore()),
      );
      if (response.statusCode != 200) {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saveRentalOrder ke Firebase: $e");
    }
  }

  // Register a user
  Future<bool> registerUser(String username, String password) async {
    try {
      final sanitizedUsername = username.trim().toLowerCase().replaceAll(RegExp(r'[.#$\[\]]'), '_');
      if (sanitizedUsername.isEmpty) return false;
      
      final checkResponse = await http.get(Uri.parse("$baseUrl/users/$sanitizedUsername.json"));
      if (checkResponse.statusCode == 200 && checkResponse.body != 'null' && checkResponse.body.isNotEmpty) {
        return false; // User already exists
      }

      final response = await http.put(
        Uri.parse("$baseUrl/users/$sanitizedUsername.json"),
        body: json.encode({
          'username': username,
          'password': password,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error registerUser: $e");
      return false;
    }
  }

  // Login a user
  Future<bool> loginUser(String username, String password) async {
    try {
      final sanitizedUsername = username.trim().toLowerCase().replaceAll(RegExp(r'[.#$\[\]]'), '_');
      if (sanitizedUsername.isEmpty) return false;

      final response = await http.get(Uri.parse("$baseUrl/users/$sanitizedUsername.json"));
      if (response.statusCode == 200 && response.body != 'null' && response.body.isNotEmpty) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return userData['password'] == password;
      }
      return false;
    } catch (e) {
      print("Error loginUser: $e");
      return false;
    }
  }

  // Menghapus pakaian dari Realtime Database
  Future<void> deleteAttireItem(String attireId) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/inventory_baju/$attireId.json"));
      if (response.statusCode != 200) {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleteAttireItem: $e");
    }
  }
}



