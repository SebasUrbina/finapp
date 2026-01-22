import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';

/// Minimal spending summary card for dashboard
class DashboardSummaryCard extends StatelessWidget {
  final Money totalExpenses;
  final Money previousExpenses;
  final double changePercentage;

  const DashboardSummaryCard({
    super.key,
    required this.totalExpenses,
    required this.previousExpenses,
    required this.changePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isPositiveChange = changePercentage > 0;
    final hasChange = changePercentage.abs() > 0.5;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.15 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.trending_down_rounded,
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gastos del período',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  totalExpenses.toCurrency(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Change indicator
          if (hasChange)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    (isPositiveChange ? colors.error : const Color(0xFF4CAF50))
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositiveChange
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 14,
                    color: isPositiveChange
                        ? colors.error
                        : const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${changePercentage.abs().toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: isPositiveChange
                          ? colors.error
                          : const Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
