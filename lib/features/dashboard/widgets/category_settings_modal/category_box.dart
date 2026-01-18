import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;

  const CategoryBox({super.key, required this.category, required this.onEdit});

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
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;
    final categoryColor = _getCategoryColor(context, category.id);

    return InkWell(
      onTap: onEdit, // Use onEdit for the whole box as requested
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(category.iconData, color: categoryColor, size: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
