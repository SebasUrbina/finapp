import 'package:finapp/domain/models/finance_models.dart';

enum PeriodFilter { week, month }

class DashboardState {
  final PeriodFilter period;
  final DateTime selectedDate;
  final List<Transaction> transactions;
  final List<Account> accounts;
  final List<Category> categories;

  const DashboardState({
    required this.period,
    required this.selectedDate,
    required this.transactions,
    required this.accounts,
    required this.categories,
  });

  DashboardState copyWith({
    PeriodFilter? period,
    DateTime? selectedDate,
    List<Transaction>? transactions,
    List<Account>? accounts,
    List<Category>? categories,
  }) {
    return DashboardState(
      period: period ?? this.period,
      selectedDate: selectedDate ?? this.selectedDate,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
    );
  }
}
