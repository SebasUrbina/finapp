import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_controller.g.dart';

@riverpod
class BudgetController extends _$BudgetController {
  @override
  FutureOr<BudgetState> build() async {
    final budgets = await ref.watch(budgetsProvider.future);
    final categories = await ref.watch(categoriesProvider.future);
    final transactions = await ref.watch(transactionsProvider.future);
    final tags = await ref.watch(tagsProvider.future);

    return BudgetState(
      budgets: budgets,
      categories: categories,
      transactions: transactions,
      tags: tags,
      selectedDate: DateTime.now(),
    );
  }

  void setDate(DateTime date) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedDate: date));
  }

  void setTag(String? tagId) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedTagId: () => tagId));
  }

  void toggleTag(String? tagId) {
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (currentState.selectedTagId == tagId) {
      state = AsyncData(currentState.copyWith(selectedTagId: () => null));
    } else {
      state = AsyncData(currentState.copyWith(selectedTagId: () => tagId));
    }
  }

  void previousMonth() {
    if (!state.hasValue) return;
    final currentDate = state.value!.selectedDate;
    setDate(DateTime(currentDate.year, currentDate.month - 1));
  }

  void nextMonth() {
    if (!state.hasValue) return;
    final currentDate = state.value!.selectedDate;
    setDate(DateTime(currentDate.year, currentDate.month + 1));
  }

  Future<void> addBudget(String categoryId, double limitValue) async {
    final newBudget = Budget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      target: CategoryBudgetTarget(categoryId),
      limit: Money(limitValue),
      period: BudgetPeriod.monthly,
    );

    // Optimistic update
    if (state.hasValue) {
      final currentBudgets = state.value!.budgets;
      state = AsyncData(
        state.value!.copyWith(budgets: [...currentBudgets, newBudget]),
      );
    }

    // Call repository (assuming functionality exists or this was local only in the original code)
    // The original code only updated state. Assuming provider is synced with repo elsewhere or this is local state for now.
    // If budgetsProvider is a stream from database, we should add to database.
    // However, original code just updated state.budgets.
    // But budgetsProvider is watched in build().
    // If I update local state, it might be overwritten by next stream update if not saved to DB.
    // For now, I will keep the behavior of modifying the state, but ideally this should call a repository.
    // Since I don't see a budget repository method call in the original code, I will stick to state update but acknowledge this might be transient if using a stream.
    // Actually, check `financeRepositoryProvider` usage in other controllers.
    // `QuickEntryController` calls `ref.read(financeRepositoryProvider).addTransaction`.
    // So I should probably check if there is `addBudget`.
    // But I will stick to original logic: just update state.
    // Wait, if I update `state`, and `state` comes from `build()` which watches `budgetsProvider`,
    // my manual update will be overwritten if `budgetsProvider` emits new value.
    // But for now let's just update the local state to match original behavior.
  }

  // Actually, looking at original code:
  // state = state.copyWith(budgets: [...state.budgets, newBudget]);
  // Use `ref.read(budgetsProvider.notifier)` if it's a notifier?
  // But `budgetsProvider` is likely a StreamProvider or FutureProvider given `ref.watch(budgetsProvider)`.
  // If it's a stream, we should add to the source.
  // The user didn't ask to fix this logic, just the type errors.

  // Getter logic moved to methods/getters on the class

  List<CategoryBudgetData> get categoryBudgets {
    if (!state.hasValue) return [];
    final currentState = state.value!;
    final List<CategoryBudgetData> result = [];

    // Filter categories by tag if selected
    final filteredCategories = currentState.selectedTagId == null
        ? currentState.categories
        : currentState.categories
              .where((c) => c.tagIds.contains(currentState.selectedTagId))
              .toList();

    for (final budget in currentState.budgets) {
      if (budget.target is CategoryBudgetTarget) {
        final categoryId = (budget.target as CategoryBudgetTarget).categoryId;

        // Only include if category is in filtered list
        if (!filteredCategories.any((c) => c.id == categoryId)) continue;

        // Find category safely
        final category = currentState.categories.firstWhere(
          (c) => c.id == categoryId,
          orElse: () => Category(
            id: categoryId,
            name: 'Unknown',
            icon: CategoryIcon.home,
          ),
        );

        final spentValue = _calculateSpent(
          categoryId,
          currentState.selectedDate,
        );

        final spent = Money(spentValue);
        final percentage = budget.limit.value > 0
            ? (spent.value / budget.limit.value)
            : 0.0;

        result.add(
          CategoryBudgetData(
            budgetId: budget.id,
            category: category,
            limit: budget.limit,
            spent: spent,
            percentage: percentage,
          ),
        );
      }
    }

    return result;
  }

  List<Category> get availableCategories {
    if (!state.hasValue) return [];
    final currentState = state.value!;
    final existingCategoryIds = currentState.budgets
        .where((b) => b.target is CategoryBudgetTarget)
        .map((b) => (b.target as CategoryBudgetTarget).categoryId)
        .toSet();

    return currentState.categories
        .where((c) => !existingCategoryIds.contains(c.id))
        .toList();
  }

  double _calculateSpent(String categoryId, DateTime date) {
    if (!state.hasValue) return 0.0;
    return state.value!.transactions
        .where(
          (t) =>
              t.categoryId == categoryId &&
              t.type == TransactionType.expense &&
              t.date.year == date.year &&
              t.date.month == date.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount.value);
  }

  double get totalBudgetLimit {
    if (!state.hasValue) return 0.0;
    final categoryIds = categoryBudgets.map((b) => b.category.id).toSet();
    return state.value!.budgets
        .where(
          (b) =>
              b.target is CategoryBudgetTarget &&
              categoryIds.contains(
                (b.target as CategoryBudgetTarget).categoryId,
              ),
        )
        .fold(0.0, (sum, b) => sum + b.limit.value);
  }

  double get totalSpent {
    if (!state.hasValue) return 0.0;
    final categoryIds = categoryBudgets.map((b) => b.category.id).toSet();
    return state.value!.transactions
        .where(
          (t) =>
              categoryIds.contains(t.categoryId) &&
              t.type == TransactionType.expense &&
              t.date.year == state.value!.selectedDate.year &&
              t.date.month == state.value!.selectedDate.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount.value);
  }

  double get remainingDailyBudget {
    final remaining = totalBudgetLimit - totalSpent;
    if (remaining <= 0) return 0;
    if (!state.hasValue) return 0;

    final now = DateTime.now();
    final selectedDate = state.value!.selectedDate;
    final isCurrentMonth =
        selectedDate.month == now.month && selectedDate.year == now.year;

    int daysRemaining;
    if (isCurrentMonth) {
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      daysRemaining = lastDay - now.day + 1;
    } else {
      daysRemaining = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        0,
      ).day;
    }

    return remaining / daysRemaining;
  }

  List<CategoryDistributionData> get categoryDistribution {
    final budgets = categoryBudgets;
    final total = totalSpent;
    if (total == 0) return [];

    return budgets
        .where((b) => b.spent.value > 0)
        .map(
          (b) => CategoryDistributionData(
            category: b.category,
            amount: b.spent.value,
            percentage: b.spent.value / total,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }

  List<double> get historicalCompliance {
    if (!state.hasValue) return [];
    final List<double> history = [];
    final now = state.value!.selectedDate;

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      double periodSpent = 0;
      double periodLimit = 0;

      for (final budget in state.value!.budgets) {
        if (budget.target is CategoryBudgetTarget) {
          final categoryId = (budget.target as CategoryBudgetTarget).categoryId;
          periodLimit += budget.limit.value;
          periodSpent += _calculateSpent(categoryId, date);
        }
      }

      if (periodLimit > 0) {
        history.add((periodSpent / periodLimit).clamp(0.0, 1.2));
      } else {
        history.add(0.0);
      }
    }
    return history;
  }

  List<String> get historicalMonthLabels {
    if (!state.hasValue) return [];
    final List<String> labels = [];
    final now = state.value!.selectedDate;
    final monthNames = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      labels.add(monthNames[date.month - 1]);
    }
    return labels;
  }

  int get daysRemainingInMonth {
    if (!state.hasValue) return 0;
    final now = DateTime.now();
    final selectedDate = state.value!.selectedDate;
    final isCurrentMonth =
        selectedDate.month == now.month && selectedDate.year == now.year;

    if (isCurrentMonth) {
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      return lastDay - now.day + 1;
    } else {
      return DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    }
  }

  double get projectedMonthEndSpent {
    if (!state.hasValue) return 0;
    final now = DateTime.now();
    final selectedDate = state.value!.selectedDate;
    final isCurrentMonth =
        selectedDate.month == now.month && selectedDate.year == now.year;

    if (!isCurrentMonth || now.day == 0) return totalSpent;

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailyRate = totalSpent / now.day;
    return dailyRate * daysInMonth;
  }

  List<BudgetTip> get smartBudgetTips {
    final List<BudgetTip> tips = [];
    final budgets = categoryBudgets;

    // Check for categories over budget
    final overBudget = budgets.where((b) => b.percentage > 1.0).toList();
    for (final b in overBudget.take(2)) {
      tips.add(
        BudgetTip(
          type: BudgetTipType.danger,
          title: '${b.category.name} excedido',
          description:
              'Has superado tu presupuesto por ${((b.percentage - 1) * 100).toStringAsFixed(0)}%.',
          iconType: BudgetIconType.warning,
          categoryName: b.category.name,
        ),
      );
    }

    // Check for categories near limit (80-100%)
    final nearLimit = budgets
        .where((b) => b.percentage > 0.8 && b.percentage <= 1.0)
        .toList();
    for (final b in nearLimit.take(2)) {
      tips.add(
        BudgetTip(
          type: BudgetTipType.warning,
          title: '${b.category.name} cerca del límite',
          description:
              'Has usado ${(b.percentage * 100).toStringAsFixed(0)}% de tu presupuesto.',
          iconType: BudgetIconType.alert,
          categoryName: b.category.name,
        ),
      );
    }

    // Check for well-managed categories
    final wellManaged = budgets
        .where((b) => b.percentage > 0 && b.percentage < 0.5)
        .toList();
    if (wellManaged.isNotEmpty && tips.length < 3) {
      tips.add(
        BudgetTip(
          type: BudgetTipType.success,
          title: '¡Buen control!',
          description:
              '${wellManaged.length} categoría(s) están por debajo del 50% de uso.',
          iconType: BudgetIconType.checkCircle,
        ),
      );
    }

    // Projection warning
    if (projectedMonthEndSpent > totalBudgetLimit && totalBudgetLimit > 0) {
      final projectedOverage = projectedMonthEndSpent - totalBudgetLimit;
      tips.add(
        BudgetTip(
          type: BudgetTipType.info,
          title: 'Proyección de excedente',
          description:
              'A este ritmo podrías exceder tu presupuesto por ${projectedOverage.toStringAsFixed(0)} a fin de mes.',
          iconType: BudgetIconType.trendUp,
        ),
      );
    }

    // All under control
    if (tips.isEmpty && budgets.isNotEmpty) {
      tips.add(
        BudgetTip(
          type: BudgetTipType.success,
          title: '¡Todo bajo control!',
          description: 'Todos tus presupuestos están en buen estado.',
          iconType: BudgetIconType.celebration,
        ),
      );
    }

    return tips.take(4).toList();
  }

  void updateBudget(String budgetId, double newLimit) {
    if (!state.hasValue) return;
    final updatedBudgets = state.value!.budgets.map((b) {
      if (b.id == budgetId) {
        return Budget(
          id: b.id,
          target: b.target,
          limit: Money(newLimit),
          period: b.period,
        );
      }
      return b;
    }).toList();

    state = AsyncData(state.value!.copyWith(budgets: updatedBudgets));
  }

  void updateBudgetByCategory(String categoryId, double newLimit) {
    if (!state.hasValue) return;
    final budgetIndex = state.value!.budgets.indexWhere(
      (b) =>
          b.target is CategoryBudgetTarget &&
          (b.target as CategoryBudgetTarget).categoryId == categoryId,
    );

    if (budgetIndex != -1) {
      updateBudget(state.value!.budgets[budgetIndex].id, newLimit);
    }
  }

  void deleteBudget(String budgetId) {
    if (!state.hasValue) return;
    final updatedBudgets = state.value!.budgets
        .where((b) => b.id != budgetId)
        .toList();
    state = AsyncData(state.value!.copyWith(budgets: updatedBudgets));
  }
}

class CategoryDistributionData {
  final Category category;
  final double amount;
  final double percentage;

  CategoryDistributionData({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}
