import 'package:finapp/domain/models/finance_models.dart';

/// Período de tiempo para análisis de insights
enum InsightsPeriod { week, month, quarter, year }

/// Estado de la pantalla de Insights
class InsightsState {
  final InsightsPeriod period;
  final DateTime selectedDate;
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<Account> accounts;
  final List<Tag> tags;
  final String? selectedTagId;

  const InsightsState({
    required this.period,
    required this.selectedDate,
    required this.transactions,
    required this.categories,
    required this.accounts,
    required this.tags,
    this.selectedTagId,
  });

  InsightsState copyWith({
    InsightsPeriod? period,
    DateTime? selectedDate,
    List<Transaction>? transactions,
    List<Category>? categories,
    List<Account>? accounts,
    List<Tag>? tags,
    String? selectedTagId,
    bool clearTagId = false,
  }) {
    return InsightsState(
      period: period ?? this.period,
      selectedDate: selectedDate ?? this.selectedDate,
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
      tags: tags ?? this.tags,
      selectedTagId: clearTagId ? null : (selectedTagId ?? this.selectedTagId),
    );
  }
}

/// Datos de tendencia de gasto
class SpendingTrendPoint {
  final String label;
  final double amount;
  final DateTime date;

  const SpendingTrendPoint({
    required this.label,
    required this.amount,
    required this.date,
  });
}

/// Datos de distribución por categoría
class CategorySpendingData {
  final Category category;
  final double amount;
  final double percentage;
  final double changeFromPrevious; // porcentaje de cambio vs período anterior

  const CategorySpendingData({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.changeFromPrevious,
  });
}

/// Datos de patrón de gasto semanal
class WeekdaySpendingData {
  final int weekday; // 1 = Lunes, 7 = Domingo
  final String label;
  final double averageAmount;
  final double intensity; // 0.0 a 1.0 para el heatmap

  const WeekdaySpendingData({
    required this.weekday,
    required this.label,
    required this.averageAmount,
    required this.intensity,
  });
}

/// Tipo de tip inteligente
enum SmartTipType {
  warning, // Alerta sobre gasto excesivo
  success, // Buen comportamiento
  info, // Información neutral
  suggestion, // Sugerencia de mejora
}

/// Tip inteligente generado
class SmartTip {
  final SmartTipType type;
  final String title;
  final String description;
  final IconType? iconType;

  const SmartTip({
    required this.type,
    required this.title,
    required this.description,
    this.iconType,
  });
}

/// Tipo de icono para tips
enum IconType {
  trendUp,
  trendDown,
  calendar,
  savings,
  alert,
  checkCircle,
  lightbulb,
}
