import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/shared_expenses/shared_expenses_controller.dart';
import 'package:finapp/features/shared_expenses/widgets/split_indicator_chip.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable widget for configuring shared expense splits
/// Compact design with only Equal and Percentage options
class CategorySplitConfigurator extends ConsumerStatefulWidget {
  final Split? initialSplit;
  final Function(Split?) onSplitChanged;
  final bool showPreview;
  final Money? totalAmount;

  const CategorySplitConfigurator({
    super.key,
    this.initialSplit,
    required this.onSplitChanged,
    this.showPreview = true,
    this.totalAmount,
  });

  @override
  ConsumerState<CategorySplitConfigurator> createState() =>
      _CategorySplitConfiguratorState();
}

class _CategorySplitConfiguratorState
    extends ConsumerState<CategorySplitConfigurator> {
  late bool _hasDefaultSplit;
  late SplitType _splitType;
  late List<String> _selectedPersonIds;
  late Map<String, double> _percentages; // For percentage split

  @override
  void initState() {
    super.initState();
    _hasDefaultSplit = widget.initialSplit != null;
    _splitType = widget.initialSplit?.type ?? SplitType.equal;
    _selectedPersonIds =
        widget.initialSplit?.participants.map((p) => p.personId).toList() ?? [];

    // Initialize percentages
    _percentages = {};
    if (widget.initialSplit != null &&
        widget.initialSplit!.type == SplitType.percentage) {
      for (var p in widget.initialSplit!.participants) {
        _percentages[p.personId] = p.value;
      }
    }
  }

  Split? _buildSplit() {
    if (!_hasDefaultSplit || _selectedPersonIds.isEmpty) return null;

    final controller = ref.read(sharedExpensesControllerProvider);
    final amount =
        widget.totalAmount ?? Money(100000); // Use actual or dummy amount

    if (_splitType == SplitType.equal) {
      return controller.createEqualSplit(amount, _selectedPersonIds);
    } else {
      // Percentage
      return controller.createPercentageSplit(amount, _percentages);
    }
  }

  void _notifyChange() {
    widget.onSplitChanged(_buildSplit());
  }

  void _updatePercentages() {
    // Distribute equally among selected persons
    if (_selectedPersonIds.isEmpty) return;

    final equalPercent = 1.0 / _selectedPersonIds.length;
    setState(() {
      _percentages = {for (var id in _selectedPersonIds) id: equalPercent};
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final personsAsync = ref.watch(personsProvider);

    return personsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Center(child: Text('Error loading persons: $err')),
      data: (persons) {
        if (persons.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.error, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hay personas registradas. Agrega personas en Configuración.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hasDefaultSplit
                ? colors.primaryContainer.withValues(alpha: 0.2)
                : colors.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hasDefaultSplit
                  ? colors.primary.withValues(alpha: 0.3)
                  : colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with toggle
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 20,
                    color: _hasDefaultSplit
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gasto compartido',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _hasDefaultSplit ? colors.primary : null,
                      ),
                    ),
                  ),
                  Switch(
                    value: _hasDefaultSplit,
                    onChanged: (value) {
                      setState(() {
                        _hasDefaultSplit = value;
                        if (value && _selectedPersonIds.isEmpty) {
                          // Select all persons by default
                          _selectedPersonIds = persons
                              .map((p) => p.id)
                              .toList();
                          _updatePercentages();
                        }
                      });
                      _notifyChange();
                    },
                  ),
                ],
              ),

              if (_hasDefaultSplit) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Split type selector - Compact buttons
                Row(
                  children: [
                    Expanded(
                      child: _SplitTypeButton(
                        label: 'División Igual',
                        icon: Icons.balance,
                        isSelected: _splitType == SplitType.equal,
                        onTap: () {
                          setState(() {
                            _splitType = SplitType.equal;
                          });
                          _notifyChange();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SplitTypeButton(
                        label: 'Porcentaje',
                        icon: Icons.percent,
                        isSelected: _splitType == SplitType.percentage,
                        onTap: () {
                          setState(() {
                            _splitType = SplitType.percentage;
                            _updatePercentages();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Person selection with percentage sliders
                ...persons.map((person) {
                  final isSelected = _selectedPersonIds.contains(person.id);
                  final percentage = _percentages[person.id] ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primaryContainer.withValues(alpha: 0.3)
                            : colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.5)
                              : colors.outlineVariant.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Person checkbox
                          CheckboxListTile(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedPersonIds.add(person.id);
                                } else {
                                  if (_selectedPersonIds.length > 1) {
                                    _selectedPersonIds.remove(person.id);
                                    _percentages.remove(person.id);
                                  }
                                }
                                if (_splitType == SplitType.percentage) {
                                  _updatePercentages();
                                }
                              });
                              _notifyChange();
                            },
                            title: Text(
                              person.name,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle:
                                _splitType == SplitType.percentage && isSelected
                                ? Text(
                                    '${(percentage * 100).toStringAsFixed(0)}%',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.primary.withValues(alpha: 0.2)
                                    : colors.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.person_outline,
                                color: isSelected
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),

                          // Percentage slider (only for percentage mode)
                          if (_splitType == SplitType.percentage &&
                              isSelected) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: percentage,
                                      min: 0.0,
                                      max: 1.0,
                                      divisions: 100,
                                      label:
                                          '${(percentage * 100).toStringAsFixed(0)}%',
                                      onChanged: (value) {
                                        setState(() {
                                          _percentages[person.id] = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        _notifyChange();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      '${(percentage * 100).toStringAsFixed(0)}%',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: colors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),

                // Preview
                if (widget.showPreview && _buildSplit() != null) ...[
                  const SizedBox(height: 8),
                  SplitIndicatorChip(
                    split: _buildSplit()!,
                    totalAmount: widget.totalAmount ?? Money(100000),
                    currentUserId: 'p1',
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Compact split type button
class _SplitTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SplitTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colors.onPrimary : colors.onSurface,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected ? colors.onPrimary : colors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
