import 'package:flutter/material.dart';

class DescriptionInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const DescriptionInput({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Descripción...',
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.4)),
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          Icons.description_outlined,
          color: colors.primary.withValues(alpha: 0.7),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
