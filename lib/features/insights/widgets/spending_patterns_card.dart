import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/insights/insights_state.dart';
import 'package:flutter/material.dart';

class SpendingPatternsCard extends StatelessWidget {
  final List<WeekdaySpendingData> weekdayData;
  final int highestDay;

  const SpendingPatternsCard({
    super.key,
    required this.weekdayData,
    required this.highestDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (weekdayData.isEmpty || weekdayData.every((d) => d.averageAmount == 0)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patrones Semanales',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.calendar_view_week_rounded,
                size: 20,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getInsightText(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          // Heatmap
          Row(
            children: weekdayData.map((data) {
              final isHighest = data.weekday == highestDay;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              _getHeatColor(data.intensity, colors, false),
                              _getHeatColor(data.intensity, colors, true),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: isHighest
                              ? Border.all(color: colors.primary, width: 2)
                              : null,
                          boxShadow: isHighest
                              ? [
                                  BoxShadow(
                                    color: colors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: data.averageAmount > 0
                              ? Text(
                                  _formatCompact(data.averageAmount),
                                  style: TextStyle(
                                    color: data.intensity > 0.5
                                        ? Colors.white
                                        : colors.onSurfaceVariant,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.label,
                        style: TextStyle(
                          color: isHighest
                              ? colors.primary
                              : colors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: isHighest
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: _getHeatColor(0.2, colors, true),
                label: 'Bajo',
              ),
              const SizedBox(width: 16),
              _LegendItem(
                color: _getHeatColor(0.5, colors, true),
                label: 'Medio',
              ),
              const SizedBox(width: 16),
              _LegendItem(
                color: _getHeatColor(1.0, colors, true),
                label: 'Alto',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInsightText() {
    final dayLabels = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final highData = weekdayData.firstWhere(
      (d) => d.weekday == highestDay,
      orElse: () => weekdayData.first,
    );
    return 'Mayor gasto promedio: ${dayLabels[highestDay - 1]} (${highData.averageAmount.toCurrency()})';
  }

  String _formatCompact(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Color _getHeatColor(double intensity, ColorScheme colors, bool isTop) {
    if (intensity <= 0.01) {
      return colors.surfaceContainerHighest;
    }

    // Gradient from light to primary color
    final baseColor = colors.primary;

    if (isTop) {
      return Color.lerp(
        baseColor.withValues(alpha: 0.1),
        baseColor,
        intensity,
      )!;
    } else {
      return Color.lerp(
        baseColor.withValues(alpha: 0.05),
        baseColor.withValues(alpha: 0.6),
        intensity,
      )!;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
