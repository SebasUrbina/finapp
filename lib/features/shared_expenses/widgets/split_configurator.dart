import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/shared_expenses/widgets/participant_picker.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitConfigurator extends ConsumerStatefulWidget {
  final Money totalAmount;
  final Split? initialSplit;
  final Function(Split?) onSplitChanged;

  const SplitConfigurator({
    super.key,
    required this.totalAmount,
    this.initialSplit,
    required this.onSplitChanged,
  });

  @override
  ConsumerState<SplitConfigurator> createState() => _SplitConfiguratorState();
}

class _SplitConfiguratorState extends ConsumerState<SplitConfigurator> {
  late SplitType _selectedType;
  late List<String> _selectedPersonIds;
  late Map<String, double> _values;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialSplit?.type ?? SplitType.equal;
    _selectedPersonIds =
        widget.initialSplit?.participants.map((p) => p.personId).toList() ??
        ['p1']; // Default to current user (though p1 might not exist)
    _values = {};
    // Initialize values if present
    if (widget.initialSplit != null) {
      for (var p in widget.initialSplit!.participants) {
        _values[p.personId] = p.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type selector
          Text(
            'Tipo de división',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          SegmentedButton<SplitType>(
            segments: const [
              ButtonSegment(
                value: SplitType.equal,
                label: Text('Equitativo'),
                icon: Icon(Icons.balance, size: 18),
              ),
              ButtonSegment(
                value: SplitType.percentage,
                label: Text('%'),
                icon: Icon(Icons.percent, size: 18),
              ),
              ButtonSegment(
                value: SplitType.fixedAmount,
                label: Text('Fijo'),
                icon: Icon(Icons.attach_money, size: 18),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<SplitType> newSelection) {
              setState(() {
                _selectedType = newSelection.first;
                _values.clear();
                _updateSplit();
              });
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(theme.textTheme.labelSmall),
            ),
          ),

          const SizedBox(height: 20),

          // Participant picker
          ParticipantPicker(
            selectedPersonIds: _selectedPersonIds,
            splitType: _selectedType,
            totalAmount: widget.totalAmount,
            onChanged: (personIds, values) {
              setState(() {
                // Create defensive copies to prevent mutations
                _selectedPersonIds = List.from(personIds);
                _values = Map.from(values);
                _updateSplit();
              });
            },
          ),

          const SizedBox(height: 16),

          // Summary
          if (_selectedPersonIds.isNotEmpty) _buildSummary(theme, colors),
        ],
      ),
    );
  }

  Widget _buildSummary(ThemeData theme, ColorScheme colors) {
    final split = _createSplit();
    if (split == null) return const SizedBox.shrink();

    final personsAsync = ref.watch(personsProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'Resumen',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          personsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => Text(
              'Error cargando participantes',
              style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
            ),
            data: (persons) {
              return Column(
                children: split.participants.map((p) {
                  final person = persons.firstWhere(
                    (person) => person.id == p.personId,
                    orElse: () => Person(id: p.personId, name: 'Desconocido'),
                  );

                  final amount = _selectedType == SplitType.percentage
                      ? widget.totalAmount.value * p.value
                      : p.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(person.name, style: theme.textTheme.bodyMedium),
                        Text(
                          '\$${amount.toCurrency()}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Validation messages don't depend on persons, but _isValid logic might?
          // _isValid() depends on _values and total, not persons list directly, so it can be outside async block
          if (!_isValid()) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: colors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getValidationMessage(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Split? _createSplit() {
    if (_selectedPersonIds.isEmpty) return null;

    final participants = _selectedPersonIds.map((id) {
      double value;
      if (_selectedType == SplitType.equal) {
        value = widget.totalAmount.value / _selectedPersonIds.length;
      } else {
        value = _values[id] ?? 0;
      }
      return SplitParticipant(personId: id, value: value);
    }).toList();

    return Split(type: _selectedType, participants: participants);
  }

  void _updateSplit() {
    final split = _createSplit();
    widget.onSplitChanged(split);
  }

  bool _isValid() {
    if (_selectedPersonIds.isEmpty) return false;

    switch (_selectedType) {
      case SplitType.equal:
        return true;

      case SplitType.percentage:
        final total = _values.values.fold<double>(0, (sum, v) => sum + v);
        return (total - 1.0).abs() < 0.01;

      case SplitType.fixedAmount:
        final total = _values.values.fold<double>(0, (sum, v) => sum + v);
        return (total - widget.totalAmount.value).abs() < 0.01;
    }
  }

  String _getValidationMessage() {
    switch (_selectedType) {
      case SplitType.percentage:
        final total = _values.values.fold<double>(0, (sum, v) => sum + v);
        final percentage = (total * 100).toStringAsFixed(0);
        return 'Los porcentajes deben sumar 100% (actual: $percentage%)';

      case SplitType.fixedAmount:
        final total = _values.values.fold<double>(0, (sum, v) => sum + v);
        return 'Los montos deben sumar \$${widget.totalAmount.value.toCurrency()} (actual: \$${total.toCurrency()})';

      default:
        return '';
    }
  }
}
