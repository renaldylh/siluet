import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dkvtfgqne";
  static const String uploadPreset = "ml_default"; // Ganti dengan preset upload Anda di Cloudinary jika menggunakan nama custom

  /// Mengunggah foto atau file 3D (.glb) dari HP/Tablet ke Cloudinary
  /// Mengembalikan Tautan URL (String) jika sukses.
  Future<String?> uploadFile(String filePath, {bool is3DModel = false}) async {
    // Jika file 3D, kita upload sebagai 'raw', jika gambar sebagai 'image'
    final resourceType = is3DModel ? 'raw' : 'image';
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload");
    
    final request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final result = json.decode(String.fromCharCodes(responseData));
        
        // Mengembalikan URL Gambar/3D yang sudah aktif dan dihosting oleh Cloudinary
        return result['secure_url']; 
      } else {
        print("Gagal upload. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan jaringan saat upload ke Cloudinary: $e");
      return null;
    }
  }
}
