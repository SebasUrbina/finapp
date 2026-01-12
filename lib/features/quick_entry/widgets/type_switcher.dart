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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment<TransactionType>(
                value: TransactionType.expense,
                label: Text('Gasto'),
              ),
              ButtonSegment<TransactionType>(
                value: TransactionType.income,
                label: Text('Ingreso'),
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
