import 'package:flutter/material.dart';

class RecurringToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RecurringToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Gasto recurrente'),
      subtitle: const Text('Se repetirá automáticamente'),
      value: value,
      onChanged: onChanged,
    );
  }
}
