import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/budget/budget_state.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class CategoryBudgetItem extends StatelessWidget {
  final String budgetId;
  final Category category;
  final Money limit;
  final Money spent;
  final double percentage;

  const CategoryBudgetItem({
    super.key,
    required this.budgetId,
    required this.category,
    required this.limit,
    required this.spent,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final categoryColor = category.getColor(context);

    final remainingValue = limit.value - spent.value;
    final isNegative = remainingValue < 0;

    // Use centralized status logic
    final status = CategoryBudgetData(
      budgetId: budgetId,
      category: category,
      limit: limit,
      spent: spent,
      percentage: percentage,
    ).status;

    final statusColor = switch (status) {
      BudgetStatus.healthy => Colors.green,
      BudgetStatus.warning => Colors.orange,
      BudgetStatus.danger => colors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.15 : 0.03,
            ),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Small Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(category.iconData, color: categoryColor, size: 16),
              ),
              const SizedBox(width: 12),

              // Name and Status Dot
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isNegative
                          ? 'Excedido por ${(spent.value - limit.value).toCurrency()}'
                          : '${remainingValue.toCurrency()} restantes',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isNegative
                            ? colors.error
                            : colors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              // Amounts
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    spent.value.toCurrency(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'de ${limit.value.toCurrency()}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Extremely slim progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: colors.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
