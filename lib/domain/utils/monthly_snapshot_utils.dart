/// Utility class for monthly snapshot formatting and calculations
class MonthlySnapshotUtils {
  MonthlySnapshotUtils._();

  /// Formats balance text with proper sign and currency
  /// Returns text like "Sold: +2081 lei" or "Sold: -500 lei"
  static String formatBalanceText(double balance) {
    final sign = balance >= 0 ? '+' : '';
    final amount = balance.toStringAsFixed(0);
    return 'Sold: $sign$amount lei';
  }

  /// Determines if balance is positive (should show in success color)
  static bool isBalancePositive(double balance) => balance >= 0;
}
