import 'package:finapp/domain/models/finance_models.dart';

class TransactionEditState {
  final String transactionId;
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

  TransactionEditState({
    required this.transactionId,
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
  }) : selectedDate = selectedDate ?? DateTime.now();

  bool get canSubmit =>
      amount > 0 && selectedAccount != null && selectedCategory != null;

  TransactionEditState copyWith({
    String? transactionId,
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
  }) {
    return TransactionEditState(
      transactionId: transactionId ?? this.transactionId,
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
    );
  }
}
