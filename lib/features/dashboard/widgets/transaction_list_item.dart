import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final Account? account;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.category,
    this.account,
  });

  Color _getCategoryColor(BuildContext context, String? categoryId) {
    final categoryColors = Theme.of(context).extension<CategoryColors>()!;

    if (categoryId == null) return Theme.of(context).colorScheme.primary;

    // Assign colors based on category
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
    final colors = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
      locale: 'es_CL',
    );

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;
    final categoryColor = _getCategoryColor(context, transaction.categoryId);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category?.icon ??
                  (isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.help_outline),
              color: categoryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category?.name ?? (isIncome ? 'Income' : 'Uncategorized'),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.description ?? 'No description',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Amount
          Text(
            '${isExpense ? '-' : '+'}${currencyFormat.format(transaction.amount.value)}',
            style: TextStyle(
              color: isExpense ? colors.error : colors.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
