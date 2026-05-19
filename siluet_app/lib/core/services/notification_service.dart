import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // 1. Meminta izin notifikasi (Wajib untuk iOS dan Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Izin notifikasi diberikan oleh staf');
    }

    // 2. Mendapatkan Token Perangkat (Alamat spesifik Tablet/HP ini)
    String? token = await _fcm.getToken();
    print('Token Perangkat FCM: $token');
    // TODO: Simpan token ini ke Firestore pengguna (staf toko), 
    // agar backend tahu perangkat mana yang akan di-ping jika ada jadwal.

    // 3. Mendengarkan Notifikasi saat aplikasi sedang dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notifikasi Jadwal Diterima: ${message.notification?.title}');
      
      // Jika ada peringatan tenggang waktu sewa
      if (message.data['type'] == 'PENGEMBALIAN_TELAT') {
        // Tampilkan Banner Darurat di Layar
        print("Peringatan: Baju dari order ${message.data['orderId']} belum dikembalikan!");
      }
    });
  }
}
