import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/features/dashboard/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransactionsList extends ConsumerWidget {
  final List<Transaction> transactions;
  final void Function(Transaction)? onTransactionTap;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Sin transacciones en este período',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Agrega tu primer gasto o ingreso',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    // We can access global state here or expect `transactions` to be hydrated.
    // Ideally, we shouldn't query the full state again just for category/account lookup if performance is key,
    // but for now it's fine.
    final stateAsync = ref.watch(dashboardStateProvider);
    final theme = Theme.of(context);
    final items = transactions.take(5).toList();

    return Column(
      children: items.map((transaction) {
        final category = stateAsync.valueOrNull?.getCategoryById(
          transaction.categoryId,
        );
        final account = stateAsync.valueOrNull?.getAccountById(
          transaction.accountId,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
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
            child: TransactionListItem(
              transaction: transaction,
              category: category,
              account: account,
              onTap: onTransactionTap != null
                  ? () => onTransactionTap!(transaction)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
