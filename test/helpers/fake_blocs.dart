// Fake BLoC classes for GetIt registration in Wave 2+3 tests.
// These absorb .add() calls without crashing and expose their initial state.
// All classes are public so they can be imported across test files.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';

class FakeStatsBloc extends Bloc<StatsEvent, StatsState> {
  FakeStatsBloc() : super(const StatsInitial()) {
    on<LoadMonthlyStats>((_, __) {});
    on<ChangeStatsTab>((_, __) {});
    on<ChartTouchInteraction>((_, __) {});
  }
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
