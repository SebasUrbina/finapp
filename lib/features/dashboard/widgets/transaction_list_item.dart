import 'package:finapp/core/utils/date_utils.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
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
    final relativeDate = DateFormatUtils.formatRelativeDate(transaction.date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
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
                  // Category name
                  Text(
                    category?.name ?? (isIncome ? 'Ingreso' : 'Sin categoría'),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  if (transaction.description != null &&
                      transaction.description!.isNotEmpty)
                    Text(
                      transaction.description!,
                      style: TextStyle(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 4),

                  // Account and date
                  Row(
                    children: [
                      // Account name
                      if (account != null) ...[
                        Icon(
                          account!.icon ?? Icons.account_balance_wallet,
                          size: 12,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            account!.name,
                            style: TextStyle(
                              color: colors.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: colors.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],

                      // Relative date
                      Flexible(
                        child: Text(
                          relativeDate,
                          style: TextStyle(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
