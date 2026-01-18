import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryExpenseItem extends StatelessWidget {
  final Category category;
  final Money amount;
  final double percentage;

  const CategoryExpenseItem({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  Color _getCategoryColor(BuildContext context, String categoryId) {
    final categoryColors = Theme.of(context).extension<CategoryColors>()!;

    final colorMap = {
      'c_rent': categoryColors.entertainment,
      'c_supermarket': categoryColors.food,
      'c_common_expenses': categoryColors.transport,
      'c_transport': categoryColors.transport,
      'c_eating_out': categoryColors.food,
      'c_entertainment': categoryColors.entertainment,
      'c_health': categoryColors.health,
      'c_utilities': categoryColors.utilities,
    };

    return colorMap[categoryId] ?? Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
      locale: 'es_CL',
    );

    final categoryColor = _getCategoryColor(context, category.id);

    return Container(
      padding: const EdgeInsets.all(12), // Reducido para igualar transacciones
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12), // 12 en transacciones
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 40, // 40 en transacciones
                height: 40, // 40 en transacciones
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle, // Círculo en transacciones
                ),
                child: Icon(
                  category.iconData,
                  color: categoryColor,
                  size: 20,
                ), // 20 en transacciones
              ),
              const SizedBox(width: 12),

              // Category name and subtitles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme
                          .textTheme
                          .titleMedium, // Igual que transacciones
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${percentage.round()}% del total consumido', // Sin decimales
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                currencyFormat.format(amount.value),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segmented Progress Bar
          _SegmentedProgressBar(
            percentage: percentage / 100,
            color: categoryColor,
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  final double percentage;
  final Color color;

  const _SegmentedProgressBar({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // 32 segmentos para un look más fino/vertical
        const int totalSegments = 32;
        const double spacing = 2.0;
        final double segmentWidth =
            (width - (spacing * (totalSegments - 1))) / totalSegments;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSegments, (index) {
            final double segmentProgress = (index + 1) / totalSegments;
            final bool isActive =
                segmentProgress <= percentage ||
                (index == 0 && percentage > 0.001);

            return Container(
              width: segmentWidth,
              height: 10,
              decoration: BoxDecoration(
                color: isActive
                    ? color
                    : colors.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        );
      },
    );
  }
}
