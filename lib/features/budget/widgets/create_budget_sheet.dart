import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class CreateBudgetSheet extends StatefulWidget {
  final List<Category> availableCategories;
  final Function(String categoryId, double limit) onSave;

  const CreateBudgetSheet({
    super.key,
    required this.availableCategories,
    required this.onSave,
  });

  @override
  State<CreateBudgetSheet> createState() => _CreateBudgetSheetState();
}

class _CreateBudgetSheetState extends State<CreateBudgetSheet> {
  String? _selectedCategoryId;
  double _limit = 50000.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nuevo Presupuesto',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Asigna un límite mensual a una categoría',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Category Selection
          Text(
            'Seleccionar Categoría',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: widget.availableCategories.isEmpty
                ? Center(
                    child: Text(
                      'Todas las categorías ya tienen un presupuesto',
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.availableCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final category = widget.availableCategories[index];
                      final isSelected = _selectedCategoryId == category.id;
                      final categoryColor = category.getColor(context);

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryId = category.id),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? categoryColor
                                    : categoryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: colors.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                category.iconData,
                                color: isSelected
                                    ? Colors.white
                                    : categoryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.name,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : null,
                                color: isSelected ? colors.primary : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 32),

          // Limit Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Límite Mensual',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _limit.toCurrency(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colors.primary,
              inactiveTrackColor: colors.primary.withValues(alpha: 0.1),
              thumbColor: colors.primary,
              overlayColor: colors.primary.withValues(alpha: 0.1),
              trackHeight: 8,
            ),
            child: Slider(
              value: _limit,
              min: 5000,
              max: 1_000_000,
              divisions: 199,
              onChanged: (value) => setState(() => _limit = value),
            ),
          ),
          const SizedBox(height: 32),

          // Save Button
          ElevatedButton(
            onPressed: _selectedCategoryId == null
                ? null
                : () {
                    widget.onSave(_selectedCategoryId!, _limit);
                    // Modal is closed by parent callback
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Guardar Presupuesto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
