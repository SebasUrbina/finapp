import 'package:intl/intl.dart';

/// Utilidades para formatear fechas de manera relativa
class DateFormatUtils {
  /// Formatea una fecha de manera relativa al día actual
  ///
  /// Ejemplos:
  /// - Hoy
  /// - Ayer
  /// - Hace 2 días
  /// - 15 Ene (para fechas más antiguas)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Ayer';
    } else if (difference > 1 && difference <= 7) {
      return 'Hace $difference días';
    } else {
      // Para fechas más antiguas, mostrar día y mes
      return DateFormat('d MMM', 'es').format(date);
    }
  }

  /// Formatea una fecha con hora de manera relativa
  ///
  /// Ejemplos:
  /// - Hoy, 14:30
  /// - Ayer, 09:15
  /// - Hace 2 días
  /// - 15 Ene
  static String formatRelativeDateWithTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hoy, ${DateFormat('HH:mm').format(date)}';
    } else if (difference == 1) {
      return 'Ayer, ${DateFormat('HH:mm').format(date)}';
    } else if (difference > 1 && difference <= 7) {
      return 'Hace $difference días';
    } else {
      return DateFormat('d MMM', 'es').format(date);
    }
  }
}
