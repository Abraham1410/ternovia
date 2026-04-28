# 🐂 Ternovia

Aplikasi pendamping peternak — Dinas Peternakan Kabupaten Jombang.  
Front-end Flutter dengan design sistem earthy-brown sesuai Figma.

---

## 📋 Prasyarat

- **Flutter 3.3.0** ([download di sini](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.3.0-stable.zip))
- **Dart 2.18.x** (sudah termasuk dalam Flutter 3.3.0)
- **Android Studio** (untuk Android SDK + emulator)
- **VS Code** dengan extension Flutter & Dart
- **JDK 11** (recommended untuk Flutter 3.3.0)

---

## 🚀 Cara Menjalankan (Step by Step)

### 1. Extract Zip
Extract `ternovia.zip` ke folder project-mu, misalnya `D:\Projects\ternovia`.

### 2. Buka di VS Code
```bash
cd D:\Projects\ternovia
code .
```

### 3. Init Project Flutter
Karena zip ini TIDAK mengandung folder native Android lengkap (hanya `AndroidManifest.xml`), kita perlu generate ulang folder `android/` lengkap dengan Gradle:

```bash
flutter create --platforms=android .
```

Flutter akan:
- Generate folder `android/` lengkap (gradle, kotlin MainActivity, dll)
- **TIDAK** menimpa file `lib/`, `pubspec.yaml`, `assets/`, dan `AndroidManifest.xml` yang sudah ada
- Membuat file native yang kompatibel dengan versi Flutter kamu

