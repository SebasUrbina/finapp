import 'package:flutter/material.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'package:finapp/features/budget/widgets/vertical_bar_progress.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

/// Modern category budget card with vertical progress bars
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
      symbol: r'$',
      decimalDigits: 0,
    );

    // Get category color
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

    final showCaution = data.percentage >= 75 && !data.isOverBudget;
    final showWarning = data.percentage >= 75;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Category Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.category.iconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Category Name
                Expanded(
                  child: Text(
                    data.category.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Caution Badge
                if (showCaution) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Caution',
                      style: TextStyle(
                        color: const Color(0xFF856404),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Percentage
                Text(
                  '${data.percentage.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: data.isOverBudget ? colors.error : categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Label and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${formatter.format(data.spent.value)} / ${formatter.format(data.limit.value)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Vertical Bar Progress
            VerticalBarProgress(
              percentage: data.percentage.clamp(0, 100),
              height: 60,
              color: data.isOverBudget ? colors.error : null,
            ),

            // Warning Message
            if (showWarning) ...[
              const SizedBox(height: 12),
              Text(
                data.isOverBudget
                    ? 'Budget limit exceeded'
                    : 'Approaching Budget limit',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
