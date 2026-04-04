import 'package:intl/intl.dart' show DateFormat;
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/domain/entities/expense.dart';

/// Utility class for extracting and managing expense filter options.
///
/// Provides functions to extract available years and months from a list
/// of expenses, sorted for optimal user experience.
class ExpenseFilterUtils {
  ExpenseFilterUtils._();

  /// Month names indexed by month number (1-12)
  static const List<String> kMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Extracts unique years from expenses, sorted descending (newest first).
  ///
  /// Returns at least [currentYear] if the list is empty, ensuring there's
  /// always a default year available for filtering.
  static List<int> extractAvailableYears(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return [DateTime.now().year];
    }

    final years = expenses.map((e) => e.createdAt.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a)); // Descending: newest first

    return years;
  }

  /// Extracts unique months for a given year, sorted ascending (1-12).
  ///
  /// Returns months in January-December order for the specified [year].
  /// Returns an empty list if no expenses exist for that year.
  static List<int> extractAvailableMonthsForYear(
    List<Expense> expenses,
    int year,
  ) {
    final monthsInYear =
        expenses
            .where((e) => e.createdAt.year == year)
            .map((e) => e.createdAt.month)
            .toSet()
            .toList()
          ..sort(); // Ascending: 1-12 (Jan-Dec)

    return monthsInYear;
  }

  /// Gets the month name for a given month number (1-12).
  ///
  /// Returns the full month name (e.g., "January", "February").
  /// Throws [RangeError] if month is not between 1-12.
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw RangeError.range(month, 1, 12, 'month');
    }
    return kMonthNames[month - 1];
  }

  /// Gets the locale-aware abbreviated month name for a given month number (1-12).
  ///
  /// Returns the abbreviated month name for the current device locale
  /// (e.g., 'Jan' for en_US, 'ian.' for ro_RO, 'янв.' for ru_RU).
  /// Relies on [LocaleManager] having set [Intl.defaultLocale] at startup.
  /// Throws [RangeError] if month is not between 1-12.
  static String getMonthAbbreviation(int month) {
    if (month < 1 || month > 12) {
      throw RangeError.range(month, 1, 12, 'month');
    }
    final locale = LocaleManager().currentLocaleString;
    // Use locale as explicit argument — LocaleManager.initialize sets
    // Intl.defaultLocale which registers the locale for intl formatting.
    return DateFormat('MMM', locale).format(DateTime(2000, month, 1));
  }
}