### 4. Download Font Poppins
Download dari [Google Fonts — Poppins](https://fonts.google.com/specimen/Poppins) atau [fontsource](https://fontsource.org/fonts/poppins).

Letakkan 4 file ini di `assets/fonts/`:
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`

> **Catatan**: Kalau kamu skip step ini, app tetap jalan karena `google_fonts` package akan auto-download Poppins dari internet saat runtime. Tapi lebih cepat & offline-ready kalau asset ada.

### 5. Install Dependencies
```bash
flutter pub get
```

**Kalau error "requires Dart SDK >=3.0.0"**: berarti ada package auto-update ke versi terbaru. Cek `pubspec.yaml` — pastikan versi package sesuai yang saya tulis (ada komentar "kompatibel Flutter 3.3.0"). Jangan jalankan `flutter pub upgrade`.

### 6. Jalankan di Device

**Cek device tersedia:**
```bash
flutter devices
```

**Run:**
```bash
flutter run
```

Atau di VS Code: tekan **F5** (pilih device-nya di status bar bawah).

---

## 📁 Struktur Folder

```
ternovia/
├── lib/
│   ├── main.dart                    # Entry point + orientation lock
│   ├── app.dart                     # MaterialApp.router + ProviderScope wrapper
│   │
│   ├── core/                        # Infrastructure (theme, router, utils)
│   │   ├── theme/
│   │   │   ├── app_colors.dart      # Palette dari Figma (brown, cream, status)
│   │   │   ├── app_typography.dart  # Text style Poppins
│   │   │   ├── app_spacing.dart     # 4pt grid + radius
│   │   │   └── app_theme.dart       # ThemeData assembly
│   │   ├── router/
│   │   │   └── app_router.dart      # go_router dengan page transitions
│   │   ├── animations/
│   │   │   ├── page_transitions.dart    # Custom route transitions
│   │   │   └── fade_slide_in.dart       # Widget animator reusable
│   │   └── constants/
│   │       └── app_assets.dart          # Path konstanta
│   │
│   ├── features/                        # Feature-based modules
│   │   ├── splash/                  # ✨ Motion sequence 4-stage
│   │   ├── onboarding/              # "Selamat Datang" dengan staggered animation
│   │   ├── auth/                    # Role selection (Peternak/Petugas)
│   │   ├── dashboard/               # Home — greeting, stats, production
│   │   ├── ternak/                  # Menu ternak dengan tab
│   │   ├── layanan/                 # Menu layanan (SKT, bantuan, pakan)
│   │   ├── edukasi/                 # Artikel & video
│   │   ├── jadwal/                  # Kalendar + list jadwal
│   │   ├── profil/                  # Profile, pengaturan, about
│   │   └── notifikasi/              # Notifikasi list
│   │
│   └── shared/                          # Cross-feature reusable
│       ├── layouts/
│       │   └── main_shell.dart          # Bottom nav dengan tombol Ternak menonjol
│       └── widgets/
│           └── success_dialog.dart      # Animated popup "Berhasil!"
│
├── assets/
│   ├── images/                      # Logo, hero onboarding, illustration
│   ├── icons/                       # Custom icon (SVG/PNG)
│   ├── fonts/                       # Poppins font files
│   └── animations/                  # Lottie JSON kalau pakai
│
├── android/                             # Generated oleh flutter create
├── pubspec.yaml                         # Dependencies (kompatibel 3.3.0)
└── analysis_options.yaml                # Linter config
```

---

## ✨ Motion & Animasi

### 1. Splash Screen — Sequence 4 Tahap
Sesuai design Figma (Splash Screen 1, 2, 6, 7):

| Tahap | Durasi | Deskripsi |
|---|---|---|
| **1** | 0–800ms | Full brown background (solid) |
| **2** | 800–1100ms | Background fade ke cream |
| **3** | 1100–1900ms | Logo icon T muncul (scale + elastic + fade) |
| **4** | 1900–2600ms | Text "TERNOVIA" slide in dari kanan |
| **5** | 2600–3800ms | Hold, lalu auto-navigate ke `/onboarding` |

Lokasi: `lib/features/splash/presentation/screens/splash_screen.dart`

### 2. Page Transitions
- **Fade + Slide Up** (default): Splash → Onboarding
- **Slide Horizontal**: Detail pages, forward navigation
- **Fade Only**: Tab switching (dashboard ↔ ternak ↔ dll)
- **Scale Fade**: Modal popup

Lokasi: `lib/core/animations/page_transitions.dart`

### 3. Staggered Entry Animation
Tiap item list (stat cards, activity, kandang list) masuk dengan delay bertahap:
```dart
StaggeredList(
  baseDelay: Duration(milliseconds: 200),
  children: [Item1(), Item2(), Item3()],
)
```
Setiap item fade + slide dari bawah dengan jeda 80ms.

Lokasi: `lib/core/animations/fade_slide_in.dart`

### 4. Success Dialog — Elastic Bounce
Dialog "Berhasil Bergabung!", "Berhasil Menambah Ternak", dll:
- Scale in dari 0.7 → 1.0 dengan easeOutBack
- Checkmark muncul setelah dialog, dengan elasticOut
- Auto sequenced via `Future`.

Usage:
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => SuccessDialog(
    title: 'Berhasil Bergabung!',
    message: 'Kamu sudah menjadi bagian dari kelompok ternak.',
    onConfirm: () => Navigator.pop(context),
  ),
);
```

### 5. Bottom Nav Button Ternak — Floating Effect
Tombol "Ternak" di tengah menonjol keluar dari bar (transform translateY) dengan shadow, sesuai design Figma.

---

## 🎨 Design Token dari Figma

### Colors
| Token | Hex | Usage |
|---|---|---|
| `primary` | `#6B3410` | Brown utama (header, button, logo) |
| `primaryLight` | `#8B4513` | Gradient target |
| `background` | `#FDF5EE` | Cream background utama |
| `cardHealth` | `#5C6B3F` | Green olive untuk stat sehat |
| `cardAlert` | `#C17B5C` | Orange-brown untuk alert |
| `success` | `#4A7C3A` | Status berhasil/hijau |
| `warning` | `#D97B3C` | Orange warning |
| `danger` | `#C44536` | Red bahaya |

### Typography
Font: **Poppins** (4 weights: 400, 500, 600, 700)
- Display Large (32/700) — "Selamat Datang!"
- Heading Large (22/600) — Section title
- Body Medium (14/400) — Default text
- Button (16/600) — CTA text

---

## 🧭 Flow Routing

```
/splash (auto-navigate 3.8s)
   ↓
/onboarding (Selamat Datang + hero)
   ↓ [Mulai Sekarang]
/role-selection (Peternak / Petugas Lapangan)
   ↓ [Pilih role]
/dashboard  ←→  /ternak  ←→  /layanan  ←→  /edukasi  ←→  /profil
   (5 tab dengan bottom nav, switching via fade transition)
   
   Nested routes:
   /notifikasi (dari dashboard bell icon)
   /jadwal (dari menu)
```

---

## 🛠️ Yang Masih Perlu Kamu Lakukan

Project ini adalah **skeleton + sample implementations**. Berikut yang perlu kamu kerjakan untuk full coverage sesuai Figma (~50 screens):

### Assets (WAJIB sebelum production)
- [ ] Export logo Ternovia dari Figma sebagai PNG @2x dan @3x (taruh di `assets/images/logo_ternovia.png`)
- [ ] Export hero illustration onboarding (sapi + ayam + telur) → `assets/images/onboarding_hero.png`
- [ ] Export illustration farmer untuk Gabung Kelompok → `assets/images/illustration_farmer.png`
- [ ] Download Poppins font files → `assets/fonts/`
- [ ] Ganti `_TernoviaLogoPainter` placeholder di `splash_screen.dart` dengan `Image.asset`

### Screens Belum Ditambahkan (tinggal copy pola dari yang sudah ada)
- [ ] Buat Kelompok Baru (multi-step form 3 tahap)
- [ ] Gabung Kelompok (input kode undangan)
- [ ] Tambah Kandang / Tambah Ternak (upload foto + form)
- [ ] Detail Kandang / Detail Ternak
- [ ] Input Kesehatan (mode kandang / per individu / massal)
- [ ] Laporan Kunjungan Petugas
- [ ] Detail Artikel & Tips (markdown-style)
- [ ] Detail Video Edukasi (pakai `video_player` package)
- [ ] Bookmark (kosong / isi)
- [ ] Info Harga Pasar
- [ ] Pengajuan Sample Pakan (form + timeline)
- [ ] Detail Kebijakan Privasi / Panduan Penggunaan
- [ ] Ubah Kata Sandi

### Fitur Non-UI (nanti kalau API siap)
- [ ] Integrasi REST API (`dio` package)
- [ ] Auth flow (login/logout + token storage via `flutter_secure_storage`)
- [ ] Riverpod providers untuk tiap feature (ganti hardcoded data)
- [ ] Form validation (reactive_forms / custom)
- [ ] Image picker & upload
- [ ] Push notification (Firebase Messaging)

---

## 🐛 Troubleshooting

**Error: "requires Dart SDK >=3.0.0"**  
→ Turunkan versi package di `pubspec.yaml`. Jangan pakai `^latest`. Lihat tabel versi kompatibel di `pubspec.yaml` saya.

**Error: "No Android SDK found"**  
→ Buka Android Studio → SDK Manager → install Android SDK Platform 33 (Tiramisu), build-tools 33.0.2.

**Error: "Gradle task assembleDebug failed"**  
→ Edit `android/build.gradle`, set `ext.kotlin_version = '1.7.10'`. Di `android/gradle/wrapper/gradle-wrapper.properties`, pastikan `distributionUrl` ke Gradle 7.4+.

**App crash di splash tanpa log**  
→ Cek kalau `google_fonts` gagal download (butuh internet saat first run). Pakai font offline dengan letakkan file TTF di `assets/fonts/`.

**Bottom nav tidak switch**  
→ Pastikan route `/dashboard`, `/ternak`, dll terdaftar di `app_router.dart`. Pastikan kamu pakai `context.go()` bukan `context.push()`.

---

## 📝 Catatan

- **Responsive**: Design dioptimalkan untuk HP mobile (portrait). Untuk tablet perlu custom breakpoint (belum implemented).
- **Locale**: Default Indonesia. Format tanggal pakai `intl` package dengan locale `id_ID` (butuh init di `main.dart` kalau pakai: `initializeDateFormatting('id_ID', null)`).
- **Dark mode**: Belum diimplementasi. Theme saat ini hanya light.

---

## 🤝 Kontribusi ke Project

1. Clone, buat branch baru per feature: `git checkout -b feat/tambah-ternak`
2. Ikuti struktur folder `features/[nama]/presentation/screens/`
3. Reuse widget dari `shared/widgets/`
4. Pakai `FadeSlideIn` dan `StaggeredList` untuk entry animation
5. Semua text style dari `AppTypography`, color dari `AppColors`, spacing dari `AppSpacing`

---

**Built with ☕ and Flutter**
