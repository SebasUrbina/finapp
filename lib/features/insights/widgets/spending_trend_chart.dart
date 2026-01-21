import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/insights/insights_state.dart';
import 'package:flutter/material.dart';

class SpendingTrendChart extends StatelessWidget {
  final List<SpendingTrendPoint> data;
  final double maxAmount;
  final double averageAmount;

  const SpendingTrendChart({
    super.key,
    required this.data,
    required this.maxAmount,
    required this.averageAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: Text('Sin datos disponibles')),
      );
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
                'Tendencia de Gastos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Prom: ${averageAmount.toCurrency()}',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _BarChart(
                  data: data,
                  maxAmount: maxAmount,
                  averageAmount: averageAmount,
                  width: constraints.maxWidth,
                  height: 180,
                  primaryColor: colors.primary,
                  surfaceColor: colors.surfaceContainerHighest,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<SpendingTrendPoint> data;
  final double maxAmount;
  final double averageAmount;
  final double width;
  final double height;
  final Color primaryColor;
  final Color surfaceColor;

  const _BarChart({
    required this.data,
    required this.maxAmount,
    required this.averageAmount,
    required this.width,
    required this.height,
    required this.primaryColor,
    required this.surfaceColor,
  });

  String _formatCompact(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else if (value == 0) {
      return '-';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final chartHeight = height - 44; // Espacio para labels y valores
    final normalizedMax = maxAmount > 0 ? maxAmount : 1;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Average line
              if (averageAmount > 0 && maxAmount > 0)
                Positioned(
                  top: chartHeight * (1 - averageAmount / normalizedMax),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              // Bars with values
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  final barHeight = maxAmount > 0
                      ? (point.amount / normalizedMax) * chartHeight
                      : 0.0;
                  final isHighest = point.amount == maxAmount && maxAmount > 0;
                  final hasValue = point.amount > 0;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 3,
                        right: index == data.length - 1 ? 0 : 3,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value label above bar
                          if (hasValue)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                _formatCompact(point.amount),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isHighest
                                      ? primaryColor
                                      : colors.onSurfaceVariant,
                                  fontSize: 9,
                                  fontWeight: isHighest
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 16),
                          // Bar
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300 + index * 50),
                            curve: Curves.easeOutCubic,
                            height: barHeight.clamp(4, chartHeight - 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isHighest
                                    ? [
                                        primaryColor,
                                        primaryColor.withValues(alpha: 0.7),
                                      ]
                                    : [
                                        primaryColor.withValues(alpha: 0.6),
                                        primaryColor.withValues(alpha: 0.3),
                                      ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              boxShadow: isHighest
                                  ? [
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Labels
        Row(
          children: data.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;
            final isHighest = point.amount == maxAmount && maxAmount > 0;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 3,
                  right: index == data.length - 1 ? 0 : 3,
                ),
                child: Text(
                  point.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isHighest
                        ? primaryColor
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: isHighest ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
