import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/quick_entry/quick_entry_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_entry_controller.g.dart';

@riverpod
class QuickEntryController extends _$QuickEntryController {
  @override
  FutureOr<QuickEntryState> build() async {
    final accounts = await ref.watch(accountsProvider.future);
    final categories = await ref.watch(categoriesProvider.future);

    final firstCategory = categories.isNotEmpty ? categories.first : null;
    final firstAccount = accounts.isNotEmpty ? accounts.first : null;

    return QuickEntryState(
      selectedAccount: firstAccount,
      selectedCategory: firstCategory,
      split: firstCategory?.defaultSplit,
      selectedDate: DateTime.now(),
      // other fields have defaults in QuickEntryState constructor or here
    );
  }

  void setAmount(double v) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(amount: v));
  }

  void setDescription(String v) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(description: v));
  }

  void setType(TransactionType t) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(type: t));
  }

  void setAccount(Account? a) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedAccount: a));
  }

  void setCategory(Category? c) {
    if (!state.hasValue) return;
    state = AsyncData(
      state.value!.copyWith(selectedCategory: c, split: c?.defaultSplit),
    );
  }

  void setDate(DateTime d) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedDate: d));
  }

  void toggleRecurring(bool v) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(isRecurring: v));
  }

  void setSplit(Split? s) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(split: s));
  }

  void setRecurrence(RecurrenceFrequency f, int i, int d) {
    if (!state.hasValue) return;
    state = AsyncData(
      state.value!.copyWith(frequency: f, interval: i, dayOfMonth: d),
    );
  }

  Future<void> submit() async {
    if (!state.hasValue || !state.value!.canSubmit) return;
    final currentState = state.value!;

    final tx = Transaction(
      id: DateTime.now().toIso8601String(),
      accountId: currentState.selectedAccount!.id,
      categoryId: currentState.selectedCategory!.id,
      amount: Money(currentState.amount),
      date: currentState.selectedDate,
      type: currentState.type,
      description: currentState.description,
    );

    await ref.read(financeRepositoryProvider).addTransaction(tx);

    // Invalidate providers to refresh data
    ref.invalidate(transactionsProvider);
    ref.invalidate(accountsProvider);
    // Budgets and Insights will also update automatically if they watch transactionsProvider
  }
}
