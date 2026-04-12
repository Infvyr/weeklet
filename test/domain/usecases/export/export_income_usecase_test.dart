import 'package:flutter_test/flutter_test.dart';
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/domain/usecases/export/export_income_usecase.dart';

void main() {
  group('ExportIncomeUseCase', () {
    late ExportIncomeUseCase useCase;

    setUp(() {
      useCase = ExportIncomeUseCase();
    });

    test('returns a pdf file path when given a non-empty income list', () async {
      final incomes = [
        const Income(
          id: 'inc-1',
          amount: 200.0,
          description: 'Salary',
          date: DateTime(2026, 4, 1),
          createdAt: DateTime(2026, 4, 1),
        ),
        const Income(
          id: 'inc-2',
          amount: 150.75,
          description: 'Freelance',
          date: DateTime(2026, 4, 15),
          createdAt: DateTime(2026, 4, 15),
        ),
      ];

      final result = await useCase(
        ExportIncomeParams(
          incomes: incomes,
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result.endsWith('.pdf'), isTrue);
    });

    test('completes without exception for income with empty description', () async {
      final incomes = [
        const Income(
          id: 'inc-3',
          amount: 500.0,
          description: '',
          date: DateTime(2026, 4, 5),
          createdAt: DateTime(2026, 4, 5),
        ),
      ];

      final result = await useCase(
        ExportIncomeParams(
          incomes: incomes,
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });

    test('handles empty income list without throwing', () async {
      final result = await useCase(
        const ExportIncomeParams(
          incomes: [],
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result.endsWith('.pdf'), isTrue);
    });
  });
}
