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
  bool _isSaving = false;
  late final TextEditingController _limitController;

  static const _quickAmounts = [50000.0, 100000.0, 200000.0, 500000.0];
  static const _maxLimit = 1000000.0;
  static const _minLimit = 5000.0;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(text: _limit.toFormatted());
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _updateLimit(double value) {
    final clamped = value.clamp(_minLimit, _maxLimit);
    setState(() => _limit = clamped);
    final formatted = clamped.toFormatted();
    if (_limitController.text != formatted) {
      _limitController.text = formatted;
      _limitController.selection = TextSelection.collapsed(
        offset: formatted.length,
      );
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving || _selectedCategoryId == null) return;
    setState(() => _isSaving = true);

    widget.onSave(_selectedCategoryId!, _limit);
    // Parent callback closes the modal
  }

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
      child: SingleChildScrollView(
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
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : null,
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

            // Limit Section
            Text(
              'Límite Mensual',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Manual text input
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
              decoration: InputDecoration(
                prefixText: r'$ ',
                prefixStyle: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (v) {
                final parsed = CurrencyFormatter.parse(v);
                if (parsed > 0) {
                  final clamped = parsed.clamp(_minLimit, _maxLimit);
                  setState(() => _limit = clamped);
                  // Reformat
                  final formatted = clamped.toFormatted();
                  if (v != formatted) {
                    _limitController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 12),

            // Quick-select chips
            Wrap(
              spacing: 8,
              children: _quickAmounts.map((amount) {
                final isSelected = _limit == amount;
                return ChoiceChip(
                  label: Text(amount.toCurrency()),
                  selected: isSelected,
                  onSelected: (_) => _updateLimit(amount),
                  selectedColor: colors.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? colors.onPrimaryContainer
                        : colors.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colors.primary,
                inactiveTrackColor: colors.primary.withValues(alpha: 0.1),
                thumbColor: colors.primary,
                overlayColor: colors.primary.withValues(alpha: 0.1),
                trackHeight: 8,
              ),
              child: Slider(
                value: _limit.clamp(_minLimit, _maxLimit),
                min: _minLimit,
                max: _maxLimit,
                divisions: 199,
                onChanged: _updateLimit,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _minLimit.toCurrency(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _maxLimit.toCurrency(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedCategoryId == null || _isSaving)
                    ? null
                    : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.onPrimary,
                        ),
                      )
                    : const Text(
                        'Guardar Presupuesto',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
