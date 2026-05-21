import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/domain/exceptions/income_exceptions.dart';
import 'package:weeklet/domain/usecases/income/add_income_use_case.dart';
import 'package:weeklet/domain/usecases/income/delete_income_use_case.dart';
import 'package:weeklet/domain/usecases/income/get_incomes_use_case.dart';
import 'package:weeklet/domain/usecases/income/update_income_use_case.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import '../../../helpers/fake_blocs.dart';

// ---------------------------------------------------------------------------
// File-private stubs
// ---------------------------------------------------------------------------

// Plain class stubs — no UseCase<T,P> interface (per codebase inconsistency).
// noSuchMethod satisfies the concrete class `repository` field constraint.

class _StubGetIncomesUseCase implements GetIncomesUseCase {
  List<Income> returnValue = const [];
  bool shouldThrow = false;

  @override
  Future<List<Income>> call() async {
    if (shouldThrow) throw Exception('load error');
    return returnValue;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubUpdateIncomeUseCase implements UpdateIncomeUseCase {
  bool shouldThrow = false;

  @override
  Future<void> call(Income params) async {
    if (shouldThrow) throw Exception('update error');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubDeleteIncomeUseCase implements DeleteIncomeUseCase {
  bool shouldThrow = false;

  @override
  Future<void> call(String id) async {
    if (shouldThrow) throw Exception('delete error');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// AddIncomeUseCase implements UseCase<void, AddIncomeParams>.
class _StubAddIncomeUseCase implements AddIncomeUseCase {
  bool shouldThrow = false;
  Object? throwable;

  @override
  Future<void> call(AddIncomeParams params) async {
    if (shouldThrow) throw throwable ?? Exception('add error');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Income _fakeIncome({String id = 'inc-1'}) => Income(
  id: id,
  amount: 500.0,
  description: 'Salary',
  date: DateTime(DateTime.now().year, 5, 1),
  createdAt: DateTime(DateTime.now().year, 5, 1),
);

IncomeSuccess _successSeed({List<Income>? incomes}) {
  final list = incomes ?? [_fakeIncome()];
  return IncomeSuccess(
    allIncomes: list,
    filteredIncomes: list,
    selectedYear: DateTime.now().year,
    selectedMonth: null,
    availableYears: [DateTime.now().year],
    availableMonths: const [5],
  );
}

// ---------------------------------------------------------------------------
// Shared stub references (reset in each group's setUp)
// ---------------------------------------------------------------------------

late _StubAddIncomeUseCase _stubAdd;
late _StubUpdateIncomeUseCase _stubUpdate;
late _StubDeleteIncomeUseCase _stubDelete;
late _StubGetIncomesUseCase _stubGet;

IncomeBloc _makeBloc() => IncomeBloc(
  addIncomeUseCase: _stubAdd,
  updateIncomeUseCase: _stubUpdate,
  deleteIncomeUseCase: _stubDelete,
  getIncomesUseCase: _stubGet,
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('IncomeBloc — initial state', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    test('initial state is IncomeInitial', () {
      final bloc = _makeBloc();
      addTearDown(bloc.close);
      expect(bloc.state, const IncomeInitial());
    });
  });

  group('IncomeBloc — load', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'emits IncomeLoading then IncomeSuccess on success',
      setUp: () => _stubGet.returnValue = [_fakeIncome()],
      build: _makeBloc,
      act: (bloc) => bloc.add(const LoadIncomesRequested()),
      expect: () => [const IncomeLoading(), isA<IncomeSuccess>()],
      verify: (bloc) {
        expect((bloc.state as IncomeSuccess).allIncomes.length, 1);
      },
    );

    blocTest<IncomeBloc, IncomeState>(
      'emits IncomeLoading then IncomeFailure when stub throws',
      setUp: () => _stubGet.shouldThrow = true,
      build: _makeBloc,
      act: (bloc) => bloc.add(const LoadIncomesRequested()),
      expect: () => [const IncomeLoading(), isA<IncomeFailure>()],
    );
  });

  group('IncomeBloc — filter', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'IncomeFilterDateChanged by year filters incomes',
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) =>
          bloc.add(IncomeFilterDateChanged(year: DateTime.now().year)),
      expect: () => [isA<IncomeSuccess>()],
      verify: (bloc) {
        final s = bloc.state as IncomeSuccess;
        expect(s.filteredIncomes, isNotEmpty);
      },
    );

    blocTest<IncomeBloc, IncomeState>(
      'IncomeFilterDateChanged by month filters to that month',
      build: _makeBloc,
      seed: () => _successSeed(incomes: [_fakeIncome()]),
      act: (bloc) => bloc.add(const IncomeFilterDateChanged(month: 5)),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.selectedMonth,
          'selectedMonth',
          5,
        ),
      ],
    );

    blocTest<IncomeBloc, IncomeState>(
      'IncomeFilterDateChanged does nothing when not in IncomeSuccess',
      build: _makeBloc,
      act: (bloc) => bloc.add(const IncomeFilterDateChanged(year: 2025)),
      expect: () => <IncomeState>[],
    );
  });

