import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/date_ranges.dart';
import 'dashboard_base_providers.dart';
import 'dashboard_filter_providers.dart';

final dashboardDailySpendingTrendProvider =
    Provider.autoDispose<List<DailySpendingData>>((ref) {
      final transactions = ref.watch(dashboardFilteredTransactionsProvider);
      final now = DateTime.now();

      return List.generate(31, (i) {
        final date = now.subtract(Duration(days: 30 - i));
        final dayRange = DateTimeRange(
          start: DateTime(date.year, date.month, date.day),
          end: DateTime(date.year, date.month, date.day, 23, 59, 59),
        );

        final expenses = transactions.where(
          (t) =>
              t.type == TransactionType.expense && isWithin(t.date, dayRange),
        );

        final total = expenses.isEmpty
            ? const Money(0)
            : expenses.map((t) => t.amount).reduce((a, b) => a + b);

        return DailySpendingData(
          date: dayRange.start,
          amount: total,
          isToday: i == 30,
        );
      });
    });

final dashboardSpendingTrendProvider = Provider<List<SpendingTrendData>>((ref) {
  final transactions = ref.watch(dashboardTransactionsProvider);
  final period = ref.watch(dashboardPeriodProvider);
  final selectedDate = ref.watch(dashboardSelectedDateProvider);
  final accountId = ref.watch(dashboardSelectedAccountIdProvider);

  return List.generate(6, (i) {
    // 5 past periods + current one
    final offset = 5 - i;
    DateTime baseDate;
    String label;

    switch (period) {
      case PeriodFilter.year:
        baseDate = DateTime(selectedDate.year - offset);
        label = baseDate.year.toString();
        break;
      case PeriodFilter.month:
        baseDate = DateTime(selectedDate.year, selectedDate.month - offset);
        label = _getMonthAbbr(baseDate.month);
        break;
      case PeriodFilter.week:
        baseDate = selectedDate.subtract(Duration(days: offset * 7));
        label = 'S${_getWeekOfMonth(baseDate)}';
        break;
    }

    final range = buildRange(baseDate, period);
    final periodExpenses = transactions.where((t) {
      if (t.type != TransactionType.expense) return false;
      if (!isWithin(t.date, range)) return false;
      if (accountId != null && t.accountId != accountId) return false;
      return true;
    });

    final total = periodExpenses.isEmpty
        ? const Money(0)
        : periodExpenses.map((t) => t.amount).reduce((a, b) => a + b);

    return SpendingTrendData(
      label: label,
      amount: total,
      isCurrentPeriod: offset == 0,
    );
  });
});

String _getMonthAbbr(int month) {
  const abbrs = [
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
  return abbrs[month - 1];
}

int _getWeekOfMonth(DateTime date) {
  final firstDayOfMonth = DateTime(date.year, date.month, 1);
  final firstMonday = firstDayOfMonth.add(
    Duration(days: (8 - firstDayOfMonth.weekday) % 7),
  );
  if (date.isBefore(firstMonday)) return 1;
  return ((date.difference(firstMonday).inDays) / 7).floor() + 2;
}
