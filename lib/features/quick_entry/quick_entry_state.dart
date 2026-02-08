import 'package:finapp/domain/models/finance_models.dart';

class QuickEntryState {
  final TransactionType type;
  final double amount;
  final String description;
  final Account? selectedAccount;
  final Category? selectedCategory;
  final DateTime selectedDate;
  final bool isRecurring;
  final RecurrenceFrequency frequency;
  final int interval;
  final int dayOfMonth;
  final Split? split;

  QuickEntryState({
    this.type = TransactionType.expense,
    this.amount = 0,
    this.description = '',
    this.selectedAccount,
    this.selectedCategory,
    DateTime? selectedDate,
    this.isRecurring = false,
    this.frequency = RecurrenceFrequency.monthly,
    this.interval = 1,
    this.dayOfMonth = 1,
    this.split,
  }) : selectedDate = selectedDate ?? DateTime.now();

  bool get canSubmit =>
      amount > 0 && selectedAccount != null && selectedCategory != null;

  QuickEntryState copyWith({
    TransactionType? type,
    double? amount,
    String? description,
    Account? selectedAccount,
    Category? selectedCategory,
    DateTime? selectedDate,
    bool? isRecurring,
    RecurrenceFrequency? frequency,
    int? interval,
    int? dayOfMonth,
    Split? split,
  }) {
    return QuickEntryState(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      split: split ?? this.split,
    );
  }
}
