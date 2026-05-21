import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/domain/usecases/export/export_expenses_usecase.dart';
import 'package:weeklet/domain/usecases/export/export_income_usecase.dart';
import 'package:weeklet/presentation/blocs/export/export_bloc.dart';
import 'package:weeklet/presentation/blocs/export/export_event.dart';
import 'package:weeklet/presentation/blocs/export/export_state.dart';

// Stub use cases — no PDF generation, no filesystem access.
// Subclass the concrete use cases so they satisfy typed constructor parameters.
class _StubExportExpensesUseCase extends ExportExpensesUseCase {
  _StubExportExpensesUseCase({this.shouldThrow = false});

  final bool shouldThrow;

  @override
  Future<String> call(ExportExpensesParams params) async {
    if (shouldThrow) throw Exception('export failed');
    return '/tmp/weeklet_expenses_january_2024.pdf';
  }
}

class _StubExportIncomeUseCase extends ExportIncomeUseCase {
  _StubExportIncomeUseCase({this.shouldThrow = false});

  final bool shouldThrow;

  @override
  Future<String> call(ExportIncomeParams params) async {
    if (shouldThrow) throw Exception('export failed');
    return '/tmp/weeklet_income_january_2024.pdf';
  }
}

// Shared fixtures
final _fakeExpenses = <Expense>[
  Expense(
    id: 'e-1',
    amount: 50.0,
    description: 'Groceries',
    categoryId: 'cat-1',
    createdAt: DateTime(2024, 1, 10),
  ),
];

final _fakeCategories = <Category>[
  Category(
    id: 'cat-1',
    name: 'Food',
    icon: '🍎',
    createdAt: DateTime(2024, 1, 1),
  ),
];

final _fakeIncomes = <Income>[
  Income(
    id: 'i-1',
    amount: 2000.0,
    description: 'Salary',
    date: DateTime(2024, 1, 5),
    createdAt: DateTime(2024, 1, 5),
  ),
];

ExportBloc _makeBloc({
  bool expensesThrows = false,
  bool incomeThrows = false,
}) => ExportBloc(
  exportExpensesUseCase: _StubExportExpensesUseCase(shouldThrow: expensesThrows),
  exportIncomeUseCase: _StubExportIncomeUseCase(shouldThrow: incomeThrows),
);

void main() {
  setUpAll(() async {
    // ExportBloc uses DateFormat.yMMMM('en') to build the subject string.
    // intl locale data must be initialized before tests run.
    await initializeDateFormatting('en');
  });

  group('ExportBloc', () {
    test('initial state is ExportInitial', () {
      final bloc = _makeBloc();
      expect(bloc.state, const ExportInitial());
      bloc.close();
    });

    blocTest<ExportBloc, ExportState>(
      'ExportExpensesStarted success emits [ExportInProgress, ExportSuccess]'
          ' with correct filePath, exportType and subject',
      build: _makeBloc,
      act: (bloc) => bloc.add(
        ExportExpensesStarted(
          expenses: _fakeExpenses,
          categories: _fakeCategories,
          currencySymbol: r'$',
          year: 2024,
          month: 1,
        ),
      ),
      expect: () => [
        const ExportInProgress(),
        isA<ExportSuccess>()
            .having(
              (s) => s.filePath,
              'filePath',
              contains('weeklet_expenses'),
            )
            .having(
              (s) => s.exportType,
              'exportType',
              ExportType.expenses,
            )
            .having(
              (s) => s.subject,
              'subject',
              contains('Weeklet'),
            ),
      ],
    );

    blocTest<ExportBloc, ExportState>(
      'ExportExpensesStarted failure emits [ExportInProgress, ExportFailure]',
      build: () => _makeBloc(expensesThrows: true),
      act: (bloc) => bloc.add(
        ExportExpensesStarted(
          expenses: _fakeExpenses,
          categories: _fakeCategories,
          currencySymbol: r'$',
          year: 2024,
          month: 1,
        ),
      ),
      expect: () => [
        const ExportInProgress(),
        isA<ExportFailure>(),
      ],
    );

    blocTest<ExportBloc, ExportState>(
      'ExportIncomeStarted success emits [ExportInProgress, ExportSuccess]'
          ' with exportType == income',
      build: _makeBloc,
      act: (bloc) => bloc.add(
        ExportIncomeStarted(
          incomes: _fakeIncomes,
          currencySymbol: r'$',
          year: 2024,
          month: 1,
        ),
      ),
      expect: () => [
        const ExportInProgress(),
        isA<ExportSuccess>()
            .having(
              (s) => s.exportType,
              'exportType',
              ExportType.income,
            )
            .having(
              (s) => s.subject,
              'subject',
              contains('Weeklet'),
            ),
      ],
    );

    blocTest<ExportBloc, ExportState>(
      'ExportIncomeStarted failure emits [ExportInProgress, ExportFailure]',
      build: () => _makeBloc(incomeThrows: true),
      act: (bloc) => bloc.add(
        ExportIncomeStarted(
          incomes: _fakeIncomes,
          currencySymbol: r'$',
          year: 2024,
          month: 1,
        ),
      ),
      expect: () => [
        const ExportInProgress(),
        isA<ExportFailure>(),
      ],
    );

    blocTest<ExportBloc, ExportState>(
      'ResetExportRequested from ExportSuccess seed emits [ExportInitial]',
      build: _makeBloc,
      seed: () => const ExportSuccess(
        filePath: '/tmp/test.pdf',
        subject: 'Weeklet Expense Report — January 2024',
        exportType: ExportType.expenses,
      ),
      act: (bloc) => bloc.add(const ResetExportRequested()),
      expect: () => [const ExportInitial()],
    );
  });
}
