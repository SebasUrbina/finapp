import 'package:finapp/features/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'package:finapp/features/budget/widgets/budget_summary_card.dart';
import 'package:finapp/features/budget/widgets/category_budget_card.dart';
import 'package:finapp/features/budget/widgets/budget_adjustment_modal.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:intl/intl.dart';

/// Vista principal de presupuesto
class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = ref.watch(budgetControllerProvider.notifier);
    final state = ref.watch(budgetControllerProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Presupuesto', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 16),

                    // Period selector
                    _buildPeriodSelector(context, controller, state),
                    const SizedBox(height: 16),

                    // Date navigator
                    _buildDateNavigator(context, controller, state),
                    const SizedBox(height: 24),

                    // Summary card
                    BudgetSummaryCard(controller: controller),
                    const SizedBox(height: 24),

                    // Section header
                    Text(
                      'Presupuestos por Categoría',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Budget list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: _buildBudgetList(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(
    BuildContext context,
    BudgetController controller,
    BudgetState state,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(
              context,
              'Mensual',
              state.selectedPeriod == BudgetPeriod.monthly,
              () => controller.setPeriod(BudgetPeriod.monthly),
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Anual',
              state.selectedPeriod == BudgetPeriod.yearly,
              () => controller.setPeriod(BudgetPeriod.yearly),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateNavigator(
    BuildContext context,
    BudgetController controller,
    BudgetState state,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final formatter = state.selectedPeriod == BudgetPeriod.monthly
        ? DateFormat('MMMM yyyy', 'es_ES')
        : DateFormat('yyyy');

    return Row(
      children: [
        IconButton(
          onPressed: controller.navigateToPreviousPeriod,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainerHighest,
          ),
        ),
        Expanded(
          child: Text(
            formatter.format(state.selectedDate),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: controller.navigateToNextPeriod,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetList(BuildContext context, BudgetController controller) {
    final categoryBudgets = controller.categoryBudgets;

    if (categoryBudgets.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(context));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final data = categoryBudgets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CategoryBudgetCard(
            data: data,
            onTap: () => _showAdjustmentModal(context, data, controller),
          ),
        );
      }, childCount: categoryBudgets.length),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: colors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay presupuestos configurados',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Configura presupuestos para controlar tus gastos',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAdjustmentModal(
    BuildContext context,
    CategoryBudgetData data,
    BudgetController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BudgetAdjustmentModal(data: data, controller: controller),
    );
  }
}
