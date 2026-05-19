# Panduan Menjalankan & Membangun (Build) Proyek Siluet Attire

Dokumen ini menjelaskan langkah-langkah untuk menyiapkan lingkungan pengembangan, menjalankan aplikasi Siluet Wedding Attire, serta memproduksi file rilis siap pakai untuk platform **Android (APK/AAB)** dan **iOS (IPA)**.

---

## 📋 Persyaratan Sistem
Sebelum memulai, pastikan perangkat Anda telah terinstal:
1. **Flutter SDK**: Versi stable terbaru (minimal v3.0.0).
2. **Dart SDK**: Terinstal otomatis bersama Flutter.
3. **Android Studio**: Untuk build Android (disertai Android SDK terbaru).
4. **Xcode**: Hanya untuk macOS, dibutuhkan untuk build iOS.
5. **Koneksi Internet**: Untuk sinkronisasi dependensi dan database Firebase/Cloudinary.

---

## 🚀 Langkah 1: Persiapan Awal (Setup)

1. Buka terminal atau Command Prompt (CMD) di direktori proyek `siluet_app`:
   ```bash
   cd d:\project\WO\siluet_app
   ```
2. Bersihkan sisa build lama dan unduh dependensi terbaru:
   ```bash
   flutter clean
   flutter pub get
   ```
3. Pastikan tidak ada masalah konfigurasi di lingkungan sistem Anda dengan menjalankan:
   ```bash
   flutter doctor
   ```

---

## 💻 Langkah 2: Menjalankan Proyek Secara Lokal (Debug)

### A. Menjalankan di Web (Google Chrome)
Sangat direkomendasikan untuk uji coba cepat:
```bash
flutter run -d chrome
```

### B. Menjalankan di Android (Emulator/Perangkat Asli)
1. Hubungkan HP Android dengan fitur **USB Debugging** aktif, atau jalankan emulator dari Android Studio.
2. Jalankan perintah:
   ```bash
   flutter run
   ```

### C. Menjalankan di iOS Simulator (Hanya macOS)
1. Buka Simulator dari Xcode.
2. Jalankan perintah:
   ```bash
   flutter run -d iphone
   ```

---

## 📦 Langkah 3: Membuat Rilis Android (APK & AAB)

Ada dua format rilis utama untuk Android:
1. **APK (Application Package)**: Untuk instalasi langsung secara manual ke HP klien/tim internal.
2. **AAB (Android App Bundle)**: Format standar untuk diunggah ke Google Play Store.

### A. Membuat Rilis APK (Siap Instal)
Jalankan perintah berikut:
```bash
flutter build apk --release
```
- **Hasil Build**: File APK yang dihasilkan dapat ditemukan di:
  `build/app/outputs/flutter-apk/app-release.apk`
- Anda dapat menyalin file `app-release.apk` ini langsung ke HP Android untuk diinstal.

### B. Membuat Rilis AAB (Siap Upload Play Store)
Jalankan perintah berikut:
```bash
flutter build appbundle --release
```
- **Hasil Build**: File AAB yang dihasilkan dapat ditemukan di:
  `build/app/outputs/bundle/release/app-release.aab`

---

## 🍏 Langkah 4: Membuat Rilis iOS (IPA / TestFlight)

Untuk memproduksi aplikasi iOS, Anda harus menggunakan sistem operasi **macOS** dan memiliki akun **Apple Developer**.

### A. Konfigurasi Signing di Xcode (Satu kali saja)
1. Buka folder proyek iOS dengan Xcode:
   - Jalankan perintah: `open ios/Runner.xcworkspace` atau buka Xcode secara manual lalu pilih folder `ios/Runner.xcworkspace`.
2. Di Xcode, pilih proyek **Runner** di panel sebelah kiri.
3. Buka tab **Signing & Capabilities**.
4. Pilih **Team** Anda (Apple Developer Account) dan tentukan **Bundle Identifier** unik Anda.

### B. Membuat Build Archive & File IPA
1. Kembali ke terminal proyek, jalankan perintah:
   ```bash
   flutter build ipa --release
   ```
2. **Hasil Build**: Folder output rilis berada di:
   `build/ios/archive/Runner.xcarchive` dan file ekspor berada di `build/ios/ipa/Runner.ipa`.
3. Anda dapat mengunggah file IPA tersebut ke **App Store Connect** menggunakan **Transporter App** atau Xcode Organizer untuk pengujian via **TestFlight** atau rilis publik.

---

## 🌐 Langkah 5: Membuat Rilis Web (Hosting/CPanel)
Jika ingin meng-host sistem management internal ini di website/server sendiri:
```bash
flutter build web --release
```
- **Hasil Build**: Semua file siap hosting (HTML, JS, Assets) berada di direktori `build/web/`. Anda hanya perlu mengunggah isi folder tersebut ke server hosting Anda.
