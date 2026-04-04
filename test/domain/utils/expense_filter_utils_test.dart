import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weeklet/core/utils/locale_manager.dart';
import 'package:weeklet/domain/utils/expense_filter_utils.dart';

void main() {
  setUpAll(() async {
    // intl DateFormat requires locale data to be initialized before use.
    // In production, flutter_localizations handles this; in tests we do it
    // explicitly for each locale we test.
    await initializeDateFormatting('en_US');
    await initializeDateFormatting('ro_RO');
    await initializeDateFormatting('ru_RU');
  });

  group('ExpenseFilterUtils.getMonthAbbreviation (ARCH-04)', () {
    test('returns English abbreviation for en_US locale', () {
      LocaleManager().initialize(const Locale('en', 'US'));
      final result = ExpenseFilterUtils.getMonthAbbreviation(1);
      expect(result, equals('Jan'));
    });

    test('returns Romanian abbreviation for ro_RO locale', () {
      LocaleManager().initialize(const Locale('ro', 'RO'));
      final result = ExpenseFilterUtils.getMonthAbbreviation(1);
      // intl DateFormat('MMM', 'ro_RO').format(DateTime(2000,1,1)) returns 'ian.'
      expect(result.toLowerCase(), startsWith('i'));
    });

    test('throws RangeError for month 0', () {
      expect(
        () => ExpenseFilterUtils.getMonthAbbreviation(0),
        throwsRangeError,
      );
    });

    test('throws RangeError for month 13', () {
      expect(
        () => ExpenseFilterUtils.getMonthAbbreviation(13),
        throwsRangeError,
      );
    });
  });
}
