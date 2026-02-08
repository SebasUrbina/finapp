import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ParticipantPicker extends ConsumerStatefulWidget {
  final List<String> selectedPersonIds;
  final SplitType splitType;
  final Money totalAmount;
  final Function(List<String>, Map<String, double>) onChanged;

  const ParticipantPicker({
    super.key,
    required this.selectedPersonIds,
    required this.splitType,
    required this.totalAmount,
    required this.onChanged,
  });

  @override
  ConsumerState<ParticipantPicker> createState() => _ParticipantPickerState();
}

class _ParticipantPickerState extends ConsumerState<ParticipantPicker> {
  late Map<String, double> _values;
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _values = {};
    _controllers = {};
    _initializeValues();
  }

  void _initializeValues() {
    for (final personId in widget.selectedPersonIds) {
      if (widget.splitType == SplitType.equal) {
        final equalShare =
            widget.totalAmount.value / widget.selectedPersonIds.length;
        _values[personId] = equalShare;
      } else if (widget.splitType == SplitType.percentage) {
        _values[personId] = 0.5; // Default 50%
      } else {
        _values[personId] = 0;
      }

      _controllers[personId] = TextEditingController(
        text: widget.splitType == SplitType.percentage
            ? '${(_values[personId]! * 100).toStringAsFixed(0)}'
            : _values[personId]!.toStringAsFixed(0),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final personsAsync = ref.watch(personsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participantes',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // List of available persons
        personsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error loading persons: $err'),
          data: (persons) => Column(
            children: [
              ...persons.map((person) {
                final isSelected = widget.selectedPersonIds.contains(person.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primaryContainer.withValues(alpha: 0.3)
                          : theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : colors.outlineVariant.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            // Create new list instead of mutating
                            final newPersonIds = [
                              ...widget.selectedPersonIds,
                              person.id,
                            ];
                            _initializeValues();
                            widget.onChanged(newPersonIds, _values);
                          } else {
                            // Create new list without the removed person
                            final newPersonIds = widget.selectedPersonIds
                                .where((id) => id != person.id)
                                .toList();
                            _values.remove(person.id);
                            _controllers[person.id]?.dispose();
                            _controllers.remove(person.id);
                            widget.onChanged(newPersonIds, _values);
                          }
                        });
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
                          isSelected && widget.splitType != SplitType.equal
                          ? _buildValueInput(person.id, colors, theme)
                          : null,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          color: colors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Add person button
        OutlinedButton.icon(
          onPressed: () => _showAddPersonDialog(context),
          icon: const Icon(Icons.person_add_outlined),
          label: const Text('Agregar persona'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
          ),
        ),
      ],
    );
  }

  Widget _buildValueInput(
    String personId,
    ColorScheme colors,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controllers[personId],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: widget.splitType == SplitType.percentage
                    ? '%'
                    : '\$',
              ),
              onChanged: (value) {
                final numValue = double.tryParse(value) ?? 0;
                setState(() {
                  if (widget.splitType == SplitType.percentage) {
                    _values[personId] = numValue / 100;
                  } else {
                    _values[personId] = numValue;
                  }
                  widget.onChanged(widget.selectedPersonIds, _values);
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.splitType == SplitType.percentage
                ? '\$${(widget.totalAmount.value * (_values[personId] ?? 0)).toCurrency()}'
                : '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar persona'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ej: Juan Pérez',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                final person = Person(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                );
                await ref.read(personsProvider.notifier).addPerson(person);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
