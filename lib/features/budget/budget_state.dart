import 'package:finapp/domain/models/finance_models.dart';

/// Estado inmutable para la vista de presupuesto
class BudgetState {
  final List<Budget> budgets;
  final List<Category> categories;
  final List<Transaction> transactions;
  final BudgetPeriod selectedPeriod;
  final DateTime selectedDate;

  const BudgetState({
    required this.budgets,
    required this.categories,
    required this.transactions,
    this.selectedPeriod = BudgetPeriod.monthly,
    required this.selectedDate,
  });

  BudgetState copyWith({
    List<Budget>? budgets,
    List<Category>? categories,
    List<Transaction>? transactions,
    BudgetPeriod? selectedPeriod,
    DateTime? selectedDate,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
