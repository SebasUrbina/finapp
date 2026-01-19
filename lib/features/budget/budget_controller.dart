import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/budget/budget_state.dart';

/// Modelo de datos para presupuesto de categoría con cálculos
class CategoryBudgetData {
  final Budget budget;
  final Category category;
  final Money spent;
  final Money limit;
  final double percentage;
  final Money profit;
  final bool isOverBudget;

  CategoryBudgetData({
    required this.budget,
    required this.category,
    required this.spent,
    required this.limit,
    required this.percentage,
    required this.profit,
    required this.isOverBudget,
  });
}

/// Modelo de datos para histórico de presupuesto
class BudgetHistoryData {
  final String label;
  final Money budgeted;
  final Money spent;
  final bool isCurrentPeriod;

  BudgetHistoryData({
    required this.label,
    required this.budgeted,
    required this.spent,
    required this.isCurrentPeriod,
  });
}

class BudgetController extends AutoDisposeNotifier<BudgetState> {
  @override
  BudgetState build() {
    final budgets = ref.watch(budgetsProvider);
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);

    return BudgetState(
      budgets: budgets,
      categories: categories,
      transactions: transactions,
      selectedDate: DateTime.now(),
    );
  }

  // ========== State Management Methods ==========

  void setPeriod(BudgetPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void navigateToNextPeriod() {
    final current = state.selectedDate;
    DateTime next;

    if (state.selectedPeriod == BudgetPeriod.monthly) {
      next = DateTime(current.year, current.month + 1, 1);
    } else {
      next = DateTime(current.year + 1, 1, 1);
    }

    state = state.copyWith(selectedDate: next);
  }

  void navigateToPreviousPeriod() {
    final current = state.selectedDate;
    DateTime previous;

    if (state.selectedPeriod == BudgetPeriod.monthly) {
      previous = DateTime(current.year, current.month - 1, 1);
    } else {
      previous = DateTime(current.year - 1, 1, 1);
    }

    state = state.copyWith(selectedDate: previous);
  }

  Future<void> updateBudgetLimit(String budgetId, Money newLimit) async {
    // En producción, esto actualizaría el repositorio
    // Por ahora, solo actualizamos el estado local
    final updatedBudgets = state.budgets.map((b) {
      if (b.id == budgetId) {
        return Budget(
          id: b.id,
          target: b.target,
          limit: newLimit,
          period: b.period,
        );
      }
      return b;
    }).toList();

    state = state.copyWith(budgets: updatedBudgets);

    // Invalidar provider para refrescar
    ref.invalidate(budgetsProvider);
  }

  // ========== Computed Getters ==========

  /// Rango de fechas para el período seleccionado
  DateTimeRange get periodRange {
    final date = state.selectedDate;

    if (state.selectedPeriod == BudgetPeriod.monthly) {
      final firstDay = DateTime(date.year, date.month, 1);
      final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
      return DateTimeRange(start: firstDay, end: lastDay);
    } else {
      final firstDay = DateTime(date.year, 1, 1);
      final lastDay = DateTime(date.year, 12, 31, 23, 59, 59);
      return DateTimeRange(start: firstDay, end: lastDay);
    }
  }

  /// Presupuestos filtrados por período seleccionado
  List<Budget> get filteredBudgets {
    return state.budgets
        .where((b) => b.period == state.selectedPeriod)
        .toList();
  }

  /// Presupuestos de categoría con datos calculados
  List<CategoryBudgetData> get categoryBudgets {
    final List<CategoryBudgetData> result = [];

    for (final budget in filteredBudgets) {
      // Solo procesar presupuestos por categoría
      if (budget.target is! CategoryBudgetTarget) continue;

      final categoryId = (budget.target as CategoryBudgetTarget).categoryId;
      final category = state.categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Desconocido',
          icon: CategoryIcon.home,
        ),
      );

      final spent = _getSpentForBudget(budget);
      final percentage = budget.limit.value > 0
          ? (spent.value / budget.limit.value * 100).toDouble().clamp(
              0.0,
              200.0,
            )
          : 0.0;
      final profit = Money(budget.limit.value - spent.value);
      final isOverBudget = spent.value > budget.limit.value;

      result.add(
        CategoryBudgetData(
          budget: budget,
          category: category,
          spent: spent,
          limit: budget.limit,
          percentage: percentage,
          profit: profit,
          isOverBudget: isOverBudget,
        ),
      );
    }

    // Ordenar por porcentaje de uso (mayor primero)
    result.sort((a, b) => b.percentage.compareTo(a.percentage));

    return result;
  }

  /// Total presupuestado
  Money get totalBudgeted {
    if (filteredBudgets.isEmpty) return const Money(0);
    return filteredBudgets
        .map((b) => b.limit)
        .reduce((a, b) => Money(a.value + b.value));
  }

  /// Total gastado
  Money get totalSpent {
    final total = categoryBudgets.fold<double>(
      0,
      (sum, data) => sum + data.spent.value,
    );
    return Money(total);
  }

  /// Profit general
  Money get overallProfit {
    return Money(totalBudgeted.value - totalSpent.value);
  }

  /// Porcentaje de uso general
  double get overallPercentage {
    if (totalBudgeted.value == 0) return 0;
    return (totalSpent.value / totalBudgeted.value * 100).toDouble().clamp(
      0.0,
      200.0,
    );
  }

  /// Histórico de presupuesto (últimos 6 períodos)
  List<BudgetHistoryData> getBudgetHistory(Budget budget) {
    final List<BudgetHistoryData> history = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime periodStart;
      DateTime periodEnd;
      String label;

      if (state.selectedPeriod == BudgetPeriod.monthly) {
        final targetDate = DateTime(now.year, now.month - i, 1);
        periodStart = DateTime(targetDate.year, targetDate.month, 1);
        periodEnd = DateTime(
          targetDate.year,
          targetDate.month + 1,
          0,
          23,
          59,
          59,
        );

        if (i == 0) {
          label = 'Este';
        } else {
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
          label = monthNames[targetDate.month - 1];
        }
      } else {
        final targetDate = DateTime(now.year - i, 1, 1);
        periodStart = DateTime(targetDate.year, 1, 1);
        periodEnd = DateTime(targetDate.year, 12, 31, 23, 59, 59);
        label = targetDate.year.toString();
      }

      final spent = _getSpentForPeriod(budget, periodStart, periodEnd);

      history.add(
        BudgetHistoryData(
          label: label,
          budgeted: budget.limit,
          spent: spent,
          isCurrentPeriod: i == 0,
        ),
      );
    }

    return history;
  }

  // ========== Helper Methods ==========

  /// Calcular gasto para un presupuesto en el período actual
  Money _getSpentForBudget(Budget budget) {
    final range = periodRange;
    return _getSpentForPeriod(budget, range.start, range.end);
  }

  /// Calcular gasto para un presupuesto en un período específico
  Money _getSpentForPeriod(Budget budget, DateTime start, DateTime end) {
    List<Transaction> relevantTransactions = [];

    if (budget.target is CategoryBudgetTarget) {
      final categoryId = (budget.target as CategoryBudgetTarget).categoryId;
      relevantTransactions = state.transactions.where((t) {
        return t.type == TransactionType.expense &&
            t.categoryId == categoryId &&
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end.add(const Duration(seconds: 1)));
      }).toList();
    } else if (budget.target is TagBudgetTarget) {
      final tagId = (budget.target as TagBudgetTarget).tagId;
      relevantTransactions = state.transactions.where((t) {
        if (t.type != TransactionType.expense || t.categoryId == null) {
          return false;
        }

        final category = state.categories.firstWhere(
          (c) => c.id == t.categoryId,
          orElse: () =>
              const Category(id: '', name: '', icon: CategoryIcon.home),
        );

        return category.tagIds.contains(tagId) &&
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end.add(const Duration(seconds: 1)));
      }).toList();
    }

    if (relevantTransactions.isEmpty) return const Money(0);

    return relevantTransactions
        .map((t) => t.amount)
        .reduce((a, b) => Money(a.value + b.value));
  }
}

final budgetControllerProvider =
    NotifierProvider.autoDispose<BudgetController, BudgetState>(
      BudgetController.new,
    );
