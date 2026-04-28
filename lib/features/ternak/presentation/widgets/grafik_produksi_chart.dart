import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_size.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/produksi_provider.dart';

/// Bar chart responsive untuk grafik produksi (single-color per bar).
class GrafikProduksiChart extends StatelessWidget {
  final List<ProduksiPoint> data;

  const GrafikProduksiChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: CustomPaint(
        size: Size.infinite,
        painter: _ProduksiChartPainter(
          data: data,
          textStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: AppSize.fs10,
          ),
          labelStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.textDark,
            fontSize: AppSize.fs11,
          ),
        ),
      ),
    );
  }
}

class _ProduksiChartPainter extends CustomPainter {
  final List<ProduksiPoint> data;
  final TextStyle textStyle;
  final TextStyle labelStyle;

  static const _barColor = Color(0xFF7C9A6F);
  static const _yLabels = [10, 20, 30, 50];
  static const _yMax = 50.0;

  _ProduksiChartPainter({
    required this.data,
    required this.textStyle,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPadding = 28.w;
    final rightPadding = 4.w;
    final topPadding = 4.h;
    final bottomPadding = 24.h;

    final chartRect = Rect.fromLTRB(
      leftPadding,
      topPadding,
      size.width - rightPadding,
      size.height - bottomPadding,
    );

    // Grid lines + Y labels
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 0.5;

    for (final label in _yLabels) {
      final y = chartRect.bottom - (chartRect.height * (label / _yMax));
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      _drawText(canvas, '$label', Offset(4.w, y - 5.h), textStyle);
    }

    // Base line
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      Paint()
        ..color = AppColors.divider
        ..strokeWidth = 1,
    );

    // Bars
    final periodWidth = chartRect.width / data.length;
    final barWidth = periodWidth * 0.3;

    for (var i = 0; i < data.length; i++) {
      final p = data[i];
      final centerX = chartRect.left + periodWidth * (i + 0.5);
      final barX = centerX - barWidth / 2;
      final barHeight = chartRect.height * (p.liter / _yMax);

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          barX,
          chartRect.bottom - barHeight,
          barWidth,
          barHeight,
        ),
        topLeft: Radius.circular(3.r),
        topRight: Radius.circular(3.r),
      );
      canvas.drawRRect(rect, Paint()..color = _barColor);

      // X label
      _drawTextCentered(
        canvas,
        p.label,
        Offset(centerX, chartRect.bottom + 6.h),
        labelStyle,
      );
    }
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

  void _drawTextCentered(
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
    tp.paint(canvas, Offset(offset.dx - tp.width / 2, offset.dy));
  }

  @override
  bool shouldRepaint(_ProduksiChartPainter old) => old.data != data;
}
