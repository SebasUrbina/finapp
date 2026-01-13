import 'package:flutter/material.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'package:finapp/features/budget/widgets/profit_indicator.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

/// Card para mostrar presupuesto de una categoría
class CategoryBudgetCard extends StatelessWidget {
  final CategoryBudgetData data;
  final VoidCallback onTap;

  const CategoryBudgetCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final categoryColors = theme.extension<CategoryColors>();
    final formatter = NumberFormat.currency(
      locale: 'es_CL',
      symbol: '\$',
      decimalDigits: 0,
    );

    // Obtener color de categoría
    Color categoryColor = colors.primary;
    if (categoryColors != null) {
      switch (data.category.id) {
        case 'c_health':
          categoryColor = categoryColors.health;
        case 'c_transport':
          categoryColor = categoryColors.transport;
        case 'c_supermarket':
        case 'c_eating_out':
          categoryColor = categoryColors.food;
        case 'c_entertainment':
          categoryColor = categoryColors.entertainment;
        case 'c_utilities':
          categoryColor = categoryColors.utilities;
        default:
          categoryColor = categoryColors.other;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Ícono, nombre y profit
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    data.category.icon,
                    color: categoryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.category.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${formatter.format(data.spent.value)} de ${formatter.format(data.limit.value)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ProfitIndicator(data: data, showPercentage: false),
              ],
            ),
            const SizedBox(height: 16),

            // Barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (data.percentage / 100).clamp(0, 1),
                    minHeight: 8,
                    backgroundColor: colors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      data.isOverBudget ? colors.error : categoryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data.percentage.toStringAsFixed(0)}% usado',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (data.isOverBudget)
                      Text(
                        'Sobregasto',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
