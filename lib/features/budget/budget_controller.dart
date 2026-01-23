import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/budget/budget_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, BudgetState>((ref) {
      final budgets = ref.watch(budgetsProvider);
      final categories = ref.watch(categoriesProvider);
      final transactions = ref.watch(transactionsProvider);
      final tags = ref.watch(tagsProvider);

      return BudgetController(
        budgets: budgets,
        categories: categories,
        transactions: transactions,
        tags: tags,
      );
    });

class BudgetController extends StateNotifier<BudgetState> {
  BudgetController({
    required List<Budget> budgets,
    required List<Category> categories,
    required List<Transaction> transactions,
    required List<Tag> tags,
  }) : super(
         BudgetState(
           budgets: budgets,
           categories: categories,
           transactions: transactions,
           tags: tags,
           selectedDate: DateTime.now(),
         ),
       );

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTag(String? tagId) {
    state = state.copyWith(selectedTagId: () => tagId);
  }

  void toggleTag(String? tagId) {
    if (state.selectedTagId == tagId) {
      state = state.copyWith(selectedTagId: () => null);
    } else {
      state = state.copyWith(selectedTagId: () => tagId);
    }
  }

  void previousMonth() {
    setDate(DateTime(state.selectedDate.year, state.selectedDate.month - 1));
  }

  void nextMonth() {
    setDate(DateTime(state.selectedDate.year, state.selectedDate.month + 1));
  }

  void addBudget(String categoryId, double limitValue) {
    final newBudget = Budget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      target: CategoryBudgetTarget(categoryId),
      limit: Money(limitValue),
      period: BudgetPeriod.monthly,
    );

    state = state.copyWith(budgets: [...state.budgets, newBudget]);
  }

  List<CategoryBudgetData> get categoryBudgets {
    final List<CategoryBudgetData> result = [];

    // Filter categories by tag if selected
    final filteredCategories = state.selectedTagId == null
        ? state.categories
        : state.categories
              .where((c) => c.tagIds.contains(state.selectedTagId))
              .toList();

    for (final budget in state.budgets) {
      if (budget.target is CategoryBudgetTarget) {
        final categoryId = (budget.target as CategoryBudgetTarget).categoryId;

        // Only include if category is in filtered list
        if (!filteredCategories.any((c) => c.id == categoryId)) continue;

        final category = state.categories.firstWhere((c) => c.id == categoryId);

        final spentValue = _calculateSpent(categoryId, state.selectedDate);

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
    final existingCategoryIds = state.budgets
        .where((b) => b.target is CategoryBudgetTarget)
        .map((b) => (b.target as CategoryBudgetTarget).categoryId)
        .toSet();

    return state.categories
        .where((c) => !existingCategoryIds.contains(c.id))
        .toList();
  }

  double _calculateSpent(String categoryId, DateTime date) {
    return state.transactions
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
    final categoryIds = categoryBudgets.map((b) => b.category.id).toSet();
    return state.budgets
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
    final categoryIds = categoryBudgets.map((b) => b.category.id).toSet();
    return state.transactions
        .where(
          (t) =>
              categoryIds.contains(t.categoryId) &&
              t.type == TransactionType.expense &&
              t.date.year == state.selectedDate.year &&
              t.date.month == state.selectedDate.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount.value);
  }

  double get remainingDailyBudget {
    final remaining = totalBudgetLimit - totalSpent;
    if (remaining <= 0) return 0;

    final now = DateTime.now();
    final isCurrentMonth =
        state.selectedDate.month == now.month &&
        state.selectedDate.year == now.year;

    int daysRemaining;
    if (isCurrentMonth) {
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      daysRemaining = lastDay - now.day + 1;
    } else {
      daysRemaining = DateTime(
        state.selectedDate.year,
        state.selectedDate.month + 1,
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

  /// Returns compliance percentage (0.0 to 1.0) for the last 6 months
  List<double> get historicalCompliance {
    final List<double> history = [];
    final now = state.selectedDate;

    for (int i = 5; i >= 0; i--) {
      // Calculate date for i months ago
      final date = DateTime(now.year, now.month - i);
      double periodSpent = 0;
      double periodLimit = 0;

      for (final budget in state.budgets) {
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

  /// Returns month labels for the last 6 months
  List<String> get historicalMonthLabels {
    final List<String> labels = [];
    final now = state.selectedDate;
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

  /// Days remaining in the current month
  int get daysRemainingInMonth {
    final now = DateTime.now();
    final isCurrentMonth =
        state.selectedDate.month == now.month &&
        state.selectedDate.year == now.year;

    if (isCurrentMonth) {
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      return lastDay - now.day + 1;
    } else {
      return DateTime(
        state.selectedDate.year,
        state.selectedDate.month + 1,
        0,
      ).day;
    }
  }

  /// Projected spending at month's end based on current pace
  double get projectedMonthEndSpent {
    final now = DateTime.now();
    final isCurrentMonth =
        state.selectedDate.month == now.month &&
        state.selectedDate.year == now.year;

    if (!isCurrentMonth || now.day == 0) return totalSpent;

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailyRate = totalSpent / now.day;
    return dailyRate * daysInMonth;
  }

  /// Smart tips based on current budget status
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

  /// Update an existing budget limit
  void updateBudget(String budgetId, double newLimit) {
    final updatedBudgets = state.budgets.map((b) {
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

    state = state.copyWith(budgets: updatedBudgets);
  }

  /// Update a budget by category ID
  void updateBudgetByCategory(String categoryId, double newLimit) {
    final budgetIndex = state.budgets.indexWhere(
      (b) =>
          b.target is CategoryBudgetTarget &&
          (b.target as CategoryBudgetTarget).categoryId == categoryId,
    );

    if (budgetIndex != -1) {
      updateBudget(state.budgets[budgetIndex].id, newLimit);
    }
  }

  /// Delete a budget
  void deleteBudget(String budgetId) {
    final updatedBudgets = state.budgets
        .where((b) => b.id != budgetId)
        .toList();
    state = state.copyWith(budgets: updatedBudgets);
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
