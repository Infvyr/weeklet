import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';
import 'package:weeklet/domain/usecases/expense/add_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/delete_expense_usecase.dart';
import 'package:weeklet/domain/usecases/expense/get_all_expenses_usecase.dart';
import 'package:weeklet/domain/usecases/expense/update_expense_usecase.dart';

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
    required this.uuid,
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
      emit(st.copyWith(actionError: null));
    }
  }

  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetAllExpensesUseCase getExpensesUseCase;
  final Uuid uuid;

  Future<void> _onLoadExpenses(
    LoadExpensesRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    try {
      final expenses = await getExpensesUseCase(NoParams());
      final currentYear = DateTime.now().year;
      final filtered = expenses
          .where((e) => e.createdAt.year == currentYear)
          .toList();
      emit(
        ExpenseSuccess(
          allExpenses: expenses,
          filteredExpenses: filtered,
          selectedYear: currentYear,
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
        // Parse and validate amount
        final parsedAmount = double.tryParse(event.amount);
        if (parsedAmount == null || parsedAmount <= 0) {
          emit(
            st.copyWith(
              actionError: 'Please enter a valid amount',
            ),
          );
          return;
        }

        // Combine selected date with current time for createdAt
        final now = DateTime.now();
        final createdAt = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
          now.hour,
          now.minute,
          now.second,
        );
        final newExpense = Expense(
          id: uuid.v4(),
          amount: parsedAmount,
          description: event.description,
          categoryId: event.categoryId,
          createdAt: createdAt,
        );
        await addExpenseUseCase(newExpense);
        add(const LoadExpensesRequested());
      } catch (e) {
        debugPrint('error in _onAddExpense: $e');
        emit(
          st.copyWith(
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
      final newMonth = event.month; // can be null to indicate no month filter

      final filtered = st.allExpenses.where((expense) {
        final matchYear = expense.createdAt.year == newYear;
        final matchMonth =
            newMonth == null || expense.createdAt.month == newMonth;
        return matchYear && matchMonth;
      }).toList();

      emit(
        st.copyWith(
          filteredExpenses: filtered,
          selectedYear: newYear,
          selectedMonth: newMonth,
        ),
      );
    }
  }
}
