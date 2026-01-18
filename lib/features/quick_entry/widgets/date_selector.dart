import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _QuickDateChip(
              label: 'Hoy',
              isSelected: _isToday(selectedDate),
              onTap: () => onChanged(DateTime.now()),
              colors: colors,
            ),
            const SizedBox(width: 8),
            _QuickDateChip(
              label: 'Ayer',
              isSelected: _isYesterday(selectedDate),
              onTap: () =>
                  onChanged(DateTime.now().subtract(const Duration(days: 1))),
              colors: colors,
            ),
            const SizedBox(width: 8),
            _QuickDateChip(
              label: _isToday(selectedDate) || _isYesterday(selectedDate)
                  ? _formatDate(selectedDate)
                  : DateFormat('d MMM', 'es').format(selectedDate),
              isSelected:
                  !_isToday(selectedDate) && !_isYesterday(selectedDate),
              onTap: () => _showDatePicker(context),
              colors: colors,
              icon: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: Theme.of(context).colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Ayer';
    } else {
      return DateFormat('d MMM', 'es').format(date);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}

class _QuickDateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colors;
  final IconData? icon;

  const _QuickDateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: isSelected ? colors.onPrimary : colors.primary,
            ),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colors.primary,
      checkmarkColor: colors.onPrimary,
      labelStyle: TextStyle(
        color: isSelected ? colors.onPrimary : colors.onSurface,
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? colors.primary
              : colors.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
