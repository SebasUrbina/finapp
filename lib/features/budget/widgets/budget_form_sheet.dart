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

  @override
  void initState() {
    super.initState();
    _limit = widget.currentLimit;
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
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: colors.error),
                  onPressed: () => _confirmAndDelete(context),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.error.withValues(alpha: 0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Límite Mensual',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _limit.toCurrency(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colors.primary,
              inactiveTrackColor: colors.surfaceContainerHighest,
              thumbColor: colors.primary,
              overlayColor: colors.primary.withValues(alpha: 0.12),
              trackHeight: 8,
            ),
            child: Slider(
              value: _limit,
              min: 0,
              max: (widget.currentLimit * 2).clamp(100000, 2000000).toDouble(),
              divisions: 200,
              onChanged: (value) {
                setState(() => _limit = (value / 5000).round() * 5000.0);
              },
            ),
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    widget.onSave(_limit);
                    // Modal is closed by parent callback
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Guardar Presupuesto'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
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

    if (confirm == true) {
      widget.onDelete?.call();
      // Modal is closed by parent callback
    }
  }
}
