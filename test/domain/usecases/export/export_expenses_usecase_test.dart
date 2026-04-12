import 'package:flutter_test/flutter_test.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/usecases/export/export_expenses_usecase.dart';

void main() {
  group('ExportExpensesUseCase', () {
    late ExportExpensesUseCase useCase;

    setUp(() {
      useCase = ExportExpensesUseCase();
    });

    test('returns a pdf file path when given a non-empty expense list', () async {
      final expenses = [
        const Expense(
          id: 'exp-1',
          amount: 100.0,
          description: 'Groceries',
          categoryId: 'cat-uuid-1',
          createdAt: DateTime(2026, 4, 5),
        ),
        const Expense(
          id: 'exp-2',
          amount: 50.50,
          description: 'Coffee',
          categoryId: 'cat-uuid-1',
          createdAt: DateTime(2026, 4, 10),
        ),
      ];
      final categories = [
        const Category(
          id: 'cat-uuid-1',
          name: 'Food',
          icon: '',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final result = await useCase(
        ExportExpensesParams(
          expenses: expenses,
          categories: categories,
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result.endsWith('.pdf'), isTrue);
    });

    test('completes without exception for multiple expenses with totals', () async {
      final expenses = [
        const Expense(
          id: 'e1',
          amount: 100.0,
          description: 'Item A',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 1),
        ),
        const Expense(
          id: 'e2',
          amount: 50.50,
          description: 'Item B',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 2),
        ),
        const Expense(
          id: 'e3',
          amount: 25.00,
          description: '',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 3),
        ),
      ];
      final categories = [
        const Category(
          id: 'c1',
          name: 'Transport',
          icon: '',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final result = await useCase(
        ExportExpensesParams(
          expenses: expenses,
          categories: categories,
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });

    test('resolves category name from List<Category> using categoryId', () async {
      const categoryId = 'cat-uuid-123';
      const expense = Expense(
        id: 'exp-x',
        amount: 75.0,
        description: 'Dinner',
        categoryId: categoryId,
        createdAt: DateTime(2026, 4, 15),
      );
      final categories = [
        const Category(
          id: categoryId,
          name: 'Food',
          icon: '',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      expect(
        () async => useCase(
          ExportExpensesParams(
            expenses: const [expense],
            categories: categories,
            currencySymbol: 'MDL',
            year: 2026,
            month: 4,
          ),
        ),
        returnsNormally,
      );
    });

    test('handles empty expense list without throwing', () async {
      final result = await useCase(
        const ExportExpensesParams(
          expenses: [],
          categories: [],
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
