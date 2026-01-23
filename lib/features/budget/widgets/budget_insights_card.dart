import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'package:flutter/material.dart';

class BudgetInsightsCard extends StatelessWidget {
  final List<CategoryDistributionData> distribution;
  final double dailyBudget;
  final double totalRemaining;

  const BudgetInsightsCard({
    super.key,
    required this.distribution,
    required this.dailyBudget,
    required this.totalRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                'Distribución y Salud',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.insights_rounded,
                size: 20,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Distribution Bar
          if (distribution.isNotEmpty)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 12,
                    child: Row(
                      children: distribution.map((item) {
                        return Expanded(
                          flex: (item.percentage * 1000).toInt().clamp(1, 1000),
                          child: Container(
                            color: item.category.getColor(context),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Legend (Top 3)
                Row(
                  children: distribution.take(3).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: item.category.getColor(context),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.category.name,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Sin datos de gasto este mes'),
              ),
            ),

          const Divider(height: 32),

          // Useful Stats
          Row(
            children: [
              Expanded(
                child: _InsightTile(
                  label: 'Presupuesto Diario',
                  value: dailyBudget.toCurrency(),
                  icon: Icons.calendar_today_rounded,
                  color: colors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.outlineVariant.withValues(alpha: 0.5),
              ),
              Expanded(
                child: _InsightTile(
                  label: 'Total Disponible',
                  value: totalRemaining.toCurrency(),
                  icon: Icons.savings_rounded,
                  color: totalRemaining < 0 ? colors.error : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InsightTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
