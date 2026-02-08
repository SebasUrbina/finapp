import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AccountController(this._ref) : super(const AsyncValue.data(null));

  Future<void> addAccount(Account account) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(financeRepositoryProvider);
      await repo.addAccount(account);
      await _ref.read(accountsProvider.notifier).reload(); // Silent reload
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateAccount(Account account) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(financeRepositoryProvider);
      await repo.updateAccount(account);
      await _ref.read(accountsProvider.notifier).reload();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAccount(String accountId) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(financeRepositoryProvider);
      await repo.deleteAccount(accountId);
      await _ref.read(accountsProvider.notifier).reload();
      // Also reload transactions as they might be affected or need cleanup?
      // Assuming cascade delete or similar is handled by repo/logic.
      // Reloading transactions just in case:
      await _ref.read(transactionsProvider.notifier).reload();

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final accountControllerProvider =
    StateNotifierProvider<AccountController, AsyncValue<void>>((ref) {
      return AccountController(ref);
    });
