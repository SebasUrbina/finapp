import 'package:finapp/domain/models/finance_models.dart';

class QuickEntryState {
  final TransactionType type;
  final double amount;
  final String description;
  final Account? selectedAccount;
  final Category? selectedCategory;
  final bool isRecurring;
  final RecurrenceFrequency frequency;
  final int interval;
  final int dayOfMonth;

  QuickEntryState({
    this.type = TransactionType.expense,
    this.amount = 0,
    this.description = '',
    this.selectedAccount,
    this.selectedCategory,
    this.isRecurring = false,
    this.frequency = RecurrenceFrequency.monthly,
    this.interval = 1,
    this.dayOfMonth = 1,
  });

  bool get canSubmit =>
      amount > 0 && selectedAccount != null && selectedCategory != null;

  QuickEntryState copyWith({
    TransactionType? type,
    double? amount,
    String? description,
    Account? selectedAccount,
    Category? selectedCategory,
    bool? isRecurring,
    RecurrenceFrequency? frequency,
    int? interval,
    int? dayOfMonth,
  }) {
    return QuickEntryState(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    );
  }
}
