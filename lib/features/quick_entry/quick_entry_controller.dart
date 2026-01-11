import 'package:flutter/material.dart';
import 'package:carenine/data/data.dart';
import 'package:carenine/core/models/finance_models.dart';

class QuickEntryController extends ChangeNotifier {
  final FinanceRepository repo;

  QuickEntryController(this.repo) {
    // Inicializar con primeros valores si existen
    final accounts = repo.getAccounts();
    if (accounts.isNotEmpty) selectedAccount = accounts.first;

    final categories = repo.getCategories();
    if (categories.isNotEmpty) selectedCategory = categories.first;
  }

  // ===== Core =====
  TransactionType type = TransactionType.expense;
  bool isRecurring = false;
  double amount = 0;
  String description = '';

  // ===== Accounts =====
  Account? selectedAccount;

  // ===== Categories =====
  Category? selectedCategory;

  // ===== Recurrence =====
  RecurrenceFrequency frequency = RecurrenceFrequency.monthly;
  int interval = 1;
  int dayOfMonth = 1;

  // ===== Data =====
  List<Account> get accounts => repo.getAccounts();
  List<Category> get categories => repo.getCategories();

  bool get canSubmit =>
      amount > 0 && selectedAccount != null && selectedCategory != null;

  // ===== Mutations =====
  void setAmount(double v) {
    amount = v;
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    notifyListeners();
  }

  void setType(TransactionType t) {
    type = t;
    notifyListeners();
  }

  void setAccount(Account? a) {
    selectedAccount = a;
    notifyListeners();
  }

  void setCategory(Category? c) {
    selectedCategory = c;
    notifyListeners();
  }

  void toggleRecurring(bool v) {
    isRecurring = v;
    notifyListeners();
  }

  void setRecurrence(RecurrenceFrequency f, int i, int d) {
    frequency = f;
    interval = i;
    dayOfMonth = d;
    notifyListeners();
  }

  Future<void> submit() async {
    if (!canSubmit) return;

    final tx = Transaction(
      id: DateTime.now().toIso8601String(),
      accountId: selectedAccount!.id,
      categoryId: selectedCategory!.id,
      amount: Money(amount.toInt()),
      date: DateTime.now(),
      type: type,
      description: description,
    );

    await repo.addTransaction(tx);
  }
}
