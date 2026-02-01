import 'package:flutter/material.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';

DateTimeRange buildRange(DateTime date, PeriodFilter period) {
  switch (period) {
    case PeriodFilter.year:
      return DateTimeRange(
        start: DateTime(date.year, 1, 1),
        end: DateTime(date.year, 12, 31, 23, 59, 59),
      );

    case PeriodFilter.month:
      return DateTimeRange(
        start: DateTime(date.year, date.month, 1),
        end: DateTime(date.year, date.month + 1, 0, 23, 59, 59),
      );

    case PeriodFilter.week:
      final monday = date.subtract(Duration(days: date.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      return DateTimeRange(
        start: DateTime(monday.year, monday.month, monday.day),
        end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
      );
  }
}

DateTimeRange buildPreviousRange(DateTime date, PeriodFilter period) {
  switch (period) {
    case PeriodFilter.year:
      return DateTimeRange(
        start: DateTime(date.year - 1, 1, 1),
        end: DateTime(date.year - 1, 12, 31, 23, 59, 59),
      );

    case PeriodFilter.month:
      return DateTimeRange(
        start: DateTime(date.year, date.month - 1, 1),
        end: DateTime(date.year, date.month, 0, 23, 59, 59),
      );

    case PeriodFilter.week:
      final monday = date.subtract(Duration(days: date.weekday - 1 + 7));
      final sunday = monday.add(const Duration(days: 6));
      return DateTimeRange(
        start: DateTime(monday.year, monday.month, monday.day),
        end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
      );
  }
}

bool isWithin(DateTime date, DateTimeRange range) {
  return !date.isBefore(range.start) && !date.isAfter(range.end);
}
