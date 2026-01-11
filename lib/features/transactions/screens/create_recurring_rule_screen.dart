import 'package:flutter/material.dart';

class RecurringRuleScreen extends StatelessWidget {
  const RecurringRuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Regla Recurrente")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // Wrap(
            //   spacing: 8,
            //   children: RecurrenceFrequency.values.map((f) {
            //     return FrequencyChip(
            //       frequency: f,
            //       selected: false,
            //       onTap: () {},
            //     );
            //   }).toList(),
            // ),
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
