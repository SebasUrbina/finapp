import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardController extends StateNotifier<DashboardState> {
  final FinanceRepository _repository;

  DashboardController(this._repository)
    : super(
        DashboardState(
          period: PeriodFilter.month,
          selectedDate: DateTime.now(),
          transactions: _repository.getTransactions(),
          accounts: _repository.getAccounts(),
          categories: _repository.getCategories(),
          tags: _repository.getTags(),
        ),
      );

  // ========== State Management Methods ==========

  void setPeriod(PeriodFilter period) {
    state = state.copyWith(period: period);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setSelectedAccount(String? accountId) {
    state = state.copyWith(selectedAccountId: accountId);
  }

  /// Refresh data from repository
  void refresh() {
    state = state.copyWith(
      transactions: _repository.getTransactions(),
      accounts: _repository.getAccounts(),
      categories: _repository.getCategories(),
      tags: _repository.getTags(),
    );
  }

  Future<void> addCategory(Category category) async {
    await _repository.addCategory(category);
    refresh();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
    refresh();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _repository.deleteCategory(categoryId);
    refresh();
  }

  // ========== Computed Getters (Derived Values) ==========

  /// Get the date range for the current period
  DateTimeRange get periodRange {
    final date = state.selectedDate;

    switch (state.period) {
      case PeriodFilter.year:
        // Get the year
        final firstDay = DateTime(date.year, 1, 1);
        final lastDay = DateTime(date.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);

      case PeriodFilter.week:
        // Get the week (Monday to Sunday)
        final weekday = date.weekday;
        final monday = date.subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(monday.year, monday.month, monday.day),
          end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
        );

      case PeriodFilter.month:
        // Get the month
        final firstDay = DateTime(date.year, date.month, 1);
        final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);
    }
  }

  /// Get transactions filtered by current period and selected account
  List<Transaction> get filteredTransactions {
    final range = periodRange;
    var filtered = state.transactions.where((t) {
      return t.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(range.end.add(const Duration(seconds: 1)));
    });

    // Filter by account if one is selected
    if (state.selectedAccountId != null) {
      filtered = filtered.where((t) => t.accountId == state.selectedAccountId);
    }

    return filtered.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  /// Total income for the period
  Money get totalIncome {
    final incomeTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.income,
    );

    if (incomeTransactions.isEmpty) return const Money(0);

    return incomeTransactions.map((t) => t.amount).reduce((a, b) => a + b);
  }

  /// Total expenses for the period
  Money get totalExpenses {
    final expenseTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.expense,
    );

    if (expenseTransactions.isEmpty) return const Money(0);

    return expenseTransactions.map((t) => t.amount).reduce((a, b) => a + b);
  }

  /// Balance (income - expenses)
  Money get balance {
    return Money(totalIncome.value - totalExpenses.value);
  }

  /// Get the date range for the previous period
  DateTimeRange get previousPeriodRange {
    final date = state.selectedDate;

    switch (state.period) {
      case PeriodFilter.year:
        final prevYear = DateTime(date.year - 1, 1, 1);
        final lastDay = DateTime(date.year - 1, 12, 31, 23, 59, 59);
        return DateTimeRange(start: prevYear, end: lastDay);

      case PeriodFilter.week:
        final currentWeekday = date.weekday;
        final currentMonday = date.subtract(Duration(days: currentWeekday - 1));
        final prevMonday = currentMonday.subtract(const Duration(days: 7));
        final prevSunday = prevMonday.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(prevMonday.year, prevMonday.month, prevMonday.day),
          end: DateTime(
            prevSunday.year,
            prevSunday.month,
            prevSunday.day,
            23,
            59,
            59,
          ),
        );

      case PeriodFilter.month:
        final prevMonth = DateTime(date.year, date.month - 1, 1);
        final lastDay = DateTime(date.year, date.month, 0, 23, 59, 59);
        return DateTimeRange(start: prevMonth, end: lastDay);
    }
  }

  /// Get transactions for the previous period
  List<Transaction> get _previousPeriodTransactions {
    final range = previousPeriodRange;
    return state.transactions.where((t) {
      return t.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(range.end.add(const Duration(seconds: 1)));
    }).toList();
  }

  /// Total expenses for the previous period
  Money get previousTotalExpenses {
    final prevTransactions = _previousPeriodTransactions.where(
      (t) => t.type == TransactionType.expense,
    );

    if (prevTransactions.isEmpty) return const Money(0);

    return prevTransactions.map((t) => t.amount).reduce((a, b) => a + b);
  }

  /// Percentage change in spending compared to previous period
  double get spendingChangePercentage {
    if (previousTotalExpenses.value == 0) return 0;
    return ((totalExpenses.value - previousTotalExpenses.value) /
            previousTotalExpenses.value) *
        100;
  }

  /// Savings rate as percentage (can be negative if spending > income)
  double get currentSavingsRate {
    if (totalIncome.value == 0) return 0;
    final savings = totalIncome.value - totalExpenses.value;
    return (savings / totalIncome.value * 100);
  }

  /// Transaction count for the period
  int get transactionCount {
    return filteredTransactions.length;
  }

  /// Average daily spending
  Money get averageDailySpending {
    final range = periodRange;
    final days = range.end.difference(range.start).inDays + 1;

    if (days == 0) return const Money(0);

    return Money(totalExpenses.value / days);
  }

  /// Expenses grouped by category
  Map<Category, Money> get expensesByCategory {
    final expenseTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.expense && t.categoryId != null,
    );

    final Map<Category, Money> result = {};

    for (final transaction in expenseTransactions) {
      final category = state.categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Sin categoría',
          icon: CategoryIcon.home,
        ),
      );

      if (result.containsKey(category)) {
        result[category] = result[category]! + transaction.amount;
      } else {
        result[category] = transaction.amount;
      }
    }

    // Sort by amount (highest first)
    final sortedEntries = result.entries.toList()
      ..sort((a, b) => b.value.value.compareTo(a.value.value));

    return Map.fromEntries(sortedEntries);
  }

  /// Get top expense category filtered by tag
  /// If tagId is null, returns overall top category
  MapEntry<Category, Money>? getTopCategoryByTag(String? tagId) {
    var transactions = filteredTransactions.where(
      (t) => t.type == TransactionType.expense && t.categoryId != null,
    );

    // Filter by tag if specified
    if (tagId != null) {
      transactions = transactions.where((t) {
        final category = getCategoryById(t.categoryId);
        return category?.tagIds.contains(tagId) ?? false;
      });
    }

    if (transactions.isEmpty) return null;

    final Map<Category, Money> categoryTotals = {};

    for (final transaction in transactions) {
      final category = state.categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Sin categoría',
          icon: CategoryIcon.home,
        ),
      );

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] =
            categoryTotals[category]! + transaction.amount;
      } else {
        categoryTotals[category] = transaction.amount;
      }
    }

    if (categoryTotals.isEmpty) return null;

    // Return category with highest spending
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.value.compareTo(a.value.value));

    return sortedEntries.first;
  }

  /// Get daily spending trend for the last 30 days
  List<DailySpendingData> getDailySpendingTrend({int days = 30}) {
    final now = DateTime.now();
    final List<DailySpendingData> trend = [];

    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final dayTransactions = filteredTransactions.where((t) {
        return t.type == TransactionType.expense &&
            t.date.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(dayEnd.add(const Duration(seconds: 1)));
      });

      final dayExpenses = dayTransactions.isEmpty
          ? const Money(0)
          : dayTransactions.map((t) => t.amount).reduce((a, b) => a + b);

      trend.add(
        DailySpendingData(date: dayStart, amount: dayExpenses, isToday: i == 0),
      );
    }

    return trend;
  }

  /// Recent transactions (last 7)
  List<Transaction> get recentTransactions {
    return filteredTransactions.take(7).toList();
  }

  /// Get category by ID
  Category? getCategoryById(String? categoryId) {
    if (categoryId == null) return null;
    try {
      return state.categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get account by ID
  Account? getAccountById(String accountId) {
    try {
      return state.accounts.firstWhere((a) => a.id == accountId);
    } catch (e) {
      return null;
    }
  }

  /// Savings rate as percentage (0-100)
  double get savingsRate {
    if (totalIncome.value == 0) return 0;
    final savings = totalIncome.value - totalExpenses.value;
    return (savings / totalIncome.value * 100).clamp(0, 100);
  }

  /// Get spending trend data for the last 6 periods
  List<SpendingTrendData> get spendingTrend {
    final List<SpendingTrendData> trend = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime periodStart;
      DateTime periodEnd;
      String label;

      if (state.period == PeriodFilter.week) {
        // Calculate week range
        final targetDate = now.subtract(Duration(days: i * 7));
        final weekday = targetDate.weekday;
        final monday = targetDate.subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));

        periodStart = DateTime(monday.year, monday.month, monday.day);
        periodEnd = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

        // Label: "W1", "W2", etc. or date range for current week
        if (i == 0) {
          label = 'Esta';
        } else {
          label = 'S-$i';
        }
      } else {
        // Calculate month range
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

        // Label: "Ene", "Feb", etc.
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
      }

      // Calculate expenses for this period
      final periodTransactions = state.transactions.where((t) {
        final isInPeriod =
            t.type == TransactionType.expense &&
            t.date.isAfter(periodStart.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(periodEnd.add(const Duration(seconds: 1)));

        if (!isInPeriod) return false;

        // Respect account filter if selected
        if (state.selectedAccountId != null) {
          return t.accountId == state.selectedAccountId;
        }

        return true;
      });

      final periodExpenses = periodTransactions.isEmpty
          ? const Money(0)
          : periodTransactions.map((t) => t.amount).reduce((a, b) => a + b);

      trend.add(
        SpendingTrendData(
          label: label,
          amount: periodExpenses,
          isCurrentPeriod: i == 0,
        ),
      );
    }

    return trend;
  }

  /// Get quick insights for the dashboard (max 2)
  List<DashboardInsight> get quickInsights {
    final List<DashboardInsight> insights = [];

    // Insight 1: Spending change
    if (spendingChangePercentage.abs() > 5) {
      if (spendingChangePercentage > 0) {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.warning,
            message:
                'Tus gastos subieron ${spendingChangePercentage.abs().toStringAsFixed(0)}% respecto al período anterior.',
            icon: Icons.trending_up_rounded,
          ),
        );
      } else {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.success,
            message:
                '¡Bien! Redujiste tus gastos un ${spendingChangePercentage.abs().toStringAsFixed(0)}% vs el período anterior.',
            icon: Icons.trending_down_rounded,
          ),
        );
      }
    }

    // Insight 2: Top category
    if (expensesByCategory.isNotEmpty) {
      final topCategory = expensesByCategory.entries.first;
      final topPercentage = totalExpenses.value > 0
          ? (topCategory.value.value / totalExpenses.value * 100)
          : 0.0;

      if (topPercentage > 30) {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.info,
            message:
                '${topCategory.key.name} representa el ${topPercentage.toStringAsFixed(0)}% de tus gastos.',
            icon: topCategory.key.iconData,
          ),
        );
      }
    }

    // Insight 3: Savings rate
    if (insights.length < 2 && currentSavingsRate != 0) {
      if (currentSavingsRate > 15) {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.success,
            message:
                'Estás ahorrando el ${currentSavingsRate.toStringAsFixed(0)}% de tus ingresos. ¡Excelente!',
            icon: Icons.savings_rounded,
          ),
        );
      } else if (currentSavingsRate < 0) {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.warning,
            message:
                'Estás gastando más de lo que ingresas. Revisa tu presupuesto.',
            icon: Icons.warning_rounded,
          ),
        );
      }
    }

    return insights.take(2).toList();
  }
}

/// Data class for spending trend
class SpendingTrendData {
  final String label;
  final Money amount;
  final bool isCurrentPeriod;

  SpendingTrendData({
    required this.label,
    required this.amount,
    required this.isCurrentPeriod,
  });
}

/// Insight type for dashboard
enum DashboardInsightType { success, warning, info }

/// Data class for dashboard insights
class DashboardInsight {
  final DashboardInsightType type;
  final String message;
  final IconData icon;

  const DashboardInsight({
    required this.type,
    required this.message,
    required this.icon,
  });
}

/// Data class for daily spending trend
class DailySpendingData {
  final DateTime date;
  final Money amount;
  final bool isToday;

  DailySpendingData({
    required this.date,
    required this.amount,
    required this.isToday,
  });
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final repo = ref.watch(financeRepositoryProvider);
      return DashboardController(repo);
    });
