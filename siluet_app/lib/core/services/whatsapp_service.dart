import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppService {
  // Ganti URL, Session ID, dan API Key ini sesuai konfigurasi server OpenWA Anda
  static const String defaultBaseUrl = "http://localhost:2785";
  static const String defaultSessionId = "siluet";
  static const String defaultApiKey = "";

  /// Mengirim pesan teks WhatsApp ke nomor tujuan menggunakan OpenWA Gateway
  /// target: nomor HP tujuan (misal: 08123456789 atau +628123456789)
  /// message: isi pesan
  Future<bool> sendWhatsAppMessage(
    String target, 
    String message, {
    String baseUrl = defaultBaseUrl,
    String sessionId = defaultSessionId,
    String apiKey = defaultApiKey,
  }) async {
    try {
      // 1. Normalisasi nomor telepon ke format OpenWA (628xxxxxxxx@c.us)
      String formattedTarget = _formatPhoneNumber(target);

      // 2. Bersihkan URL dari slash di akhir
      final cleanBaseUrl = baseUrl.replaceAll(RegExp(r'/$'), '');
      final endpoint = Uri.parse("$cleanBaseUrl/api/sessions/$sessionId/messages/send-text");

      // 3. Setup Header
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      if (apiKey.isNotEmpty) {
        headers["X-API-Key"] = apiKey;
      }

      print("📤 Mengirim WA via OpenWA ke $formattedTarget...");

      // 4. Request API
      final response = await http.post(
        endpoint,
        headers: headers,
        body: json.encode({
          "chatId": formattedTarget,
          "text": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ WhatsApp berhasil dikirim ke $target");
        return true;
      } else {
        print("❌ Gagal kirim WA. Status HTTP: ${response.statusCode}. Respon: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Terjadi kesalahan koneksi ke OpenWA: $e");
      return false;
    }
  }

  /// Helper untuk normalisasi nomor telepon ke format standard OpenWA (e.g. 628123456789@c.us)
  String _formatPhoneNumber(String target) {
    String clean = target.trim();
    
    // Hapus tanda '+' jika ada
    if (clean.startsWith('+')) {
      clean = clean.substring(1);
    }
    
    // Ubah awalan '0' menjadi '62' (kode negara Indonesia)
    if (clean.startsWith('0')) {
      clean = '62' + clean.substring(1);
    }
    
    // Tambahkan domain JID whatsapp jika belum ada
    if (!clean.endsWith('@c.us') && !clean.endsWith('@g.us')) {
      clean = '$clean@c.us';
    }
    
    return clean;
  }
}
