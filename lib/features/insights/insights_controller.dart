import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/insights/insights_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insights_controller.g.dart';

@riverpod
class InsightsController extends _$InsightsController {
  @override
  FutureOr<InsightsState> build() async {
    final transactions = await ref.watch(transactionsProvider.future);
    final categories = await ref.watch(categoriesProvider.future);
    final accounts = await ref.watch(accountsProvider.future);
    final tags = await ref.watch(tagsProvider.future);

    return InsightsState(
      period: InsightsPeriod.month,
      selectedDate: DateTime.now(),
      transactions: transactions,
      categories: categories,
      accounts: accounts,
      tags: tags,
    );
  }

  // ========== State Management ==========

  void setPeriod(InsightsPeriod period) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(period: period));
  }

  void setDate(DateTime date) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedDate: date));
  }

  void setTag(String? tagId) {
    if (!state.hasValue) return;
    if (tagId == null) {
      state = AsyncData(state.value!.copyWith(clearTagId: true));
    } else {
      state = AsyncData(state.value!.copyWith(selectedTagId: tagId));
    }
  }

  void nextPeriod() {
    if (!state.hasValue) return;
    final currentState = state.value!;
    final current = currentState.selectedDate;
    DateTime next;

    switch (currentState.period) {
      case InsightsPeriod.week:
        next = current.add(const Duration(days: 7));
      case InsightsPeriod.month:
        next = DateTime(current.year, current.month + 1, 1);
      case InsightsPeriod.quarter:
        next = DateTime(current.year, current.month + 3, 1);
      case InsightsPeriod.year:
        next = DateTime(current.year + 1, 1, 1);
    }

    // No permitir ir al futuro
    if (next.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      setDate(next);
    }
  }

  void previousPeriod() {
    if (!state.hasValue) return;
    final currentState = state.value!;
    final current = currentState.selectedDate;
    DateTime prev;

    switch (currentState.period) {
      case InsightsPeriod.week:
        prev = current.subtract(const Duration(days: 7));
      case InsightsPeriod.month:
        prev = DateTime(current.year, current.month - 1, 1);
      case InsightsPeriod.quarter:
        prev = DateTime(current.year, current.month - 3, 1);
      case InsightsPeriod.year:
        prev = DateTime(current.year - 1, 1, 1);
    }

    setDate(prev);
  }

  // ========== Period Range Calculation ==========

  DateTimeRange get currentPeriodRange {
    if (!state.hasValue)
      return DateTimeRange(start: DateTime.now(), end: DateTime.now());
    return _getPeriodRange(state.value!.selectedDate, state.value!.period);
  }

  DateTimeRange get previousPeriodRange {
    if (!state.hasValue)
      return DateTimeRange(start: DateTime.now(), end: DateTime.now());
    final current = state.value!.selectedDate;
    final period = state.value!.period;
    DateTime prevDate;

    switch (period) {
      case InsightsPeriod.week:
        prevDate = current.subtract(const Duration(days: 7));
      case InsightsPeriod.month:
        prevDate = DateTime(current.year, current.month - 1, current.day);
      case InsightsPeriod.quarter:
        prevDate = DateTime(current.year, current.month - 3, current.day);
      case InsightsPeriod.year:
        prevDate = DateTime(current.year - 1, current.month, current.day);
    }

    return _getPeriodRange(prevDate, period);
  }

  DateTimeRange _getPeriodRange(DateTime date, InsightsPeriod period) {
    switch (period) {
      case InsightsPeriod.week:
        final weekday = date.weekday;
        final monday = date.subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(monday.year, monday.month, monday.day),
          end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
        );

      case InsightsPeriod.month:
        final firstDay = DateTime(date.year, date.month, 1);
        final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);

      case InsightsPeriod.quarter:
        final quarterMonth = ((date.month - 1) ~/ 3) * 3 + 1;
        final firstDay = DateTime(date.year, quarterMonth, 1);
        final lastDay = DateTime(date.year, quarterMonth + 3, 0, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);

      case InsightsPeriod.year:
        final firstDay = DateTime(date.year, 1, 1);
        final lastDay = DateTime(date.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);
    }
  }

  String get periodLabel {
    if (!state.hasValue) return '';
    final range = currentPeriodRange;
    final months = [
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

    switch (state.value!.period) {
      case InsightsPeriod.week:
        final start = range.start;
        final end = range.end;
        if (start.month == end.month) {
          return '${start.day} - ${end.day} ${months[start.month - 1]}';
        }
        return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}';

      case InsightsPeriod.month:
        return '${months[range.start.month - 1]} ${range.start.year}';

      case InsightsPeriod.quarter:
        final quarter = ((range.start.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${range.start.year}';

      case InsightsPeriod.year:
        return '${range.start.year}';
    }
  }

  // ========== Filtered Transactions ==========

  List<Transaction> get _currentPeriodTransactions {
    return _getTransactionsInRange(currentPeriodRange);
  }

  List<Transaction> get _previousPeriodTransactions {
    return _getTransactionsInRange(previousPeriodRange);
  }

  List<Transaction> _getTransactionsInRange(DateTimeRange range) {
    if (!state.hasValue) return [];
    return state.value!.transactions.where((t) {
      return t.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(range.end.add(const Duration(seconds: 1)));
    }).toList();
  }

  List<Transaction> get _currentExpenses {
    return _currentPeriodTransactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
  }

  List<Transaction> get _previousExpenses {
    return _previousPeriodTransactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
  }

  // ========== Spending Overview ==========

  double get totalSpending {
    final expenses = _currentExpenses;
    if (expenses.isEmpty) return 0;
    return expenses.fold(0.0, (sum, t) => sum + t.amount.value);
  }

  double get previousTotalSpending {
    final expenses = _previousExpenses;
    if (expenses.isEmpty) return 0;
    return expenses.fold(0.0, (sum, t) => sum + t.amount.value);
  }

  double get spendingChangePercentage {
    if (previousTotalSpending == 0) return 0;
    return ((totalSpending - previousTotalSpending) / previousTotalSpending) *
        100;
  }

  double get averageDailySpending {
    final range = currentPeriodRange;
    final days = range.end.difference(range.start).inDays + 1;
    if (days == 0) return 0;
    return totalSpending / days;
  }

  double get totalIncome {
    final incomes = _currentPeriodTransactions.where(
      (t) => t.type == TransactionType.income,
    );
    if (incomes.isEmpty) return 0;
    return incomes.fold(0.0, (sum, t) => sum + t.amount.value);
  }

  // ========== Spending Trend ==========

  List<SpendingTrendPoint> get spendingTrend {
    if (!state.hasValue) return [];
    final List<SpendingTrendPoint> points = [];
    final range = currentPeriodRange;

    switch (state.value!.period) {
      case InsightsPeriod.week:
        for (int i = 0; i < 7; i++) {
          final day = range.start.add(Duration(days: i));
          final dayExpenses = _currentExpenses.where(
            (t) =>
                t.date.year == day.year &&
                t.date.month == day.month &&
                t.date.day == day.day,
          );
          final amount = dayExpenses.fold(
            0.0,
            (sum, t) => sum + t.amount.value,
          );
          final labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
          points.add(
            SpendingTrendPoint(label: labels[i], amount: amount, date: day),
          );
        }

      case InsightsPeriod.month:
        DateTime weekStart = range.start;
        int weekNum = 1;
        while (weekStart.isBefore(range.end)) {
          final weekEnd = weekStart.add(const Duration(days: 6));
          final actualEnd = weekEnd.isAfter(range.end) ? range.end : weekEnd;

          final weekExpenses = _currentExpenses.where(
            (t) =>
                t.date.isAfter(
                  weekStart.subtract(const Duration(seconds: 1)),
                ) &&
                t.date.isBefore(actualEnd.add(const Duration(seconds: 1))),
          );
          final amount = weekExpenses.fold(
            0.0,
            (sum, t) => sum + t.amount.value,
          );

          points.add(
            SpendingTrendPoint(
              label: 'S$weekNum',
              amount: amount,
              date: weekStart,
            ),
          );

          weekStart = weekStart.add(const Duration(days: 7));
          weekNum++;
        }

      case InsightsPeriod.quarter:
        for (int i = 0; i < 3; i++) {
          final month = DateTime(range.start.year, range.start.month + i, 1);
          final monthExpenses = _currentExpenses.where(
            (t) => t.date.year == month.year && t.date.month == month.month,
          );
          final amount = monthExpenses.fold(
            0.0,
            (sum, t) => sum + t.amount.value,
          );
          final months = [
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
          points.add(
            SpendingTrendPoint(
              label: months[month.month - 1],
              amount: amount,
              date: month,
            ),
          );
        }

      case InsightsPeriod.year:
        for (int i = 0; i < 12; i++) {
          final month = DateTime(range.start.year, i + 1, 1);
          final monthExpenses = _currentExpenses.where(
            (t) => t.date.year == month.year && t.date.month == month.month,
          );
          final amount = monthExpenses.fold(
            0.0,
            (sum, t) => sum + t.amount.value,
          );
          final months = [
            'E',
            'F',
            'M',
            'A',
            'M',
            'J',
            'J',
            'A',
            'S',
            'O',
            'N',
            'D',
          ];
          points.add(
            SpendingTrendPoint(label: months[i], amount: amount, date: month),
          );
        }
    }

    return points;
  }

  double get trendMaxAmount {
    if (spendingTrend.isEmpty) return 0;
    return spendingTrend.map((p) => p.amount).reduce((a, b) => a > b ? a : b);
  }

  double get trendAverageAmount {
    if (spendingTrend.isEmpty) return 0;
    return spendingTrend.map((p) => p.amount).reduce((a, b) => a + b) /
        spendingTrend.length;
  }

  // ========== Category Breakdown ==========

  List<CategorySpendingData> get categoryBreakdown {
    if (!state.hasValue) return [];
    final Map<String, double> currentByCategory = {};
    final Map<String, double> previousByCategory = {};

    for (final t in _currentExpenses) {
      if (t.categoryId != null) {
        currentByCategory[t.categoryId!] =
            (currentByCategory[t.categoryId!] ?? 0) + t.amount.value;
      }
    }

    for (final t in _previousExpenses) {
      if (t.categoryId != null) {
        previousByCategory[t.categoryId!] =
            (previousByCategory[t.categoryId!] ?? 0) + t.amount.value;
      }
    }

    final total = totalSpending;
    final List<CategorySpendingData> result = [];

    for (final entry in currentByCategory.entries) {
      final category = state.value!.categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Otros',
          icon: CategoryIcon.home,
        ),
      );

      final previousAmount = previousByCategory[entry.key] ?? 0;
      final change = previousAmount > 0
          ? ((entry.value - previousAmount) / previousAmount) * 100
          : 0.0;

      result.add(
        CategorySpendingData(
          category: category,
          amount: entry.value,
          percentage: total > 0 ? (entry.value / total) * 100 : 0,
          changeFromPrevious: change,
        ),
      );
    }

    result.sort((a, b) => b.amount.compareTo(a.amount));
    return result;
  }

  List<CategorySpendingData> get topExpenses {
    return categoryBreakdown.take(5).toList();
  }

  List<CategorySpendingData> get filteredTopExpenses {
    if (!state.hasValue) return [];
    if (state.value!.selectedTagId == null) return topExpenses;

    final filteredCategories = state.value!.categories
        .where((c) => c.tagIds.contains(state.value!.selectedTagId))
        .map((c) => c.id)
        .toSet();

    return categoryBreakdown
        .where((data) => filteredCategories.contains(data.category.id))
        .take(5)
        .toList();
  }

  // ========== Weekly Patterns ==========

  List<WeekdaySpendingData> get weekdayPatterns {
    final Map<int, List<double>> amountsByDay = {
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
      7: [],
    };

    for (final t in _currentExpenses) {
      amountsByDay[t.date.weekday]!.add(t.amount.value);
    }

    final labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final List<WeekdaySpendingData> result = [];
    double maxAverage = 0;

    for (int day = 1; day <= 7; day++) {
      final amounts = amountsByDay[day]!;
      final avg = amounts.isEmpty
          ? 0.0
          : amounts.reduce((a, b) => a + b) / amounts.length;
      if (avg > maxAverage) maxAverage = avg;
      result.add(
        WeekdaySpendingData(
          weekday: day,
          label: labels[day - 1],
          averageAmount: avg,
          intensity: 0,
        ),
      );
    }

    return result.map((data) {
      return WeekdaySpendingData(
        weekday: data.weekday,
        label: data.label,
        averageAmount: data.averageAmount,
        intensity: maxAverage > 0 ? data.averageAmount / maxAverage : 0,
      );
    }).toList();
  }

  int get highestSpendingDay {
    if (weekdayPatterns.isEmpty) return 1;
    return weekdayPatterns
        .reduce((a, b) => a.averageAmount > b.averageAmount ? a : b)
        .weekday;
  }

  // ========== Savings Insights ==========

  double get savingsRate {
    if (totalIncome == 0) return 0;
    final savings = totalIncome - totalSpending;
    return (savings / totalIncome * 100).clamp(-100, 100);
  }

  double get netSavings {
    return totalIncome - totalSpending;
  }

  double get projectedMonthlySavings {
    final range = currentPeriodRange;
    final daysInPeriod = range.end.difference(range.start).inDays + 1;
    final dailySavings = netSavings / daysInPeriod;
    return dailySavings * 30;
  }

  // ========== Smart Tips ==========

  List<SmartTip> get smartTips {
    final List<SmartTip> tips = [];

    if (spendingChangePercentage.abs() > 10) {
      if (spendingChangePercentage > 0) {
        tips.add(
          SmartTip(
            type: SmartTipType.warning,
            title: 'Gasto incrementado',
            description:
                'Tu gasto subió ${spendingChangePercentage.abs().toStringAsFixed(0)}% respecto al período anterior.',
            iconType: IconType.trendUp,
          ),
        );
      } else {
        tips.add(
          SmartTip(
            type: SmartTipType.success,
            title: '¡Buen trabajo!',
            description:
                'Redujiste tu gasto en ${spendingChangePercentage.abs().toStringAsFixed(0)}% respecto al período anterior.',
            iconType: IconType.trendDown,
          ),
        );
      }
    }

    final risingCategories = categoryBreakdown
        .where((c) => c.changeFromPrevious > 20)
        .toList();
    if (risingCategories.isNotEmpty) {
      final top = risingCategories.first;
      tips.add(
        SmartTip(
          type: SmartTipType.info,
          title: 'Categoría en alza',
          description:
              '${top.category.name} subió ${top.changeFromPrevious.toStringAsFixed(0)}% este período.',
          iconType: IconType.alert,
        ),
      );
    }

    final dayLabels = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final highDay = highestSpendingDay;
    if (weekdayPatterns.isNotEmpty) {
      final highDayData = weekdayPatterns.firstWhere(
        (d) => d.weekday == highDay,
      );
      if (highDayData.averageAmount > 0) {
        tips.add(
          SmartTip(
            type: SmartTipType.suggestion,
            title: 'Patrón detectado',
            description:
                'Los ${dayLabels[highDay - 1]} sueles gastar más. ¡Planifica con anticipación!',
            iconType: IconType.calendar,
          ),
        );
      }
    }

    if (savingsRate > 20) {
      tips.add(
        SmartTip(
          type: SmartTipType.success,
          title: 'Excelente ahorro',
          description:
              'Estás ahorrando el ${savingsRate.toStringAsFixed(0)}% de tus ingresos. ¡Sigue así!',
          iconType: IconType.savings,
        ),
      );
    } else if (savingsRate < 0) {
      tips.add(
        SmartTip(
          type: SmartTipType.warning,
          title: 'Gastos superan ingresos',
          description:
              'Estás gastando más de lo que ingresas. Revisa tus gastos.',
          iconType: IconType.alert,
        ),
      );
    }

    return tips.take(4).toList();
  }
}
