import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/quick_entry/quick_entry_state.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';

// Usamos AutoDisposeNotifier para que se dispare el dispose cuando el widget se desmonte
// Recomendado siempre que el notifier tenga un estado que depende de providers
class QuickEntryController extends AutoDisposeNotifier<QuickEntryState> {
  @override
  QuickEntryState build() {
    final accounts = ref.watch(accountsProvider);
    final categories = ref.watch(categoriesProvider);

    return QuickEntryState(
      selectedAccount: accounts.isNotEmpty ? accounts.first : null,
      selectedCategory: categories.isNotEmpty ? categories.first : null,
    );
  }

  void setAmount(double v) => state = state.copyWith(amount: v);
  void setDescription(String v) => state = state.copyWith(description: v);
  void setType(TransactionType t) => state = state.copyWith(type: t);
  void setAccount(Account? a) => state = state.copyWith(selectedAccount: a);
  void setCategory(Category? c) => state = state.copyWith(selectedCategory: c);
  void setDate(DateTime d) => state = state.copyWith(selectedDate: d);
  void toggleRecurring(bool v) => state = state.copyWith(isRecurring: v);

  void setRecurrence(RecurrenceFrequency f, int i, int d) {
    state = state.copyWith(frequency: f, interval: i, dayOfMonth: d);
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    final tx = Transaction(
      id: DateTime.now().toIso8601String(),
      accountId: state.selectedAccount!.id,
      categoryId: state.selectedCategory!.id,
      amount: Money(state.amount),
      date: state.selectedDate,
      type: state.type,
      description: state.description,
    );

    await ref.read(financeRepositoryProvider).addTransaction(tx);

    // Invalidamos para que los demas providers se enteren del cambio
    ref.invalidate(transactionsProvider);
    ref.invalidate(accountsProvider);
    ref.read(dashboardControllerProvider.notifier).refresh();
  }
}

final quickEntryControllerProvider =
    NotifierProvider.autoDispose<QuickEntryController, QuickEntryState>(
      QuickEntryController.new,
    );
