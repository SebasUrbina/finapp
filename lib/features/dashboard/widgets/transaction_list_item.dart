import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final Account? account;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.category,
    this.account,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;
    final categoryColor = category?.getColor(context) ?? colors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category?.iconData ??
                    (isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.help_outline),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary Text: Description (if exists), otherwise Category Name
                  Text(
                    (transaction.description != null &&
                            transaction.description!.isNotEmpty)
                        ? transaction.description!
                        : (category?.name ??
                              (isIncome ? 'Ingreso' : 'Sin categoría')),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Subtitles: Category (if description was primary) and Date
                  Row(
                    children: [
                      if (transaction.description != null &&
                          transaction.description!.isNotEmpty) ...[
                        Text(
                          category?.name ??
                              (isIncome ? 'Ingreso' : 'Sin categoría'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                          ),
                        ),
                      ],
                      Text(
                        DateFormat('d MMM').format(transaction.date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Amount
            Text(
              '${isExpense ? '-' : '+'}${transaction.amount.toCurrency()}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isExpense ? colors.error : colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
