import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weeklet/domain/usecases/export/export_expenses_usecase.dart';
import 'package:weeklet/domain/usecases/export/export_income_usecase.dart';

import 'export_event.dart';
import 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc({
    required this.exportExpensesUseCase,
    required this.exportIncomeUseCase,
  }) : super(const ExportInitial()) {
    on<ExportExpensesStarted>(_onExportExpenses);
    on<ExportIncomeStarted>(_onExportIncome);
    on<ResetExportRequested>(_onResetExport);
  }

  final ExportExpensesUseCase exportExpensesUseCase;
  final ExportIncomeUseCase exportIncomeUseCase;

  Future<void> _onExportExpenses(
    ExportExpensesStarted event,
    Emitter<ExportState> emit,
  ) async {
    emit(const ExportInProgress());
    try {
      final filePath = await exportExpensesUseCase(
        ExportExpensesParams(
          expenses: event.expenses,
          categories: event.categories,
          currencySymbol: event.currencySymbol,
          year: event.year,
          month: event.month,
        ),
      );
      final monthName =
          DateFormat.yMMMM('en').format(DateTime(event.year, event.month));
      emit(
        ExportSuccess(
          filePath: filePath,
          subject: 'Weeklet Expense Report \u2014 $monthName',
        ),
      );
    } catch (e) {
      debugPrint('error in _onExportExpenses: $e');
      emit(ExportFailure(e.toString()));
    }
  }

  Future<void> _onExportIncome(
    ExportIncomeStarted event,
    Emitter<ExportState> emit,
  ) async {
    emit(const ExportInProgress());
    try {
      final filePath = await exportIncomeUseCase(
        ExportIncomeParams(
          incomes: event.incomes,
          currencySymbol: event.currencySymbol,
          year: event.year,
          month: event.month,
        ),
      );
      final monthName =
          DateFormat.yMMMM('en').format(DateTime(event.year, event.month));
      emit(
        ExportSuccess(
          filePath: filePath,
          subject: 'Weeklet Income Report \u2014 $monthName',
        ),
      );
    } catch (e) {
      debugPrint('error in _onExportIncome: $e');
      emit(ExportFailure(e.toString()));
    }
  }

  void _onResetExport(
    ResetExportRequested event,
    Emitter<ExportState> emit,
  ) {
    emit(const ExportInitial());
  }
}
