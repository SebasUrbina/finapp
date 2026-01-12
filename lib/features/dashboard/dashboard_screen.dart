import 'package:finapp/features/dashboard/providers/dashboard_provider.dart';
import 'package:finapp/features/dashboard/widgets/dark_mode_switcher.dart';
import 'package:finapp/features/dashboard/widgets/transaction_list_item.dart';
import 'package:finapp/features/dashboard/widgets/category_expense_item.dart';
import 'package:finapp/features/dashboard/widgets/financial_summary_card.dart';
import 'package:finapp/features/dashboard/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = ref.watch(dashboardProvider.notifier);
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Row with switch to modo oscuro)
              Row(
                children: [
                  Text('Hello,', style: theme.textTheme.headlineLarge),
                  const Spacer(),
                  ThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 16),

              // Financial Summary Card with integrated period toggle
              FinancialSummaryCard(
                controller: controller,
                selectedPeriod: state.period,
                onPeriodChanged: controller.setPeriod,
              ),
              const SizedBox(height: 32),

              // Recent Transactions
              _buildSectionHeader(context, 'Recent transactions'),
              const SizedBox(height: 16),
              _buildRecentTransactions(context, controller),
              const SizedBox(height: 32),

              // Expenses by Category
              _buildSectionHeader(context, 'Expenses by category'),
              const SizedBox(height: 16),
              _buildExpensesByCategory(context, controller),
              const SizedBox(height: 32),

              // Accounts
              _buildSectionHeader(context, 'Your accounts'),
              const SizedBox(height: 16),
              _buildAccounts(controller),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  // Recent Transactions Section
  Widget _buildRecentTransactions(BuildContext context, dynamic controller) {
    final colors = Theme.of(context).colorScheme;
    final recentTransactions = controller.recentTransactions;

    if (recentTransactions.isEmpty) {
      return _buildEmptyState(context, 'No transactions in this period');
    }

    return Container(
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
        children: (recentTransactions as List).asMap().entries.map<Widget>((
          entry,
        ) {
          final index = entry.key;
          final transaction = entry.value;
          final category = controller.getCategoryById(transaction.categoryId);
          final account = controller.getAccountById(transaction.accountId);
          final isLast = index == recentTransactions.length - 1;

          return Column(
            children: [
              TransactionListItem(
                transaction: transaction,
                category: category,
                account: account,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colors.outlineVariant,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpensesByCategory(BuildContext context, dynamic controller) {
    final colors = Theme.of(context).colorScheme;
    final expensesByCategory = controller.expensesByCategory;

    if (expensesByCategory.isEmpty) {
      return _buildEmptyState(context, 'No expenses in this period');
    }

    final totalExpenses = controller.totalExpenses.cents;

    return Container(
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
        children: (expensesByCategory as Map).entries
            .toList()
            .asMap()
            .entries
            .map<Widget>((entry) {
              final index = entry.key;
              final mapEntry = entry.value;
              final percentage = totalExpenses > 0
                  ? (mapEntry.value.cents / totalExpenses * 100)
                  : 0.0;
              final isLast = index == expensesByCategory.length - 1;

              return Column(
                children: [
                  CategoryExpenseItem(
                    category: mapEntry.key,
                    amount: mapEntry.value,
                    percentage: percentage,
                  ),
                  if (!isLast) const SizedBox(height: 12),
                ],
              );
            })
            .toList(),
      ),
    );
  }

  Widget _buildAccounts(dynamic controller) {
    final accounts = controller.state.accounts;

    return Column(
      children: (accounts as List).map<Widget>((account) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AccountCard(account: account),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
