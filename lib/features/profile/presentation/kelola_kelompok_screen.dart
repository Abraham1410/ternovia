import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/profile_provider.dart';

/// Model anggota kelompok (untuk section permintaan & anggota aktif).
class AnggotaItem {
  final String id;
  final String nama;
  final DateTime tanggal;

  const AnggotaItem({
    required this.id,
    required this.nama,
    required this.tanggal,
  });
}

/// Provider dummy untuk permintaan bergabung
final permintaanBergabungProvider =
    StateProvider<List<AnggotaItem>>((ref) {
  return [
    AnggotaItem(
      id: 'req_1',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
    AnggotaItem(
      id: 'req_2',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
    AnggotaItem(
      id: 'req_3',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
  ];
});

/// Provider dummy untuk anggota aktif
final anggotaAktifProvider = StateProvider<List<AnggotaItem>>((ref) {
  return [
    AnggotaItem(
      id: 'akt_1',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
    AnggotaItem(
      id: 'akt_2',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
    AnggotaItem(
      id: 'akt_3',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
    AnggotaItem(
      id: 'akt_4',
      nama: 'Budi Doremi',
      tanggal: DateTime(2026, 6, 24),
    ),
  ];
});

class KelolaKelompokScreen extends ConsumerWidget {
  const KelolaKelompokScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final permintaan = ref.watch(permintaanBergabungProvider);
    final aktif = ref.watch(anggotaAktifProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Kelola Kelompok Ternak',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoKelompokCard(profile: profile),
                  const SizedBox(height: AppSpacing.md),
                  _PermintaanSection(
                    items: permintaan,
                    onTerima: (id) => _handleTerima(ref, id),
                    onTolak: (id) => _handleTolak(ref, id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AnggotaAktifSection(
                    items: aktif,
                    onDetail: (item) => _showAnggotaDetail(context, item),
                    onDelete: (id) =>
                        _handleDelete(context, ref, id),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTerima(WidgetRef ref, String id) {
    // Pindah dari permintaan → anggota aktif
    final permintaan = ref.read(permintaanBergabungProvider);
    final item = permintaan.firstWhere((a) => a.id == id);

    ref.read(permintaanBergabungProvider.notifier).state =
        permintaan.where((a) => a.id != id).toList();

    final aktif = ref.read(anggotaAktifProvider);
    ref.read(anggotaAktifProvider.notifier).state = [
      ...aktif,
      AnggotaItem(
        id: 'akt_${DateTime.now().millisecondsSinceEpoch}',
        nama: item.nama,
        tanggal: DateTime.now(),
      ),
    ];
  }

  void _handleTolak(WidgetRef ref, String id) {
    final permintaan = ref.read(permintaanBergabungProvider);
    ref.read(permintaanBergabungProvider.notifier).state =
        permintaan.where((a) => a.id != id).toList();
  }

  void _handleDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Text('Hapus Anggota?', style: AppTypography.headingMedium),
          ],
        ),
        content: Text(
          'Anggota akan dikeluarkan dari kelompok. Aksi ini tidak bisa dibatalkan.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final aktif = ref.read(anggotaAktifProvider);
              ref.read(anggotaAktifProvider.notifier).state =
                  aktif.where((a) => a.id != id).toList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anggota berhasil dihapus'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'Hapus',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnggotaDetail(BuildContext context, AnggotaItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detail anggota: ${item.nama}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _InfoKelompokCard extends StatelessWidget {
  final UserProfile profile;

  const _InfoKelompokCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.namaKelompok,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Dusun Suko, Desa Sukolilo, Jombang, Jawa Timur',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Kelompok ternak aktif yang berfokus pada pengembangan sapi '
            'perah dan peningkatan produksi berkelanjutan',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Informasi Kelompok',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            label: 'Nama Kelompok',
            value: 'Sukses Makmur',
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Alamat Lengkap',
            value:
                'Dusun Suko, Desa Sukolilo, Jombang, Jawa Timur',
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Tahun Berdiri',
            value: '2019',
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Ketua Kelompok',
            value: profile.nama,
          ),
          const SizedBox(height: AppSpacing.md),
          // Button "Lihat Detail Kelompok"
          Center(
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Detail kelompok — coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.creamMuted.withValues(alpha: 0.6),
                    borderRadius:
                        BorderRadius.circular(AppRadius.button),
                  ),
                  child: Text(
                    'Lihat Detail Kelompok',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDarker,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          ': ',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textDarker,
            fontSize: 12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _PermintaanSection extends StatelessWidget {
  final List<AnggotaItem> items;
  final void Function(String id) onTerima;
  final void Function(String id) onTolak;

  const _PermintaanSection({
    required this.items,
    required this.onTerima,
    required this.onTolak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permintaan Bergabung (${items.length})',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            items.isEmpty
                ? 'Belum ada permintaan bergabung.'
                : 'Ada anggota yang ingin bergabung ke kelompok anda.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(items.length, (i) {
              final item = items[i];
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  _PermintaanRow(
                    item: item,
                    onTerima: () => onTerima(item.id),
                    onTolak: () => onTolak(item.id),
                  ),
                  if (!isLast)
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs),
                      color: AppColors.divider,
                    ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _PermintaanRow extends StatelessWidget {
  final AnggotaItem item;
  final VoidCallback onTerima;
  final VoidCallback onTolak;

  const _PermintaanRow({
    required this.item,
    required this.onTerima,
    required this.onTolak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AvatarCircle(nama: item.nama),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 13, color: AppColors.textDarker),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      item.nama,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(item.tanggal),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        // Button column: Terima + Tolak
        Column(
          children: [
            _ActionButton(
              label: 'Terima',
              icon: Icons.check_circle_outline,
              background: AppColors.success,
              foreground: AppColors.white,
              onTap: onTerima,
            ),
            const SizedBox(height: 4),
            _ActionButton(
              label: 'Tolak',
              icon: Icons.cancel_outlined,
              background: AppColors.white,
              foreground: AppColors.error,
              outlined: true,
              onTap: onTolak,
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _AnggotaAktifSection extends StatelessWidget {
  final List<AnggotaItem> items;
  final void Function(AnggotaItem item) onDetail;
  final void Function(String id) onDelete;

  const _AnggotaAktifSection({
    required this.items,
    required this.onDetail,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anggota Aktif (${items.length})',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Daftar anggota yang saat ini aktif di kelompok ternak.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(items.length, (i) {
            final item = items[i];
            final isLast = i == items.length - 1;
            return Column(
              children: [
                _AnggotaRow(
                  item: item,
                  onDetail: () => onDetail(item),
                  onDelete: () => onDelete(item.id),
                ),
                if (!isLast)
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs),
                    color: AppColors.divider,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _AnggotaRow extends StatelessWidget {
  final AnggotaItem item;
  final VoidCallback onDetail;
  final VoidCallback onDelete;

  const _AnggotaRow({
    required this.item,
    required this.onDetail,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AvatarCircle(nama: item.nama),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 13, color: AppColors.textDarker),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      item.nama,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(item.tanggal),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        _ActionButton(
          label: 'Detail',
          icon: Icons.settings,
          background: AppColors.primary,
          foreground: AppColors.cream,
          onTap: onDetail,
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _AvatarCircle extends StatelessWidget {
  final String nama;

  const _AvatarCircle({required this.nama});

  @override
  Widget build(BuildContext context) {
    // Placeholder avatar emoji
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        '👨‍🌾',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: outlined
                ? Border.all(color: foreground, width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
