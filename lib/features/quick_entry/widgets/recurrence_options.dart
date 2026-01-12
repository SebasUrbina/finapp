import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

class RecurrenceOptions extends StatelessWidget {
  final RecurrenceFrequency frequency;
  final int interval;
  final int dayOfMonth;
  final void Function(RecurrenceFrequency, int, int) onChanged;

  const RecurrenceOptions({
    super.key,
    required this.frequency,
    required this.interval,
    required this.dayOfMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecurrenceFrequencySelector(
          selected: frequency,
          onChanged: (f) => onChanged(f, interval, dayOfMonth),
        ),
        IntervalSelector(
          value: interval,
          onChanged: (i) => onChanged(frequency, i, dayOfMonth),
        ),
        if (frequency == RecurrenceFrequency.monthly)
          DayOfMonthSelector(
            value: dayOfMonth,
            onChanged: (d) => onChanged(frequency, interval, d),
          ),
      ],
    );
  }
}

class RecurrenceFrequencySelector extends StatelessWidget {
  final RecurrenceFrequency selected;
  final ValueChanged<RecurrenceFrequency> onChanged;

  const RecurrenceFrequencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: RecurrenceFrequency.values.map((f) {
        return ChoiceChip(
          label: Text(f.name),
          selected: selected == f,
          onSelected: (_) => onChanged(f),
        );
      }).toList(),
    );
  }
}

class IntervalSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const IntervalSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Cada'),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        Text('$value'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class DayOfMonthSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DayOfMonthSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Día del mes'),
        Slider(
          min: 1,
          max: 30,
          divisions: 29,
          value: value.toDouble(),
          label: value.toString(),
          onChanged: (v) => onChanged(v.toInt()),
        ),
      ],
    );
  }
}
