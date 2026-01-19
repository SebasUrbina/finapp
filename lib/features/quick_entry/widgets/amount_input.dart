import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class AmountInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const AmountInput({super.key, required this.value, required this.onChanged});

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializar con el valor formateado
    final initialText = widget.value > 0 ? widget.value.toFormatted() : '';
    _controller = TextEditingController(text: initialText);
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
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: colors.primary,
      ),
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.3)),
        prefixText: r'$',
        prefixStyle: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
        border: InputBorder.none,
      ),
      onChanged: (v) {
        if (v.isEmpty) {
          widget.onChanged(0);
          return;
        }

        final parsed = CurrencyFormatter.parse(v);
        widget.onChanged(parsed);

        // Formatear mientras se escribe
        final formatted = parsed.toFormatted();
        if (v != formatted) {
          _controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
    );
  }
}
