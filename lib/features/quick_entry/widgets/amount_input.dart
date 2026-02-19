import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class AmountInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  /// Maximum allowed amount (defaults to 999,999,999)
  final double maxAmount;

  const AmountInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxAmount = 999999999,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: _errorText != null ? colors.error : colors.primary,
          ),
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.3),
            ),
            prefixText: r'$',
            prefixStyle: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _errorText != null ? colors.error : colors.primary,
            ),
            border: InputBorder.none,
          ),
          onChanged: (v) {
            if (v.isEmpty) {
              widget.onChanged(0);
              setState(() => _errorText = null);
              return;
            }

            final parsed = CurrencyFormatter.parse(v);

            if (parsed > widget.maxAmount) {
              // Clamp to max and show error
              widget.onChanged(widget.maxAmount);
              final formatted = widget.maxAmount.toFormatted();
              _controller.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
              setState(
                () =>
                    _errorText = 'Máximo: \$${widget.maxAmount.toFormatted()}',
              );
              return;
            }

            setState(() => _errorText = null);
            widget.onChanged(parsed);

            // Format while typing
            final formatted = parsed.toFormatted();
            if (v != formatted) {
              _controller.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          },
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }
}
