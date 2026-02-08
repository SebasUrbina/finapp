import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/shared_expenses/widgets/split_configurator.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitToggleSection extends ConsumerStatefulWidget {
  final Money totalAmount;
  final Split? initialSplit;
  final Function(Split?) onSplitChanged;

  const SplitToggleSection({
    super.key,
    required this.totalAmount,
    this.initialSplit,
    required this.onSplitChanged,
  });

  @override
  ConsumerState<SplitToggleSection> createState() => _SplitToggleSectionState();
}

class _SplitToggleSectionState extends ConsumerState<SplitToggleSection> {
  late bool _isEnabled;
  Split? _currentSplit;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialSplit != null;
    _currentSplit = widget.initialSplit;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle header
        Container(
          decoration: BoxDecoration(
            color: _isEnabled
                ? colors.primaryContainer.withValues(alpha: 0.3)
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isEnabled
                  ? colors.primary
                  : colors.outlineVariant.withValues(alpha: 0.3),
              width: _isEnabled ? 2 : 1,
            ),
          ),
          child: SwitchListTile(
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
                if (!value) {
                  _currentSplit = null;
                  widget.onSplitChanged(null);
                }
              });
            },
            title: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 20,
                  color: _isEnabled ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  'Compartir gasto',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: _isEnabled ? FontWeight.bold : FontWeight.w500,
                    color: _isEnabled ? colors.primary : null,
                  ),
                ),
              ],
            ),
            subtitle: _isEnabled
                ? null
                : Text(
                    'Divide este gasto con otras personas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
          ),
        ),

        // Configurator (expanded when enabled)
        if (_isEnabled) ...[
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SplitConfigurator(
              totalAmount: widget.totalAmount,
              initialSplit: _currentSplit,
              onSplitChanged: (split) {
                setState(() {
                  _currentSplit = split;
                  widget.onSplitChanged(split);
                });
              },
            ),
          ),
        ],
      ],
    );
  }
}
