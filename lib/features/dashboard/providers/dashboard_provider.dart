import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final repository = ref.watch(financeRepositoryProvider);

      // Crear el controller
      final controller = DashboardController(repository);

      // Escuchar cambios en las transacciones para refrescar
      ref.listen(transactionsProvider, (previous, next) {
        controller.refresh();
      });

      return controller;
    });
