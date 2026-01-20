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
      _ref.invalidate(accountsProvider); // Sync with other views
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
      _ref.invalidate(accountsProvider); // Sync with other views
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
      _ref.invalidate(accountsProvider); // Sync with other views
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
