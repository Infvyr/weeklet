import 'package:flutter_test/flutter_test.dart';
import 'package:weeklet/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter.formatCompact (UX-04)', () {
    test('formats amount >= 1000 as compact K notation', () {
      expect(NumberFormatter.formatCompact(1200.0, 'MDL'), equals('1.2K MDL'));
    });

    test('formats negative amount >= 1000 with leading minus', () {
      expect(
        NumberFormatter.formatCompact(-3500.0, 'EUR'),
        equals('-3.5K EUR'),
      );
    });

    test('delegates to formatCurrency for amount < 1000', () {
      expect(
        NumberFormatter.formatCompact(999.99, 'MDL'),
        equals('999.99 MDL'),
      );
    });
  });
}
