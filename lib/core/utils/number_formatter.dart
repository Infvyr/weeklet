import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  /// Formats a currency amount with specified decimal places
  ///
  /// Example:
  /// ```dart
  /// formatCurrency(105.19, 'lei') // "105.19 lei"
  /// formatCurrency(144.6543, 'USD', decimals: 2) // "144.65 USD"
  /// ```
  static String formatCurrency(
    double amount,
    String currencySymbol, {
    int decimals = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
      locale: locale,
    );
    final formattedAmount = formatter.format(amount.abs()).trim();
    return '$formattedAmount $currencySymbol';
  }

  /// Formats a currency amount with income/expense indicator
  ///
  /// Example:
  /// ```dart
  /// formatCurrencyWithSign(105.19, 'lei', isIncome: false) // "105.19 lei"
  /// formatCurrencyWithSign(39.98, 'lei', isIncome: true) // "+39.98 lei"
  /// ```
  static String formatCurrencyWithSign(
    double amount,
    String currencySymbol, {
    bool isIncome = false,
    int decimals = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
      locale: locale,
    );
    final formattedAmount = formatter.format(amount.abs()).trim();
    final sign = isIncome ? '+' : '';
    return '$sign$formattedAmount $currencySymbol';
  }

  /// Formats a currency amount compactly — values >= 1000 are abbreviated.
  ///
  /// Example:
  /// ```dart
  /// formatCompact(1200.0, 'MDL')   // "1.2K MDL"
  /// formatCompact(-3500.0, 'EUR')  // "-3.5K EUR"
  /// formatCompact(999.99, 'MDL')   // "999.99 MDL"
  /// ```
  static String formatCompact(double amount, String currencySymbol) {
    if (amount.abs() >= 1000) {
      final sign = amount < 0 ? '-' : '';
      final compact = (amount.abs() / 1000).toStringAsFixed(1);
      return '$sign${compact}K $currencySymbol';
    }
    return formatCurrency(amount, currencySymbol);
  }

  /// Formats time from DateTime to HH:mm format
  ///
  /// Example:
  /// ```dart
  /// formatTime(DateTime(2026, 1, 27, 15, 34)) // "15:34"
  /// ```
  static String formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
}
