# ⚜️ Siluet Wedding Attire Management App

Aplikasi manajemen inventaris pakaian pengantin, jadwal sewa, dan virtual fitting 3D internal untuk tim **Siluet Wedding Attire**. Dirancang khusus dengan estetika premium bergaya Instagram/iOS menggunakan palet warna gelap (deep slate black) dengan aksen emas.

---

## 🌟 Fitur Utama
1. **Dasbor Ringkasan (Dashboard)**: Statistik performa sewa, pelacakan pesanan aktif, pengembalian hari ini, serta akses cepat ke fungsi utama.
2. **Katalog Inventaris Multi-Media**:
   - Galeri pakaian interaktif dengan carousel gambar & video ala Instagram feed.
   - Unggah banyak media (foto/video) sekaligus ke Cloudinary.
   - CRUD (Create, Read, Update, Delete) penuh data inventaris.
3. **Virtual Fitting 3D (Uji Coba Virtual)**:
   - Pratinjau model gaun pengantin secara 3D langsung di dalam aplikasi (Web & Mobile).
   - Fitur simpan ukuran badan klien (lingkar dada, lingkar pinggang, lebar bahu, tinggi badan) otomatis.
4. **Jadwal Sewa & Kalender**: Memantau tanggal sewa, status pengembalian, kelengkapan item (printilan set baju), serta status ketersediaan secara real-time.
5. **Integrasi WhatsApp Gateway (OpenWA)**:
   - Kirim notifikasi konfirmasi booking otomatis ke klien.
   - Kirim rincian ukuran fitting badan (CPW) langsung ke WA klien.
   - Kirim notifikasi pengembalian sukses.
   - Kirim pesan manual dengan template status ketersediaan baju sekali klik.

---

## 🛠️ Stack Teknologi
- **Framework**: [Flutter](https://flutter.dev/) (Dart) - Kompatibel untuk Web, Android, & iOS.
- **Database**: [Firebase Realtime Database](https://firebase.google.com/) terintegrasi via REST API (untuk stabilitas performa lintas platform instan).
- **Penyimpanan Media**: [Cloudinary](https://cloudinary.com/).
- **Penyedia Script 3D**: [model_viewer_plus](https://pub.dev/packages/model_viewer_plus) dengan integrasi pustaka Google `<model-viewer>` v3.4.0.
- **State Management**: [Provider](https://pub.dev/packages/provider) (Arsitektur MVVM).

---

## 📁 Struktur Folder & Arsitektur
Aplikasi ini mengikuti pola arsitektur **MVVM (Model-View-ViewModel)** demi kemudahan pemeliharaan kode:

```text
lib/
├── core/
│   └── services/              # Koneksi pihak ketiga (REST API Firebase, Cloudinary, WhatsApp)
├── models/                    # Model data struktural (AttireItem, RentalOrder, FittingMeasurement)
├── viewmodels/                # Logika bisnis dan manajemen state reaktif (AppViewModel)
├── views/
│   ├── screens/               # Halaman utama aplikasi (Auth, Dashboard, Catalog, Fitting, Schedule)
│   └── widgets/               # Komponen UI reusable (AttireCard, StatCard, dll.)
└── main.dart                  # Titik entri utama aplikasi (Inisialisasi & Routing)
```

---

## 🚀 Persiapan & Instalasi Lokal

### 1. Prasyarat Sistem
- Flutter SDK (Versi stable terbaru)
- Android SDK / Xcode (untuk build mobile)
- Koneksi Internet aktif

### 2. Pemasangan Dependencies
Jalankan perintah berikut di direktori proyek:
```bash
flutter clean
flutter pub get
```

### 3. Menjalankan Aplikasi (Debug Mode)
- **Di Browser (Chrome)**:
  ```bash
  flutter run -d chrome
  ```
- **Di Perangkat Android**:
  ```bash
  flutter run
  ```
- **Di iOS Simulator (macOS)**:
  ```bash
  flutter run -d iphone
  ```

---

## 📦 Panduan Build Aplikasi (Release)

### 🤖 Android
Untuk membuat berkas instalasi Android:
1. **APK (Instal Langsung)**:
   ```bash
   flutter build apk --release
   ```
   *File output*: `build/app/outputs/flutter-apk/app-release.apk`
2. **AAB (Upload ke Play Store)**:
   ```bash
   flutter build appbundle --release
   ```
   *File output*: `build/app/outputs/bundle/release/app-release.aab`

### 🍏 iOS
Untuk membuat berkas distribusi iOS (memerlukan macOS):
1. Buka folder `ios/Runner.xcworkspace` di Xcode untuk mengatur konfigurasi *Signing Team* Anda.
2. Jalankan perintah kompilasi:
   ```bash
   flutter build ipa --release
   ```
   *File output*: `build/ios/ipa/Runner.ipa`

### ☁️ Build Otomatis via Codemagic (Tanpa Mac & Tanpa Xcode Lokal)
Proyek ini sudah dilengkapi dengan konfigurasi **`codemagic.yaml`** di direktori root.
1. Hubungkan repositori Git proyek Anda ke akun **[Codemagic.io](https://codemagic.io/)**.
2. Jalankan build otomatis untuk workflow `Android Release Build` atau `iOS Release Build`.
3. Hasil build (`.apk` / `.ipa`) dapat langsung diunduh secara gratis di dasbor Codemagic setelah proses kompilasi cloud selesai.

#### 💡 Workaround Instalasi iOS (.ipa) Tanpa Apple Developer Account ($99/tahun):
- **AltStore / SideStore**: Memanfaatkan Apple ID gratis Anda untuk melakukan *sideloading* lokal di iPhone (Maksimal 3 aplikasi, diperbarui otomatis setiap 7 hari via Wi-Fi).
- **Xcode Personal Team**: Sambungkan iPhone ke Mac, gunakan *Personal Team* gratis di Xcode untuk instalasi debug/release lokal (masa aktif 7 hari).
- **Progressive Web App (PWA)**: Build untuk Web (`flutter build web`), lalu unggah ke hosting gratis (Vercel/Netlify). Buka web di Safari iPhone dan pilih **"Add to Home Screen"** untuk merasakan sensasi instalasi aplikasi native gratis selamanya.

---

## 📄 Lisensi
Proyek ini dilindungi di bawah **[Lisensi MIT](LICENSE)**. Anda bebas menggunakan, memodifikasi, dan mendistribusikan perangkat lunak ini secara gratis untuk kebutuhan komersial maupun non-komersial.

*Copyright (c) 2026 Siluet Wedding Attire*
