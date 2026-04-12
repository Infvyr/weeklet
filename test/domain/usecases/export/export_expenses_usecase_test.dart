import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/usecases/export/export_expenses_usecase.dart';

class _FakePathProvider
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getApplicationSupportPath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getApplicationCachePath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getDownloadsPath() async => null;

  @override
  Future<List<String>?> getExternalCachePaths() async => null;

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async => null;

  @override
  Future<String?> getExternalStoragePath() async => null;

  @override
  Future<String?> getLibraryPath() async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getTemporaryDirectory') {
              return Directory.systemTemp.path;
            }
            return null;
          },
        );
  });

  group('ExportExpensesUseCase', () {
    late ExportExpensesUseCase useCase;

    setUp(() {
      useCase = const ExportExpensesUseCase();
    });

    test('returns a pdf file path when given a non-empty expense list',
        () async {
      final expenses = [
        Expense(
          id: 'exp-1',
          amount: 100.0,
          description: 'Groceries',
          categoryId: 'cat-uuid-1',
          createdAt: DateTime(2026, 4, 5),
        ),
        Expense(
          id: 'exp-2',
          amount: 50.50,
          description: 'Coffee',
          categoryId: 'cat-uuid-1',
          createdAt: DateTime(2026, 4, 10),
        ),
      ];
      final categories = [
        Category(
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

    test('completes without exception for multiple expenses with totals',
        () async {
      final expenses = [
        Expense(
          id: 'e1',
          amount: 100.0,
          description: 'Item A',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 1),
        ),
        Expense(
          id: 'e2',
          amount: 50.50,
          description: 'Item B',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 2),
        ),
        Expense(
          id: 'e3',
          amount: 25.00,
          description: '',
          categoryId: 'c1',
          createdAt: DateTime(2026, 4, 3),
        ),
      ];
      final categories = [
        Category(
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

    test('resolves category name from List<Category> using categoryId',
        () async {
      const categoryId = 'cat-uuid-123';
      final expense = Expense(
        id: 'exp-x',
        amount: 75.0,
        description: 'Dinner',
        categoryId: categoryId,
        createdAt: DateTime(2026, 4, 15),
      );
      final categories = [
        Category(
          id: categoryId,
          name: 'Food',
          icon: '',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final result = await useCase(
        ExportExpensesParams(
          expenses: [expense],
          categories: categories,
          currencySymbol: 'MDL',
          year: 2026,
          month: 4,
        ),
      );

      expect(result, isA<String>());
      expect(result.endsWith('.pdf'), isTrue);
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
