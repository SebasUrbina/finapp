import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class SpendingOverviewCard extends StatelessWidget {
  final double totalSpending;
  final double previousSpending;
  final double changePercentage;
  final double averageDaily;

  const SpendingOverviewCard({
    super.key,
    required this.totalSpending,
    required this.previousSpending,
    required this.changePercentage,
    required this.averageDaily,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isPositiveChange = changePercentage > 0;
    final hasChange = changePercentage.abs() > 0.5;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                'Total Gastado',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasChange) ...[
                      Icon(
                        isPositiveChange
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: isPositiveChange
                            ? const Color(0xFFFFB74D)
                            : const Color(0xFF81C784),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      hasChange
                          ? '${isPositiveChange ? '+' : ''}${changePercentage.toStringAsFixed(1)}%'
                          : 'Sin cambio',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            totalSpending.toCurrency(),
            style: theme.textTheme.headlineLarge?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    label: 'Período anterior',
                    value: previousSpending.toCurrency(),
                    color: colors.onPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colors.onPrimary.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Promedio diario',
                    value: averageDaily.toCurrency(),
                    color: colors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
