import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/kesehatan_provider.dart';

/// Custom bar chart untuk grafik kesehatan
/// 4 periode, masing-masing 3 bar (Suhu / Kasus Sakit / Mortalitas)
/// Scale 0-50, grid lines di 5, 10, 30, 50
///
/// [filter] menentukan bar mana yang ditampilkan. Bar yang tidak aktif
/// akan di-skip (tidak digambar). Default: [GrafikFilter.semua] (semua bar).
class GrafikKesehatanChart extends StatelessWidget {
  final List<GrafikKesehatanPoint> data;
  final GrafikFilter filter;

  const GrafikKesehatanChart({
    super.key,
    required this.data,
    this.filter = GrafikFilter.semua,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(data: data, filter: filter),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<GrafikKesehatanPoint> data;
  final GrafikFilter filter;

  _BarChartPainter({required this.data, required this.filter});

  static const _colorSuhu = Color(0xFF7C9A6F);
  static const _colorKasus = Color(0xFFE8B93C);
  static const _colorMortalitas = Color(0xFFC95B4D);

  static const _yLabels = [5, 10, 30, 50];
  static const _yMax = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 28.0;
    const rightPadding = 4.0;
    const topPadding = 4.0;
    const bottomPadding = 24.0;

    final chartRect = Rect.fromLTRB(
      leftPadding,
      topPadding,
      size.width - rightPadding,
      size.height - bottomPadding,
    );

    // Draw horizontal grid lines + Y labels
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 0.5;

    final textStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 9,
    );

    for (final label in _yLabels) {
      final y = chartRect.bottom -
          (chartRect.height * (label / _yMax));
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      _drawText(
        canvas,
        '$label',
        Offset(4, y - 5),
        textStyle,
      );
    }

    // Base line
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      Paint()
        ..color = AppColors.divider
        ..strokeWidth = 1,
    );

    // Draw bars — respect filter (skip bars yang gak aktif)
    final periodCount = data.length;
    final periodWidth = chartRect.width / periodCount;

    for (var i = 0; i < data.length; i++) {
      final p = data[i];
      final centerX = chartRect.left + periodWidth * (i + 0.5);

      if (filter == GrafikFilter.semua) {
        // Mode 3 bar — original layout
        const barsPerPeriod = 3;
        const barGap = 2.0;
        final barWidth = (periodWidth * 0.55 - barGap * (barsPerPeriod - 1)) /
            barsPerPeriod;
        final startX =
            centerX - (barWidth * barsPerPeriod + barGap * (barsPerPeriod - 1)) / 2;

        _drawBar(canvas, startX, chartRect, barWidth, p.suhuValue, _colorSuhu);
        _drawBar(canvas, startX + barWidth + barGap, chartRect, barWidth,
            p.kasusValue, _colorKasus);
        _drawBar(canvas, startX + (barWidth + barGap) * 2, chartRect, barWidth,
            p.mortalitasValue, _colorMortalitas);
      } else {
        // Mode single bar — centered, lebih lebar biar keliatan dominant
        final barWidth = periodWidth * 0.35;
        final startX = centerX - barWidth / 2;

        final (value, color) = switch (filter) {
          GrafikFilter.suhu => (p.suhuValue, _colorSuhu),
          GrafikFilter.kasus => (p.kasusValue, _colorKasus),
          GrafikFilter.mortalitas => (p.mortalitasValue, _colorMortalitas),
          GrafikFilter.semua => (0.0, _colorSuhu), // unreachable
        };
        _drawBar(canvas, startX, chartRect, barWidth, value, color);
      }

      // X label (selalu tampil)
      _drawText(
        canvas,
        '${p.periode}',
        Offset(centerX - 4, chartRect.bottom + 6),
        textStyle.copyWith(color: AppColors.textDark, fontSize: 11),
      );
    }
  }

  void _drawBar(Canvas canvas, double x, Rect chartRect, double width,
      double value, Color color) {
    final height = chartRect.height * (value / _yMax);
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(x, chartRect.bottom - height, width, height),
      topLeft: const Radius.circular(3),
      topRight: const Radius.circular(3),
    );
    canvas.drawRRect(rect, Paint()..color = color);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.data != data || old.filter != filter;
}
