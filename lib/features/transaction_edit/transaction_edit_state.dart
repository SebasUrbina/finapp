import 'package:finapp/domain/models/finance_models.dart';

class TransactionEditState {
  final Transaction originalTransaction;
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
    required this.originalTransaction,
    required this.type,
    required this.amount,
    required this.description,
    this.selectedAccount,
    this.selectedCategory,
    required this.selectedDate,
    this.isRecurring = false,
    this.frequency = RecurrenceFrequency.monthly,
    this.interval = 1,
    this.dayOfMonth = 1,
  });

  String get transactionId => originalTransaction.id;

  bool get canSubmit =>
      amount > 0 && selectedAccount != null && selectedCategory != null;

  TransactionEditState copyWith({
    Transaction? originalTransaction,
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
      originalTransaction: originalTransaction ?? this.originalTransaction,
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
