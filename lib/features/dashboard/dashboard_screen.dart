import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/features/dashboard/widgets/transaction_list_item.dart';
import 'package:finapp/features/dashboard/widgets/category_expense_list.dart';
import 'package:finapp/features/dashboard/widgets/category_settings_modal/category_settings_modal.dart';
import 'package:finapp/features/dashboard/widgets/account_card_stack.dart';
import 'package:finapp/features/dashboard/widgets/transaction_search_modal.dart';
import 'package:finapp/features/dashboard/widgets/section_header.dart';
import 'package:finapp/features/dashboard/widgets/dark_mode_switcher.dart';
import 'package:finapp/features/transaction_edit/transaction_edit_sheet.dart';
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
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: Text('No hay transacciones recientes')),
      );
    }

    final controller = ref.watch(dashboardControllerProvider.notifier);
    final theme = Theme.of(context);
    final items = transactions.take(5).toList();

    return Column(
      children: items.map((transaction) {
        final category = controller.getCategoryById(transaction.categoryId);
        final account = controller.getAccountById(transaction.accountId);

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

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.watch(dashboardControllerProvider.notifier);

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.surface]
                : [
                    const Color(0xFFD9C7F7).withValues(alpha: 0.3),
                    theme.colorScheme.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings_outlined,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => _showCategorySettings(context, state),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fri, 15 Jan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        shape: BoxShape.circle,
                      ),
                      child: ThemeToggleButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Account Card Stack
                AccountCardStack(
                  controller: controller,
                  accounts: state.accounts,
                  selectedAccountId: state.selectedAccountId,
                  selectedPeriod: state.period,
                  onAccountChanged: controller.setSelectedAccount,
                  onPeriodChanged: controller.setPeriod,
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Transacciones recientes',
                  actionLabel: 'Ver todo',
                  onActionTap: () => _showTransactionSearch(context, state),
                ),
                const SizedBox(height: 12),
                RecentTransactionsList(
                  transactions: controller.filteredTransactions,
                  onTransactionTap: (tx) => _showTransactionEdit(context, tx),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Gastos por categoría',
                  actionLabel: 'Ver todo',
                  onActionTap: () {},
                ),
                const SizedBox(height: 12),
                CategoryExpenseList(
                  expenses: controller.expensesByCategory,
                  totalExpenses: controller.totalExpenses,
                  limit: 4,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Category Settings Modal
  void _showCategorySettings(BuildContext context, DashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategorySettingsModal(),
    );
  }

  // Transaction Search Modal
  void _showTransactionSearch(BuildContext context, DashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionSearchModal(
        transactions: state.transactions,
        categories: state.categories,
        accounts: state.accounts,
      ),
    );
  }

  // Transaction Edit Modal
  void _showTransactionEdit(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionEditSheet(transaction: transaction),
    );
  }
}
