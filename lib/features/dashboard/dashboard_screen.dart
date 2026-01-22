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
import 'package:finapp/features/dashboard/widgets/financial_metrics_row.dart';
import 'package:finapp/features/transaction_edit/transaction_edit_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  String _formatDate(DateTime date) {
    final dayFormat = DateFormat('EEEE, d', 'es');
    final monthFormat = DateFormat('MMMM', 'es');
    final day = dayFormat.format(date);
    final month = monthFormat.format(date);
    return '${day[0].toUpperCase()}${day.substring(1)} ${month[0].toUpperCase()}${month.substring(1)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.watch(dashboardControllerProvider.notifier);

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [colors.surface, colors.surface]
                : [
                    const Color(0xFFD9C7F7).withValues(alpha: 0.3),
                    colors.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Top Row with buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.settings_outlined,
                                color: colors.onSurface,
                              ),
                              onPressed: () =>
                                  _showCategorySettings(context, state),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ThemeToggleButton(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Title and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, ',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatDate(DateTime.now()),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Account Card Stack
              SliverToBoxAdapter(
                child: AccountCardStack(
                  controller: controller,
                  accounts: state.accounts,
                  selectedAccountId: state.selectedAccountId,
                  selectedPeriod: state.period,
                  onAccountChanged: controller.setSelectedAccount,
                  onPeriodChanged: controller.setPeriod,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Financial Metrics Row
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: const SliverToBoxAdapter(child: FinancialMetricsRow()),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Recent Transactions Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Transacciones recientes',
                    actionLabel: 'Ver todo',
                    onActionTap: () => _showTransactionSearch(context, state),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: RecentTransactionsList(
                    transactions: controller.filteredTransactions,
                    onTransactionTap: (tx) => _showTransactionEdit(context, tx),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Category Expenses Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Gastos por categoría',
                    actionLabel: 'Ver todo',
                    onActionTap: () {},
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: CategoryExpenseList(
                    expenses: controller.expensesByCategory,
                    totalExpenses: controller.totalExpenses,
                    limit: 4,
                  ),
                ),
              ),

              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySettings(BuildContext context, DashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategorySettingsModal(),
    );
  }

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

  void _showTransactionEdit(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionEditSheet(transaction: transaction),
    );
  }
}
