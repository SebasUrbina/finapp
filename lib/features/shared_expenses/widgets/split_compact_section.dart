import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/shared_expenses/shared_expenses_controller.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Version compacta y minimalista del selector de split para QuickEntry
class SplitCompactSection extends ConsumerStatefulWidget {
  final Money totalAmount;
  final Split? initialSplit;
  final Function(Split?) onSplitChanged;

  const SplitCompactSection({
    super.key,
    required this.totalAmount,
    this.initialSplit,
    required this.onSplitChanged,
  });

  @override
  ConsumerState<SplitCompactSection> createState() =>
      _SplitCompactSectionState();
}

class _SplitCompactSectionState extends ConsumerState<SplitCompactSection> {
  late bool _isEnabled;
  late SplitType _splitType;
  late List<String> _selectedPersonIds;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialSplit != null;
    _splitType = widget.initialSplit?.type ?? SplitType.equal;
    _selectedPersonIds =
        widget.initialSplit?.participants.map((p) => p.personId).toList() ??
        ['p1', 'p2'];
  }

  @override
  void didUpdateWidget(SplitCompactSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSplit != oldWidget.initialSplit) {
      if (mounted) {
        setState(() {
          // Only update local state if external state implies a change that wasn't initiated locally,
          // or just always sync? 'initialSplit' usually implies "start with this", but if it changes dynamically...
          // For now, let's respect external changes if they differ from implicit state,
          // or just simple sync.
          _isEnabled = widget.initialSplit != null;
          if (widget.initialSplit != null) {
            _splitType = widget.initialSplit!.type;
            _selectedPersonIds = widget.initialSplit!.participants
                .map((p) => p.personId)
                .toList();
          }
        });
      }
    }
  }

  void _updateSplit() {
    if (!_isEnabled) {
      widget.onSplitChanged(null);
      return;
    }

    final controller = ref.read(sharedExpensesControllerProvider);
    Split? split;

    switch (_splitType) {
      case SplitType.equal:
        split = controller.createEqualSplit(
          widget.totalAmount,
          _selectedPersonIds,
        );
        break;
      case SplitType.percentage:
        // Por defecto, dividir equitativamente en porcentajes
        if (_selectedPersonIds.isNotEmpty) {
          final percent = 1.0 / _selectedPersonIds.length;
          split = controller.createPercentageSplit(widget.totalAmount, {
            for (var id in _selectedPersonIds) id: percent,
          });
        }
        break;
      case SplitType.fixedAmount:
        // Por defecto, dividir el monto total equitativamente
        if (_selectedPersonIds.isNotEmpty) {
          final amount = widget.totalAmount.value / _selectedPersonIds.length;
          split = controller.createFixedSplit({
            for (var id in _selectedPersonIds) id: Money(amount),
          });
        }
        break;
    }

    widget.onSplitChanged(split);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final personsAsync = ref.watch(personsProvider);

    return personsAsync.when(
      loading: () => const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (err, stack) =>
          Text('Error: $err', style: TextStyle(color: colors.error)),
      data: (persons) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isEnabled
                ? colors.primaryContainer.withValues(alpha: 0.2)
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isEnabled
                  ? colors.primary.withValues(alpha: 0.5)
                  : colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              // Header compacto
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 20,
                    color: _isEnabled
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Compartir gasto',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: _isEnabled
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: _isEnabled ? colors.primary : null,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                        // Initialize selectedPersonIds with all persons if enabling and empty
                        if (_isEnabled &&
                            (_selectedPersonIds.isEmpty ||
                                _selectedPersonIds == ['p1', 'p2'])) {
                          // Try to pick first 2 valid persons or all
                          if (persons.isNotEmpty) {
                            _selectedPersonIds = persons
                                .map((e) => e.id)
                                .toList();
                          }
                        }
                        _updateSplit();
                      });
                    },
                  ),
                ],
              ),

              // Configuración compacta (solo cuando está habilitado)
              if (_isEnabled) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Tipo de split - chips compactos
                Row(
                  children: [
                    Expanded(
                      child: _TypeChip(
                        label: 'Igual',
                        icon: Icons.balance,
                        isSelected: _splitType == SplitType.equal,
                        onTap: () {
                          setState(() {
                            _splitType = SplitType.equal;
                            _updateSplit();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TypeChip(
                        label: '%',
                        icon: Icons.percent,
                        isSelected: _splitType == SplitType.percentage,
                        onTap: () {
                          setState(() {
                            _splitType = SplitType.percentage;
                            _updateSplit();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TypeChip(
                        label: 'Fijo',
                        icon: Icons.attach_money,
                        isSelected: _splitType == SplitType.fixedAmount,
                        onTap: () {
                          setState(() {
                            _splitType = SplitType.fixedAmount;
                            _updateSplit();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Personas - chips horizontales
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: persons.map((person) {
                    final isSelected = _selectedPersonIds.contains(person.id);
                    return FilterChip(
                      label: Text(person.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPersonIds.add(person.id);
                          } else {
                            if (_selectedPersonIds.length > 1) {
                              _selectedPersonIds.remove(person.id);
                            }
                          }
                          _updateSplit();
                        });
                      },
                      avatar: isSelected
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: colors.primary,
                            )
                          : Icon(Icons.person_outline, size: 18),
                      labelStyle: theme.textTheme.bodySmall,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colors.onPrimary : colors.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
