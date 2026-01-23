import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';

class BudgetState {
  final List<Budget> budgets;
  final List<Category> categories;
  final List<Transaction> transactions;
  final List<Tag> tags;
  final DateTime selectedDate;
  final String? selectedTagId;
  final bool isLoading;

  BudgetState({
    this.budgets = const [],
    this.categories = const [],
    this.transactions = const [],
    this.tags = const [],
    required this.selectedDate,
    this.selectedTagId,
    this.isLoading = false,
  });

  BudgetState copyWith({
    List<Budget>? budgets,
    List<Category>? categories,
    List<Transaction>? transactions,
    List<Tag>? tags,
    DateTime? selectedDate,
    ValueGetter<String?>? selectedTagId,
    bool? isLoading,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      tags: tags ?? this.tags,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTagId: selectedTagId != null
          ? selectedTagId()
          : this.selectedTagId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

enum BudgetStatus { healthy, warning, danger }

class CategoryBudgetData {
  final String budgetId;
  final Category category;
  final Money limit;
  final Money spent;
  final double percentage;

  CategoryBudgetData({
    required this.budgetId,
    required this.category,
    required this.limit,
    required this.spent,
    required this.percentage,
  });

  BudgetStatus get status {
    if (percentage < 0.7) return BudgetStatus.healthy;
    if (percentage < 0.9) return BudgetStatus.warning;
    return BudgetStatus.danger;
  }
}

enum BudgetTipType { warning, success, info, danger }

enum BudgetIconType {
  trendUp,
  trendDown,
  alert,
  checkCircle,
  savings,
  warning,
  celebration,
}

class BudgetTip {
  final BudgetTipType type;
  final String title;
  final String description;
  final BudgetIconType? iconType;
  final String? categoryName;

  const BudgetTip({
    required this.type,
    required this.title,
    required this.description,
    this.iconType,
    this.categoryName,
  });
}
