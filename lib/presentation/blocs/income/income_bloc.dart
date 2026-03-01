import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/domain/usecases/income/add_income_use_case.dart';
import 'package:weeklet/domain/usecases/income/delete_income_use_case.dart';
import 'package:weeklet/domain/usecases/income/get_incomes_use_case.dart';
import 'package:weeklet/domain/usecases/income/update_income_use_case.dart';
import 'package:weeklet/domain/utils/income_filter_utils.dart';

import 'income_event.dart';
import 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc({
    required this.addIncomeUseCase,
    required this.updateIncomeUseCase,
    required this.deleteIncomeUseCase,
    required this.getIncomesUseCase,
    required this.uuid,
  }) : super(const IncomeInitial()) {
    on<LoadIncomesRequested>(_onLoadIncomes);
    on<AddIncomeStarted>(_onAddIncome);
    on<UpdateIncomeStarted>(_onUpdateIncome);
    on<DeleteIncomeStarted>(_onDeleteIncome);
    on<IncomeFilterDateChanged>(_onFilterDateChanged);
    on<ClearIncomeActionErrorRequested>(_onClearActionError);
  }

  final AddIncomeUseCase addIncomeUseCase;
  final UpdateIncomeUseCase updateIncomeUseCase;
  final DeleteIncomeUseCase deleteIncomeUseCase;
  final GetIncomesUseCase getIncomesUseCase;
  final Uuid uuid;

  void _onClearActionError(
    ClearIncomeActionErrorRequested event,
    Emitter<IncomeState> emit,
  ) {
    if (state case final IncomeSuccess st) {
      emit(
        st.copyWith(
          selectedMonth: st.selectedMonth,
          actionError: null,
        ),
      );
    }
  }

  Future<void> _onLoadIncomes(
    LoadIncomesRequested event,
    Emitter<IncomeState> emit,
  ) async {
    emit(const IncomeLoading());
    try {
      final incomes = await getIncomesUseCase();

      final availableYears = IncomeFilterUtils.extractAvailableYears(incomes);
      final currentYear = DateTime.now().year;
      final selectedYear = availableYears.contains(currentYear)
          ? currentYear
          : availableYears.first;

      final availableMonths = IncomeFilterUtils.extractAvailableMonthsForYear(
        incomes,
        selectedYear,
      );

      final currentMonth = DateTime.now().month;
      final selectedMonth = availableMonths.contains(currentMonth)
          ? currentMonth
          : (availableMonths.isNotEmpty ? availableMonths.last : null);

      final filtered = incomes.where((income) {
        final matchYear = income.date.year == selectedYear;
        final matchMonth =
            selectedMonth == null || income.date.month == selectedMonth;
        return matchYear && matchMonth;
      }).toList();

      emit(
        IncomeSuccess(
          allIncomes: incomes,
          filteredIncomes: filtered,
          selectedYear: selectedYear,
          selectedMonth: selectedMonth,
          availableYears: availableYears,
          availableMonths: availableMonths,
        ),
      );
    } catch (e) {
      debugPrint('error in _onLoadIncomes: $e');
      emit(IncomeFailure(e.toString()));
    }
  }

  Future<void> _onAddIncome(
    AddIncomeStarted event,
    Emitter<IncomeState> emit,
  ) async {
    if (state case final IncomeSuccess st) {
      try {
        final parsedAmount = double.tryParse(event.amount);
        if (parsedAmount == null || parsedAmount <= 0) {
          emit(
            st.copyWith(
              selectedMonth: st.selectedMonth,
              actionError: 'Please enter a valid amount',
            ),
          );
          return;
        }

        final now = DateTime.now();
        final newIncome = Income(
          id: uuid.v4(),
          amount: parsedAmount,
          description: event.description,
          date: event.date,
          createdAt: now,
        );
        await addIncomeUseCase(newIncome);
        add(const LoadIncomesRequested());
      } catch (e) {
        debugPrint('error in _onAddIncome: $e');
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not add the income',
          ),
        );
      }
    }
  }

  Future<void> _onUpdateIncome(
    UpdateIncomeStarted event,
    Emitter<IncomeState> emit,
  ) async {
    if (state case final IncomeSuccess st) {
      try {
        await updateIncomeUseCase(event.income);
        add(const LoadIncomesRequested());
      } catch (e) {
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not update the income',
          ),
        );
      }
    }
  }

  Future<void> _onDeleteIncome(
    DeleteIncomeStarted event,
    Emitter<IncomeState> emit,
  ) async {
    if (state case final IncomeSuccess st) {
      try {
        await deleteIncomeUseCase(event.id);
        add(const LoadIncomesRequested());
      } catch (e) {
        emit(
          st.copyWith(
            selectedMonth: st.selectedMonth,
            actionError: 'Could not delete the income',
          ),
        );
      }
    }
  }

  Future<void> _onFilterDateChanged(
    IncomeFilterDateChanged event,
    Emitter<IncomeState> emit,
  ) async {
    if (state case final IncomeSuccess st) {
      final newYear = event.year ?? st.selectedYear;
      final yearChanged = newYear != st.selectedYear;

      final availableMonths = yearChanged
          ? IncomeFilterUtils.extractAvailableMonthsForYear(
              st.allIncomes,
              newYear,
            )
          : st.availableMonths;

      final int? selectedMonth;
      if (event.year != null && event.month == null) {
        selectedMonth = availableMonths.contains(st.selectedMonth)
            ? st.selectedMonth
            : (availableMonths.isNotEmpty ? availableMonths.first : null);
      } else if (event.year == null) {
        selectedMonth = event.month;
      } else {
        selectedMonth = event.month ?? st.selectedMonth;
      }

      final filtered = st.allIncomes.where((income) {
        final matchYear = income.date.year == newYear;
        final matchMonth =
            selectedMonth == null || income.date.month == selectedMonth;
        return matchYear && matchMonth;
      }).toList();

      emit(
        st.copyWith(
          filteredIncomes: filtered,
          selectedYear: newYear,
          selectedMonth: selectedMonth,
          availableMonths: availableMonths,
        ),
      );
    }
  }
}
