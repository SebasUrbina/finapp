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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'Fecha',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showDatePicker(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _formatDate(selectedDate),
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickDateButton(
                label: 'Hoy',
                isSelected: _isToday(selectedDate),
                onTap: () => onChanged(DateTime.now()),
                colors: colors,
              ),
              const SizedBox(width: 8),
              _QuickDateButton(
                label: 'Ayer',
                isSelected: _isYesterday(selectedDate),
                onTap: () =>
                    onChanged(DateTime.now().subtract(const Duration(days: 1))),
                colors: colors,
              ),
              const SizedBox(width: 8),
              _QuickDateButton(
                label: 'Hace 2 días',
                isSelected: _isDaysAgo(selectedDate, 2),
                onTap: () =>
                    onChanged(DateTime.now().subtract(const Duration(days: 2))),
                colors: colors,
              ),
            ],
          ),
        ],
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

  bool _isDaysAgo(DateTime date, int days) {
    final target = DateTime.now().subtract(Duration(days: days));
    return date.year == target.year &&
        date.month == target.month &&
        date.day == target.day;
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colors;

  const _QuickDateButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? colors.onPrimary : colors.onSurface,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
