import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryExpenseItem extends StatelessWidget {
  final Category category;
  final Money amount;
  final double percentage;

  const CategoryExpenseItem({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  Color _getCategoryColor(BuildContext context, String categoryId) {
    final categoryColors = Theme.of(context).extension<CategoryColors>()!;

    final colorMap = {
      'c_rent': categoryColors.entertainment,
      'c_supermarket': categoryColors.food,
      'c_common_expenses': categoryColors.transport,
      'c_transport': categoryColors.transport,
      'c_eating_out': categoryColors.food,
      'c_entertainment': categoryColors.entertainment,
      'c_health': categoryColors.health,
      'c_utilities': categoryColors.utilities,
    };

    return colorMap[categoryId] ?? Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
      locale: 'es_CL',
    );

    final categoryColor = _getCategoryColor(context, category.id);

    return Row(
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(category.icon, color: categoryColor, size: 20),
        ),
        const SizedBox(width: 12),

        // Category name and progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    currencyFormat.format(amount.value),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: colors.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
