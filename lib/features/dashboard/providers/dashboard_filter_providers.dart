import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/core/utils/date_ranges.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'dashboard_base_providers.dart';

final dashboardPeriodRangeProvider = Provider<DateTimeRange>((ref) {
  final date = ref.watch(dashboardSelectedDateProvider);
  final period = ref.watch(dashboardPeriodProvider);
  return buildRange(date, period);
});

final dashboardPreviousPeriodRangeProvider = Provider<DateTimeRange>((ref) {
  final date = ref.watch(dashboardSelectedDateProvider);
  final period = ref.watch(dashboardPeriodProvider);
  return buildPreviousRange(date, period);
});

final dashboardFilteredTransactionsProvider = Provider<List<Transaction>>((
  ref,
) {
  final transactions = ref.watch(dashboardTransactionsProvider);
  final range = ref.watch(dashboardPeriodRangeProvider);
  final accountId = ref.watch(dashboardSelectedAccountIdProvider);

  final filtered = transactions.where((t) {
    if (!isWithin(t.date, range)) return false;
    if (accountId != null && t.accountId != accountId) return false;
    return true;
  }).toList();

  filtered.sort((a, b) => b.date.compareTo(a.date));
  return filtered;
});

final dashboardRecentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(dashboardFilteredTransactionsProvider);
  return transactions.take(7).toList();
});
