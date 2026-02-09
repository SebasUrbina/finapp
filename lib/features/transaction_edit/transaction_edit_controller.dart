import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/data/providers/current_user_provider.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/transaction_edit/transaction_edit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_edit_controller.g.dart';

@riverpod
class TransactionEditController extends _$TransactionEditController {
  @override
  FutureOr<TransactionEditState> build(Transaction transaction) async {
    final categories = await ref.watch(categoriesProvider.future);
    final accounts = await ref.watch(accountsProvider.future);

    final category = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => Category(
        id: transaction.categoryId ?? 'unknown',
        name: 'Unknown',
        icon: CategoryIcon.home,
      ),
    );

    final account = accounts.firstWhere(
      (a) => a.id == transaction.accountId,
      orElse: () => Account(
        id: transaction.accountId,
        name: 'Unknown',
        type: AccountType.checking, // Default type
        balance: Money(0),
      ),
    );

    return TransactionEditState(
      originalTransaction: transaction,
      type: transaction.type,
      amount: transaction.amount.value,
      description: transaction.description ?? '',
      selectedAccount: account,
      selectedCategory: category,
      selectedDate: transaction.date,
      isRecurring: transaction.recurringRuleId != null,
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
    state = AsyncData(state.value!.copyWith(selectedCategory: c));
  }

  void setDate(DateTime d) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedDate: d));
  }

  void toggleRecurring(bool v) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(isRecurring: v));
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

    final updatedTx = currentState.originalTransaction.copyWith(
      accountId: currentState.selectedAccount!.id,
      categoryId: currentState.selectedCategory!.id,
      amount: Money(currentState.amount),
      date: currentState.selectedDate,
      type: currentState.type,
      description: currentState.description,
    );

    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(financeRepositoryProvider)
        .updateTransaction(userId, updatedTx);

    // Silent reload to update lists without flicker
    await ref.read(transactionsProvider.notifier).reload();
    await ref.read(accountsProvider.notifier).reload();
    await ref.read(budgetsProvider.notifier).reload();
  }

  Future<void> delete() async {
    if (!state.hasValue) return;
    final txId = state.value!.transactionId;

    final userId = ref.read(currentUserIdProvider);
    await ref.read(financeRepositoryProvider).deleteTransaction(userId, txId);

    // Silent reload
    await ref.read(transactionsProvider.notifier).reload();
    await ref.read(accountsProvider.notifier).reload();
    await ref.read(budgetsProvider.notifier).reload();
  }
}
