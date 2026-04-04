import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';
import 'package:weeklet/domain/usecases/expense/add_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/delete_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/get_all_expenses_usecase.dart';
import 'package:weeklet/domain/usecases/expense/update_expense_usecase.dart';
import 'package:weeklet/domain/utils/expense_filter_utils.dart';

import 'expense_event.dart';
import 'expense_state.dart';

/// Debounce transformer to limit the rate of events processing
EventTransformer<E> debounce<E>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc({
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getExpensesUseCase,
  }) : super(const ExpenseInitial()) {
    on<LoadExpensesRequested>(_onLoadExpenses);
    on<AddExpenseStarted>(_onAddExpense);
    on<UpdateExpenseStarted>(_onUpdateExpense);
    on<DeleteExpenseStarted>(_onDeleteExpense);
    on<FilterDateChanged>(_onFilterDateChanged);
    on<ClearActionErrorRequested>(_onClearActionError);
  }

  void _onClearActionError(
    ClearActionErrorRequested event,
    Emitter<ExpenseState> emit,
  ) {
    if (state case final ExpenseSuccess st) {
      emit(
        st.copyWith(
          selectedMonth: st.selectedMonth,
          actionError: null,
        ),
      );
    }
  }

  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetAllExpensesUseCase getExpensesUseCase;

  Future<void> _onLoadExpenses(
    LoadExpensesRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    try {
      final expenses = await getExpensesUseCase(NoParams());

      // Extract available years and select current year if available
      final availableYears = ExpenseFilterUtils.extractAvailableYears(expenses);
      final currentYear = DateTime.now().year;
      final selectedYear = availableYears.contains(currentYear)
          ? currentYear
          : availableYears.first;

      // Extract available months for selected year
      final availableMonths = ExpenseFilterUtils.extractAvailableMonthsForYear(
        expenses,
        selectedYear,
      );

      // Select current month if available, otherwise select the last (most recent) available month
      final currentMonth = DateTime.now().month;
      final selectedMonth = availableMonths.contains(currentMonth)
          ? currentMonth
          : (availableMonths.isNotEmpty ? availableMonths.last : null);

      // Filter expenses for selected year and month
      final filtered = expenses.where((expense) {
        final matchYear = expense.createdAt.year == selectedYear;
        final matchMonth =
            selectedMonth == null || expense.createdAt.month == selectedMonth;
        return matchYear && matchMonth;
      }).toList();

      emit(
        ExpenseSuccess(
          allExpenses: expenses,
          filteredExpenses: filtered,
          selectedYear: selectedYear,
          selectedMonth: selectedMonth,
          availableYears: availableYears,
          availableMonths: availableMonths,
        ),
      );
    } catch (e) {
      debugPrint('error in _onLoadExpenses: $e');
      emit(ExpenseFailure(e.toString()));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseStarted event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state case final ExpenseSuccess st) {
      try {
        await addExpenseUseCase(
          AddExpenseParams(
            amount: event.amount,
            description: event.description,
            categoryId: event.categoryId,
            date: event.date,
          ),
        );
        add(const LoadExpensesRequested());
      } on ArgumentError catch (e) {
        debugPrint('error in _onAddExpense: $e');
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: e.message?.toString() ?? 'Invalid input',
          ),
        );
      } catch (e) {
        debugPrint('error in _onAddExpense: $e');
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not add the expense',
          ),
        );
      }
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseStarted event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state case final ExpenseSuccess st) {
      try {
        await updateExpenseUseCase(event.expense);
        add(const LoadExpensesRequested());
      } catch (e) {
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not update the expense',
          ),
        );
      }
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseStarted event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state case final ExpenseSuccess st) {
      try {
        await deleteExpenseUseCase(event.id);
        add(const LoadExpensesRequested());
      } catch (e) {
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not delete the expense',
          ),
        );
      }
    }
  }

  Future<void> _onFilterDateChanged(
    FilterDateChanged event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state case final ExpenseSuccess st) {
      final newYear = event.year ?? st.selectedYear;
      final yearChanged = newYear != st.selectedYear;

      // Recalculate available months if year changed
      final availableMonths = yearChanged
          ? ExpenseFilterUtils.extractAvailableMonthsForYear(
              st.allExpenses,
              newYear,
            )
          : st.availableMonths;

      // Determine the selected month:
      // If only year was changed (year provided, month not), adjust month if needed
      // If month was explicitly changed through the event, use it (even if null for "All Months")
      final int? selectedMonth;
      if (event.year != null && event.month == null) {
        // Only year was changed in this event
        selectedMonth = availableMonths.contains(st.selectedMonth)
            ? st.selectedMonth
            : (availableMonths.isNotEmpty ? availableMonths.first : null);
      } else if (event.year == null) {
        // Only month was changed in this event
        selectedMonth = event.month;
      } else {
        // Both year and month were changed
        selectedMonth = event.month ?? st.selectedMonth;
      }

      final filtered = st.allExpenses.where((expense) {
        final matchYear = expense.createdAt.year == newYear;
        final matchMonth =
            selectedMonth == null || expense.createdAt.month == selectedMonth;
        return matchYear && matchMonth;
      }).toList();

      emit(
        st.copyWith(
          filteredExpenses: filtered,
          selectedYear: newYear,
          selectedMonth: selectedMonth,
          availableMonths: availableMonths,
        ),
      );
    }
  }
}
