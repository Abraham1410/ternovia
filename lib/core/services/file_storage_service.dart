import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Service untuk handle file storage — copy file upload ke app's
/// document directory biar path persistent.
///
/// Tanpa copy, `FilePicker` kasih path ke lokasi asli (misal Downloads
/// folder). Kalau user hapus file source → path jadi invalid.
///
/// Dengan copy ke app docs, file survived:
/// - User delete source file
/// - App restart
/// - OS cache clear
///
/// File akan di-delete kalau user uninstall app (expected behavior).
class FileStorageService {
  FileStorageService._();

  /// Subfolder dalam app docs dir buat simpan dokumen SKT.
  static const _sktDocsFolder = 'skt_dokumen';

  /// Copy file dari [sourcePath] ke app's document directory.
  ///
  /// File name akan di-unique dengan timestamp prefix biar gak collision:
  /// "1712345678_KTP_Jenoardi.pdf"
  ///
  /// Returns path baru ke file yang udah di-copy.
  ///
  /// Throws kalau source file gak ada atau copy gagal.
  static Future<String> copyToAppDocs({
    required String sourcePath,
    required String fileName,
  }) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException(
        'File sumber tidak ditemukan',
        sourcePath,
      );
    }

    // Dapetin app docs dir
    final appDocsDir = await getApplicationDocumentsDirectory();
    final sktDir = Directory('${appDocsDir.path}/$_sktDocsFolder');

    // Pastiin folder ada
    if (!await sktDir.exists()) {
      await sktDir.create(recursive: true);
    }

    // Generate unique filename: timestamp_originalName.pdf
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeFileName = _sanitizeFileName(fileName);
    final targetPath = '${sktDir.path}/${timestamp}_$safeFileName';

    // Copy file
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  /// Hapus file dari app docs dir (cleanup kalau user remove dokumen).
  /// Silent fail kalau file gak ada.
  static Future<void> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Silent — best-effort cleanup
    }
  }

  /// Sanitize filename: remove karakter illegal buat filesystem.
  static String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  /// Cek apakah file ada di disk.
  static Future<bool> exists(String path) async {
    return File(path).exists();
  }

  /// Cleanup semua file lama di skt_dokumen folder (misal file yang
  /// gak lagi di-reference oleh state mana pun).
  /// Dipake kalau app startup buat ganti ruang.
  ///
  /// [keepPaths] = list path yang mau di-keep (file yang masih di-refer).
  static Future<void> cleanupOrphanFiles(Set<String> keepPaths) async {
    try {
      final appDocsDir = await getApplicationDocumentsDirectory();
      final sktDir = Directory('${appDocsDir.path}/$_sktDocsFolder');
      if (!await sktDir.exists()) return;

      await for (final entity in sktDir.list()) {
        if (entity is File && !keepPaths.contains(entity.path)) {
          try {
            await entity.delete();
          } catch (_) {
            // best-effort
          }
        }
      }
    } catch (_) {
      // Silent
    }
  }
}