  group('IncomeBloc — add', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'AddIncomeStarted in IncomeSuccess triggers reload',
      setUp: () {
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
        _stubGet.returnValue = [_fakeIncome()];
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(
        AddIncomeStarted(
          amount: '500.00',
          description: 'Salary',
          date: DateTime(DateTime.now().year, 5, 1),
        ),
      ),
      expect: () => [const IncomeLoading(), isA<IncomeSuccess>()],
      tearDown: () async => GetIt.instance.reset(),
    );

    blocTest<IncomeBloc, IncomeState>(
      'AddIncomeStarted validation exception sets actionError',
      setUp: () {
        _stubAdd.shouldThrow = true;
        _stubAdd.throwable = const IncomeValidationException(
          IncomeValidationError.emptyDescription,
        );
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(
        AddIncomeStarted(
          amount: '500.00',
          description: '',
          date: DateTime(DateTime.now().year, 5, 1),
        ),
      ),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.actionError,
          'actionError',
          'emptyDescription',
        ),
      ],
      tearDown: () async => GetIt.instance.reset(),
    );

    blocTest<IncomeBloc, IncomeState>(
      'AddIncomeStarted generic exception sets actionError to genericError',
      setUp: () {
        _stubAdd.shouldThrow = true;
        _stubAdd.throwable = Exception('boom');
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(
        AddIncomeStarted(
          amount: '500.00',
          description: 'Salary',
          date: DateTime(DateTime.now().year, 5, 1),
        ),
      ),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.actionError,
          'actionError',
          'genericError',
        ),
      ],
      tearDown: () async => GetIt.instance.reset(),
    );

    blocTest<IncomeBloc, IncomeState>(
      'AddIncomeStarted silently ignored when not in IncomeSuccess',
      build: _makeBloc,
      act: (bloc) => bloc.add(
        AddIncomeStarted(
          amount: '500.00',
          description: 'Salary',
          date: DateTime(DateTime.now().year, 5, 1),
        ),
      ),
      expect: () => <IncomeState>[],
    );
  });

  group('IncomeBloc — update', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'UpdateIncomeStarted triggers reload',
      setUp: () {
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
        _stubGet.returnValue = [_fakeIncome()];
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(UpdateIncomeStarted(_fakeIncome())),
      expect: () => [const IncomeLoading(), isA<IncomeSuccess>()],
      tearDown: () async => GetIt.instance.reset(),
    );

    blocTest<IncomeBloc, IncomeState>(
      'UpdateIncomeStarted error sets actionError to genericError',
      setUp: () {
        _stubUpdate.shouldThrow = true;
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(UpdateIncomeStarted(_fakeIncome())),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.actionError,
          'actionError',
          'genericError',
        ),
      ],
      tearDown: () async => GetIt.instance.reset(),
    );
  });

  group('IncomeBloc — delete', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'DeleteIncomeStarted triggers reload',
      setUp: () {
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
        _stubGet.returnValue = [];
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(const DeleteIncomeStarted('inc-1')),
      expect: () => [const IncomeLoading(), isA<IncomeSuccess>()],
      tearDown: () async => GetIt.instance.reset(),
    );

    blocTest<IncomeBloc, IncomeState>(
      'DeleteIncomeStarted error sets actionError',
      setUp: () {
        _stubDelete.shouldThrow = true;
        GetIt.instance.registerSingleton<StatsBloc>(FakeStatsBloc());
      },
      build: _makeBloc,
      seed: _successSeed,
      act: (bloc) => bloc.add(const DeleteIncomeStarted('inc-1')),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.actionError,
          'actionError',
          'genericError',
        ),
      ],
      tearDown: () async => GetIt.instance.reset(),
    );
  });

  group('IncomeBloc — clear error', () {
    setUp(() {
      _stubAdd = _StubAddIncomeUseCase();
      _stubUpdate = _StubUpdateIncomeUseCase();
      _stubDelete = _StubDeleteIncomeUseCase();
      _stubGet = _StubGetIncomesUseCase();
    });

    blocTest<IncomeBloc, IncomeState>(
      'ClearIncomeActionErrorRequested clears actionError',
      build: _makeBloc,
      seed: () => _successSeed().copyWith(
        actionError: 'emptyDescription',
        selectedMonth: _successSeed().selectedMonth,
      ),
      act: (bloc) => bloc.add(const ClearIncomeActionErrorRequested()),
      expect: () => [
        isA<IncomeSuccess>().having(
          (s) => s.actionError,
          'actionError',
          isNull,
        ),
      ],
    );
  });
}
