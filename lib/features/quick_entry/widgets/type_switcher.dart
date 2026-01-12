import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

class TransactionTypeSwitcher extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SegmentedButton<TransactionType>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<TransactionType>(
                value: TransactionType.expense,
                label: Text('Gasto'),
                icon: Icon(Icons.arrow_downward, size: 24),
              ),
              ButtonSegment<TransactionType>(
                value: TransactionType.income,
                label: Text('Ingreso'),
                icon: Icon(Icons.arrow_upward, size: 24),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (v) => onChanged(v.first),
          ),
        ),
      ],
    );
  }
}
