import 'package:finapp/domain/models/finance_models.dart';
import 'package:intl/intl.dart';

/// Formatter for currency values
class CurrencyFormatter {
  static final _currencyFormat = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 0,
    locale: 'es_CL',
  );

  static final _numberFormat = NumberFormat.decimalPattern('es_CL');

  static String formatDouble(double value) {
    return _currencyFormat.format(value);
  }

  static String formatMoney(Money money) {
    return _currencyFormat.format(money.value);
  }

  static String formatDoubleNoSymbol(double value) {
    return _numberFormat.format(value);
  }

  /// Removes all non-digit characters
  static double parse(String value) {
    if (value.isEmpty) return 0.0;
    // Remove everything that isn't a digit
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanValue) ?? 0.0;
  }
}


extension MoneyCurrencyExtension on Money {
  String toCurrency() => CurrencyFormatter.formatMoney(this);
}

/// Extension for double to currency formatting
extension DoubleCurrencyExtension on double {
  String toCurrency() => CurrencyFormatter.formatDouble(this);
  String toFormatted() => CurrencyFormatter.formatDoubleNoSymbol(this);
}
