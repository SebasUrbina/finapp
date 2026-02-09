import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/features/dashboard/widgets/recent_transactions_list.dart';
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
    final asyncState = ref.watch(dashboardStateProvider);
    final periodFilter = ref.watch(dashboardPeriodProvider);

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
          child: asyncState.when(
            skipLoadingOnReload: true, // Prevents flicker during refresh
            data: (state) => CustomScrollView(
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
                                  Icons.category,
                                  color: colors.onSurface,
                                ),
                                onPressed: () =>
                                    _showCategorySettings(context, state),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
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
                                    _formatDate(
                                      DateTime.now(),
                                    ), // Or use state.period.start
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
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
                      ],
                    ),
                  ),
                ),

                // Account Card Stack
                SliverToBoxAdapter(
                  child: AccountCardStack(
                    accounts: state.accounts,
                    selectedAccountId: state.selectedAccountId,
                    selectedPeriod: periodFilter,
                    onAccountChanged: (id) => ref
                        .read(dashboardSelectedAccountProvider.notifier)
                        .setSelectedAccount(id),
                    onPeriodChanged: (period) => ref
                        .read(dashboardPeriodProvider.notifier)
                        .setFilter(period),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Financial Metrics Row
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: const SliverToBoxAdapter(
                    child: FinancialMetricsRow(),
                  ),
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
                      transactions: ref.watch(
                        dashboardFilteredTransactionsProvider,
                      ),
                      onTransactionTap: (tx) =>
                          _showTransactionEdit(context, tx),
                    ),
                  ),
                ),
                // Bottom padding for FAB
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            error: (err, stack) => Center(child: Text('Error: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
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
