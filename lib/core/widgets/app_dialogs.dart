import 'package:flutter/material.dart';

class AppDeleteDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onConfirm;

  const AppDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
