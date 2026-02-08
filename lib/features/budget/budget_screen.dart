import 'package:finapp/features/budget/budget_controller.dart';
import 'package:finapp/features/budget/budget_state.dart';
import 'package:finapp/features/budget/widgets/budget_form_sheet.dart';
import 'package:finapp/features/budget/widgets/create_budget_sheet.dart';
import 'package:finapp/features/budget/widgets/budget_summary_card.dart';
import 'package:finapp/features/budget/widgets/category_budget_item.dart';
import 'package:finapp/features/budget/widgets/period_navigator.dart';
import 'package:finapp/features/budget/widgets/tag_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final asyncState = ref.watch(budgetControllerProvider);
    final controller = ref.read(budgetControllerProvider.notifier);
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
            skipLoadingOnReload: true, // Prevents flicker
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (state) {
              final categoryBudgets = controller.categoryBudgets;
              final totalSpent = controller.totalSpent;
              final totalLimit = controller.totalBudgetLimit;

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Presupuesto',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Controla tus gastos',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
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
                            child: IconButton(
                              icon: const Icon(Icons.add_rounded),
                              onPressed: () =>
                                  _showCreateBudget(context, controller),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Period Navigator
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: PeriodNavigator(
                          selectedDate: state.selectedDate,
                          onPrevious: controller.previousMonth,
                          onNext: controller.nextMonth,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Budget Summary Card (minimal)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: BudgetSummaryCard(
                        spent: totalSpent,
                        limit: totalLimit,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Filter and List Section Header
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detalle por Categoría',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.filter_list_rounded,
                            size: 20,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // Tag Filters
                  SliverToBoxAdapter(
                    child: TagFilterBar(
                      tags: state.tags,
                      selectedTagId: state.selectedTagId,
                      onTagSelected: controller.setTag,
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Category Budgets List
                  if (categoryBudgets.isEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 48,
                                color: colors.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Sin presupuestos',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Crea tu primer presupuesto para empezar a controlar tus gastos.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                onPressed: () =>
                                    _showCreateBudget(context, controller),
                                icon: const Icon(Icons.add_rounded),
                                label: const Text('Crear Presupuesto'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = categoryBudgets[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Dismissible(
                              key: Key(item.budgetId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: colors.errorContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: colors.onErrorContainer,
                                ),
                              ),
                              onDismissed: (direction) {
                                controller.deleteBudget(item.budgetId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Presupuesto de ${item.category.name} eliminado',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Deshacer',
                                      onPressed: () {
                                        controller.addBudget(
                                          item.category.id,
                                          item.limit.value,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () =>
                                    _showBudgetEdit(context, item, controller),
                                child: CategoryBudgetItem(
                                  budgetId: item.budgetId,
                                  category: item.category,
                                  limit: item.limit,
                                  spent: item.spent,
                                  percentage: item.percentage,
                                ),
                              ),
                            ),
                          );
                        }, childCount: categoryBudgets.length),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCreateBudget(BuildContext context, BudgetController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateBudgetSheet(
        availableCategories: controller.availableCategories,
        onSave: (categoryId, limit) {
          controller.addBudget(categoryId, limit);
        },
      ),
    );
  }

  void _showBudgetEdit(
    BuildContext context,
    CategoryBudgetData data,
    BudgetController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BudgetFormSheet(
        category: data.category,
        currentLimit: data.limit.value,
        onSave: (newLimit) {
          controller.updateBudgetByCategory(data.category.id, newLimit);
        },
        onDelete: () {
          controller.deleteBudget(data.budgetId);
        },
      ),
    );
  }
}
