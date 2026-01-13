import 'package:flutter/material.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'package:intl/intl.dart';

/// Widget reutilizable para mostrar indicador de profit/déficit
class ProfitIndicator extends StatelessWidget {
  final CategoryBudgetData data;
  final bool showPercentage;

  const ProfitIndicator({
    super.key,
    required this.data,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isProfit = !data.isOverBudget;
    final color = isProfit ? colors.tertiary : colors.error;
    final icon = isProfit ? Icons.trending_up : Icons.trending_down;
    final formatter = NumberFormat.currency(
      locale: 'es_CL',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            formatter.format(data.profit.value.abs()),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showPercentage) ...[
            const SizedBox(width: 4),
            Text(
              '(${data.percentage.toStringAsFixed(0)}%)',
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
