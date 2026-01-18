import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/widgets/category_expense_item.dart';
import 'package:flutter/material.dart';

class CategoryExpenseList extends StatelessWidget {
  final Map<Category, Money> expenses;
  final Money totalExpenses;
  final int limit;

  const CategoryExpenseList({
    super.key,
    required this.expenses,
    required this.totalExpenses,
    this.limit = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = expenses.entries.take(limit).toList();

    return Column(
      children: items.map((entry) {
        final category = entry.key;
        final amount = entry.value;
        final totalCents = totalExpenses.cents;
        final percentage = totalCents > 0
            ? (amount.cents / totalCents * 100)
            : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CategoryExpenseItem(
            category: category,
            amount: amount,
            percentage: percentage,
          ),
        );
      }).toList(),
    );
  }
}
