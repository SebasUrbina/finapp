import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class SavingsRateCard extends ConsumerWidget {
  const SavingsRateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final savingsRate = ref.watch(dashboardSavingsRateProvider);
    final goal = ref.watch(dashboardSavingsGoalProvider);
    final isPositive = savingsRate >= 0;
    final reachedGoal = savingsRate >= goal;
    const accent = Color(0xFF2196F3);

    return MetricCard(
      accent: accent,
      onTap: () => _showGoalSlider(context, goal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Header ────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Ahorro',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.tune_rounded,
                size: 12,
                color: colors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),

          // ── Compact gauge ─────────────────────────────────────────
          SizedBox(
            width: 96,
            height: 96,
            child: CustomPaint(
              painter: _SavingsGaugePainter(
                percentage: savingsRate.clamp(-100, 100),
                goalPercentage: goal.clamp(0, 100),
                isPositive: isPositive,
                colors: colors,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${savingsRate.abs().toInt()}%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        fontSize: 26,
                        color: isPositive
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF6B6B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'META: ${goal.toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Action footer ──────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    value: goal > 0 ? (savingsRate / goal).clamp(0.0, 1.0) : 0,
                    minHeight: 3,
                    backgroundColor: colors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      reachedGoal ? const Color(0xFF4CAF50) : accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                reachedGoal ? '¡META LOGRADA!' : 'TOCA PARA AJUSTAR',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGoalSlider(BuildContext context, double current) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _GoalSliderSheet(initialGoal: current),
    );
  }
}

// ── Bottom sheet with slider ───────────────────────────────────────────────
class _GoalSliderSheet extends ConsumerStatefulWidget {
  const _GoalSliderSheet({required this.initialGoal});
  final double initialGoal;

  @override
  ConsumerState<_GoalSliderSheet> createState() => _GoalSliderSheetState();
}

class _GoalSliderSheetState extends ConsumerState<_GoalSliderSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialGoal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    const accent = Color(0xFF2196F3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Meta de Ahorro',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¿Qué porcentaje de tus ingresos quieres ahorrar?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${_value.toStringAsFixed(0)}%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accent,
              thumbColor: accent,
              overlayColor: accent.withValues(alpha: 0.1),
              inactiveTrackColor: accent.withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: _value,
              min: 1,
              max: 100,
              divisions: 99,
              onChanged: (v) => setState(() => _value = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [10, 20, 30, 50].map((pct) {
              final active = _value.round() == pct;
              return ChoiceChip(
                label: Text('$pct%'),
                selected: active,
                selectedColor: accent.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: active ? accent : colors.onSurface,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                onSelected: (_) => setState(() => _value = pct.toDouble()),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(dashboardSavingsGoalProvider.notifier).setGoal(_value);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Guardar meta'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gauge painter ──────────────────────────────────────────────────────────
class _SavingsGaugePainter extends CustomPainter {
  final double percentage;
  final double goalPercentage;
  final bool isPositive;
  final ColorScheme colors;

  const _SavingsGaugePainter({
    required this.percentage,
    required this.goalPercentage,
    required this.isPositive,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 10.0;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors.surfaceContainerHighest,
    );

    // Progress arc
    final progressSweep = (percentage.abs() / 100) * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      progressSweep.clamp(0, sweepAngle),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: isPositive
              ? [const Color(0xFF4CAF50), const Color(0xFF81C784)]
              : [const Color(0xFFFF6B6B), const Color(0xFFFFB74D)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // Goal tick
    final goalAngle = startAngle + (goalPercentage / 100) * sweepAngle;
    const tickLen = 4.0;
    final r = radius - strokeWidth / 2;
    canvas.drawLine(
      Offset(
        center.dx + (r - tickLen) * math.cos(goalAngle),
        center.dy + (r - tickLen) * math.sin(goalAngle),
      ),
      Offset(
        center.dx + (r + tickLen) * math.cos(goalAngle),
        center.dy + (r + tickLen) * math.sin(goalAngle),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF2196F3).withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _SavingsGaugePainter old) =>
      old.percentage != percentage || old.goalPercentage != goalPercentage;
}
