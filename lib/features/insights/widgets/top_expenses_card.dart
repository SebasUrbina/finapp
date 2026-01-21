import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/insights/insights_state.dart';
import 'package:flutter/material.dart';

class TopExpensesCard extends StatelessWidget {
  final List<CategorySpendingData> topCategories;

  const TopExpensesCard({super.key, required this.topCategories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (topCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Categorías',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.leaderboard_rounded,
                size: 20,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final cat = entry.value;
            final hasChange = cat.changeFromPrevious.abs() > 1;
            final isUp = cat.changeFromPrevious > 0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < topCategories.length - 1 ? 12 : 0,
              ),
              child: Row(
                children: [
                  // Ranking Badge
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getRankingColor(index).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _getRankingColor(index),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Category Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cat.category
                          .getColor(context)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat.category.iconData,
                      color: cat.category.getColor(context),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Category Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.category.name,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cat.percentage.toStringAsFixed(1)}% del total',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount and Change
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        cat.amount.toCurrency(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasChange)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUp
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 12,
                              color: isUp
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFF4CAF50),
                            ),
                            Text(
                              '${cat.changeFromPrevious.abs().toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: isUp
                                    ? const Color(0xFFFF6B6B)
                                    : const Color(0xFF4CAF50),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getRankingColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF94A3B8);
    }
  }
}
