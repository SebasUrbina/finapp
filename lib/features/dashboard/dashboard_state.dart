import 'package:finapp/domain/models/finance_models.dart';

enum PeriodFilter { year, week, month }

class DashboardState {
  final PeriodFilter period;
  final DateTime selectedDate;
  final String? selectedAccountId; // null = "General" (todas las cuentas)
  final List<Transaction> transactions;
  final List<Account> accounts;
  final List<Category> categories;
  final List<Tag> tags;

  const DashboardState({
    required this.period,
    required this.selectedDate,
    this.selectedAccountId,
    required this.transactions,
    required this.accounts,
    required this.categories,
    required this.tags,
  });

  DashboardState copyWith({
    PeriodFilter? period,
    DateTime? selectedDate,
    String? selectedAccountId,
    List<Transaction>? transactions,
    List<Account>? accounts,
    List<Category>? categories,
    List<Tag>? tags,
  }) {
    return DashboardState(
      period: period ?? this.period,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
    );
  }
}
