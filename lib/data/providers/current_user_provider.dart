import 'package:finapp/features/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

/// Provider que expone el userId del usuario autenticado actual.
///
/// Este provider asume que la app es user-scoped (requiere login obligatorio).
/// El auth guard garantiza que siempre hay un usuario autenticado cuando
/// se accede a las pantallas principales de la app.
@riverpod
String currentUserId(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  // requireValue lanza excepción si está en loading/error
  // userId! es safe porque auth guard garantiza usuario autenticado
  return authState.requireValue.userId!;
}
