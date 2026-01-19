import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/transaction_edit/transaction_edit_state.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';

/// Provider family que recibe la transacción a editar
final transactionEditControllerProvider = NotifierProvider.autoDispose
    .family<TransactionEditController, TransactionEditState, Transaction>(
      TransactionEditController.new,
    );

class TransactionEditController
    extends AutoDisposeFamilyNotifier<TransactionEditState, Transaction> {
  @override
  TransactionEditState build(Transaction arg) {
    // Inicializar el estado con los datos de la transacción a editar
    final accounts = ref.watch(accountsProvider);
    final categories = ref.watch(categoriesProvider);

    // Buscar la cuenta y categoría actuales
    final currentAccount = accounts.firstWhere(
      (a) => a.id == arg.accountId,
      orElse: () => accounts.first,
    );

    final currentCategory = arg.categoryId != null
        ? categories.firstWhere(
            (c) => c.id == arg.categoryId,
            orElse: () => categories.first,
          )
        : categories.first;

    return TransactionEditState(
      transactionId: arg.id,
      type: arg.type,
      amount: arg.amount.value, // Usar directamente el valor
      description: arg.description ?? '',
      selectedAccount: currentAccount,
      selectedCategory: currentCategory,
      selectedDate: arg.date,
      isRecurring: arg.recurringRuleId != null,
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

    // Crear la transacción actualizada
    final updatedTransaction = Transaction(
      id: state.transactionId,
      accountId: state.selectedAccount!.id,
      categoryId: state.selectedCategory!.id,
      amount: Money(state.amount), // Usar directamente el valor
      date: state.selectedDate,
      type: state.type,
      description: state.description.isEmpty ? null : state.description,
    );

    // Actualizar en el repositorio
    await ref
        .read(financeRepositoryProvider)
        .updateTransaction(updatedTransaction);

    // Invalidar providers para refrescar la UI
    ref.invalidate(transactionsProvider);
    ref.invalidate(accountsProvider);
    ref.read(dashboardControllerProvider.notifier).refresh();
  }

  Future<void> delete() async {
    // Eliminar la transacción del repositorio
    await ref
        .read(financeRepositoryProvider)
        .deleteTransaction(state.transactionId);

    // Invalidar providers para refrescar la UI
    ref.invalidate(transactionsProvider);
    ref.invalidate(accountsProvider);
    ref.read(dashboardControllerProvider.notifier).refresh();
  }
}
