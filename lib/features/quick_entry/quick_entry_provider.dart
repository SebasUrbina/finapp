import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quick_entry_controller.dart';
import '../../../data/repositories/finance_repository.dart';
import '../../../data/repositories/mock_finance_repository.dart';

/// Repositorio (mock hoy, backend mañana)
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return MockFinanceRepository();
});

/// Controller del Quick Entry
final quickEntryControllerProvider =
    ChangeNotifierProvider.autoDispose<QuickEntryController>((ref) {
      final repo = ref.watch(financeRepositoryProvider);
      return QuickEntryController(repo);
    });
