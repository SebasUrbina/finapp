import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class BudgetFormSheet extends StatefulWidget {
  final Category category;
  final double currentLimit;
  final Function(double) onSave;
  final VoidCallback? onDelete;

  const BudgetFormSheet({
    super.key,
    required this.category,
    required this.currentLimit,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<BudgetFormSheet> createState() => _BudgetFormSheetState();
}

class _BudgetFormSheetState extends State<BudgetFormSheet> {
  late double _limit;
  late final TextEditingController _limitController;
  bool _isSaving = false;
  bool _isDeleting = false;

  late final double _maxSlider;
  static const _minSlider = 5000.0;

  @override
  void initState() {
    super.initState();
    _limit = widget.currentLimit;
    _maxSlider = (widget.currentLimit * 2).clamp(100000, 2000000).toDouble();
    _limitController = TextEditingController(text: _limit.toFormatted());
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _updateLimit(double value) {
    final clamped = (value / 5000).round() * 5000.0;
    setState(() => _limit = clamped.clamp(_minSlider, _maxSlider));
    final formatted = _limit.toFormatted();
    if (_limitController.text != formatted) {
      _limitController.text = formatted;
      _limitController.selection = TextSelection.collapsed(
        offset: formatted.length,
      );
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    widget.onSave(_limit);
    // Parent callback closes the modal
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    if (_isDeleting) return;

    final colors = Theme.of(context).colorScheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar presupuesto?'),
        content: Text(
          'Se eliminará el presupuesto para la categoría ${widget.category.name}. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    setState(() => _isDeleting = true);
    widget.onDelete?.call();
    // Parent callback closes the modal
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.category
                        .getColor(context)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.category.iconData,
                    color: widget.category.getColor(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Presupuesto',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.category.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  _isDeleting
                      ? const SizedBox(
                          width: 40,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: colors.error,
                          ),
                          onPressed: () => _confirmAndDelete(context),
                          style: IconButton.styleFrom(
                            backgroundColor: colors.error.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
              ],
            ),
            const SizedBox(height: 32),

            // Limit label
            Text(
              'Límite Mensual',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.primary,
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
                  final clamped = parsed.clamp(_minSlider, _maxSlider);
                  setState(() => _limit = clamped);
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
            const SizedBox(height: 16),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colors.primary,
                inactiveTrackColor: colors.surfaceContainerHighest,
                thumbColor: colors.primary,
                overlayColor: colors.primary.withValues(alpha: 0.12),
                trackHeight: 8,
              ),
              child: Slider(
                value: _limit.clamp(_minSlider, _maxSlider),
                min: _minSlider,
                max: _maxSlider,
                divisions: 200,
                onChanged: _updateLimit,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _minSlider.toCurrency(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _maxSlider.toCurrency(),
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
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _isSaving ? null : _handleSave,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Guardar Presupuesto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
