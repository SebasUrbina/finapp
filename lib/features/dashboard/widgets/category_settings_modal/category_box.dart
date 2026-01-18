import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const CategoryBox({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onTap,
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
    final categoryColor = _getCategoryColor(context, category.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.iconData,
                    color: categoryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
