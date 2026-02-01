import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';

final dashboardPeriodProvider = Provider((ref) {
  return ref.watch(dashboardControllerProvider.select((s) => s.period));
});

final dashboardSelectedDateProvider = Provider((ref) {
  return ref.watch(dashboardControllerProvider.select((s) => s.selectedDate));
});

final dashboardTransactionsProvider = Provider((ref) {
  return ref.watch(dashboardControllerProvider.select((s) => s.transactions));
});

final dashboardSelectedAccountIdProvider = Provider((ref) {
  return ref.watch(
    dashboardControllerProvider.select((s) => s.selectedAccountId),
  );
});

final dashboardCategoriesProvider = Provider((ref) {
  return ref.watch(dashboardControllerProvider.select((s) => s.categories));
});

final dashboardTagsProvider = Provider((ref) {
  return ref.watch(dashboardControllerProvider.select((s) => s.tags));
});
