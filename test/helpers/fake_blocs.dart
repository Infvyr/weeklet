// Fake BLoC classes for GetIt registration in Wave 2+3 tests.
// These absorb .add() calls without crashing and expose their initial state.
// All classes are public so they can be imported across test files.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_available_periods_use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_evolution_stats_use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_monthly_stats_use_case.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';

// ---------------------------------------------------------------------------
// Stub use cases for FakeStatsBloc
// ---------------------------------------------------------------------------

// These stubs use noSuchMethod so the concrete use case's `repository` field
// (which becomes part of the abstract contract) is implicitly satisfied.

class _StubGetMonthlyStatsUseCase implements GetMonthlyStatsUseCase {
  @override
  Future<MonthlyStats> call(GetMonthlyStatsParams params) async =>
      const MonthlyStats(
        totalIncome: 0,
        totalExpenses: 0,
        balance: 0,
        incomeGrowthPercentage: 0,
        expenseGrowthPercentage: 0,
        categoryStats: [],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubGetEvolutionStatsUseCase implements GetEvolutionStatsUseCase {
  @override
  Future<EvolutionStats> call(GetEvolutionStatsParams params) async =>
      const EvolutionStats(snapshots: []);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubGetAvailablePeriodsUseCase implements GetAvailablePeriodsUseCase {
  @override
  Future<Map<int, List<int>>> call(NoParams params) async => {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---------------------------------------------------------------------------
// FakeStatsBloc — extends StatsBloc so it can be registered as StatsBloc
// ---------------------------------------------------------------------------

class FakeStatsBloc extends StatsBloc {
  FakeStatsBloc()
    : super(
        getMonthlyStatsUseCase: _StubGetMonthlyStatsUseCase(),
        getEvolutionStatsUseCase: _StubGetEvolutionStatsUseCase(),
        getAvailablePeriodsUseCase: _StubGetAvailablePeriodsUseCase(),
      );
}

class FakeExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  FakeExpenseBloc() : super(const ExpenseInitial()) {
    on<LoadExpensesRequested>((_, __) {});
    on<AddExpenseStarted>((_, __) {});
    on<UpdateExpenseStarted>((_, __) {});
    on<DeleteExpenseStarted>((_, __) {});
    on<FilterDateChanged>((_, __) {});
    on<ClearActionErrorRequested>((_, __) {});
  }
}

class FakeIncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  FakeIncomeBloc() : super(const IncomeInitial()) {
    on<LoadIncomesRequested>((_, __) {});
    on<AddIncomeStarted>((_, __) {});
    on<UpdateIncomeStarted>((_, __) {});
    on<DeleteIncomeStarted>((_, __) {});
    on<IncomeFilterDateChanged>((_, __) {});
    on<ClearIncomeActionErrorRequested>((_, __) {});
  }
}

class FakeCategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  FakeCategoryBloc() : super(const CategoryLoading()) {
    on<GetAllCategoriesEvent>((_, __) {});
    on<AddCategoryEvent>((_, __) {});
    on<UpdateCategoryEvent>((_, __) {});
    on<DeleteCategoryEvent>((_, __) {});
    on<GetCategoryByIdEvent>((_, __) {});
  }
}
