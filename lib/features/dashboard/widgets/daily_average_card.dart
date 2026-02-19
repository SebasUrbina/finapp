import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/domain/models/dashboard_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyAverageCard extends ConsumerWidget {
  const DailyAverageCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final averageDaily = ref.watch(dashboardAverageDailySpendingProvider);
    final trendData = ref.watch(dashboardDailySpendingTrendProvider);
    final period = ref.watch(dashboardPeriodProvider);
    const accent = Color(0xFFFF9800);

    final periodLabel = switch (period) {
      PeriodFilter.year => 'este año',
      PeriodFilter.month => 'este mes',
      PeriodFilter.week => 'esta sem.',
    };

    return MetricCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Header ───────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 11,
                color: accent.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Prom. diario · $periodLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          // ── Amount ────────────────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                averageDaily.toCurrency(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'total gastado',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 8,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          // ── Chart Area ────────────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: CustomPaint(
                  painter: _MiniLineChartPainter(
                    data: trendData,
                    color: accent,
                  ),
                  size: const Size(double.infinity, 60),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tendencia últimos días',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  final List<DailySpendingData> data;
  final Color color;

  _MiniLineChartPainter({required this.data, required this.color});

  /// Maps a data index to its (x, y) canvas position.
  Offset _pointAt(int i, double stepX, double maxAmount, Size size) {
    final x = i * stepX;
    final normalizedValue = data[i].amount.value / maxAmount;
    final y = size.height - (normalizedValue * size.height);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final maxAmount = data
        .map((d) => d.amount.value)
        .reduce((a, b) => a > b ? a : b);
    if (maxAmount == 0) return;

    final stepX = size.width / (data.length - 1);

    // Build a Catmull-Rom spline that passes through every data point.
    // For each pair of consecutive points P[i]→P[i+1], the cubic bezier
    // control points are:
    //   cp1 = P[i]  + (P[i+1] - P[i-1]) / 6
    //   cp2 = P[i+1]- (P[i+2] - P[i])   / 6
    final curvePath = Path();
    final fillPath = Path();

    final points = [
      for (int i = 0; i < data.length; i++) _pointAt(i, stepX, maxAmount, size),
    ];

    curvePath.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, size.height);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      // Neighbouring points clamped to valid indices for edge segments.
      final prev = points[(i - 1).clamp(0, points.length - 1)];
      final curr = points[i];
      final next = points[i + 1];
      final after = points[(i + 2).clamp(0, points.length - 1)];

      final cp1 = Offset(
        curr.dx + (next.dx - prev.dx) / 6,
        curr.dy + (next.dy - prev.dy) / 6,
      );
      final cp2 = Offset(
        next.dx - (after.dx - curr.dx) / 6,
        next.dy - (after.dy - curr.dy) / 6,
      );

      curvePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, next.dx, next.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, next.dx, next.dy);
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    // Filled area under the curve.
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Smooth curve stroke.
    canvas.drawPath(
      curvePath,
      Paint()
        ..color = color.withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Highlight only the last (most recent) data point.
    final last = points.last;
    canvas.drawCircle(
      last,
      3,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter old) =>
      old.data != data || old.color != color;
}
