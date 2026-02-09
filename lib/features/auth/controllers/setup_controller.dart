import 'package:finapp/domain/models/finance_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/providers/finance_providers.dart';
import '../auth_controller.dart';

part 'setup_controller.g.dart';

@riverpod
class SetupController extends _$SetupController {
  @override
  FutureOr<void> build() {
    // No initial state to load
  }

  Future<void> loadDefaultCategories() async {
    final authState = ref.read(authControllerProvider);
    final userId = authState.value?.userId;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(financeRepositoryProvider).loadDefaultCategories(userId);
      // Invalidate categories provider to refresh UI
      ref.invalidate(categoriesProvider);
    });
  }

  Future<void> createAccount(Account account) async {
    final authState = ref.read(authControllerProvider);
    final userId = authState.value?.userId;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(financeRepositoryProvider).addAccount(userId, account);
      // Invalidate accounts provider
      ref.invalidate(accountsProvider);

      // Update AuthController to reflect setup completion if needed
      // Currently AuthController checks for accounts on every user change
      // so manually invalidating it might trigger a re-check
      ref.invalidate(authControllerProvider);
    });
  }
}
