import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/utils/date_time_extensions.dart';
import 'package:weeklet/domain/entities/transaction.dart';
import 'package:weeklet/domain/usecases/get_total_by_filter_use_case.dart';
import 'package:weeklet/domain/usecases/get_transactions_by_month_use_case.dart';
import 'package:weeklet/domain/usecases/get_weekly_expense_summary_use_case.dart';

import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit({
    required this.getTotalByFilter,
    required this.getTransactionsByMonth,
    required this.getWeeklyExpenseSummary,
  }) : super(ExpenseState.initial());

  final GetTotalByFilterUseCase getTotalByFilter;
  final GetTransactionsByMonthUseCase getTransactionsByMonth;
  final GetWeeklyExpenseSummaryUseCase getWeeklyExpenseSummary;

  Future<void> refreshData() async {
    final year = state.selectedYear;
    final month = state.selectedMonth;

    await Future.wait([
      loadMonthlySummary(year, month),
      loadWeeklySummary(),
    ]);
  }

  Future<void> loadMonthlySummary(int year, int month) async {
    emit(
      state.copyWith(
        isLoading: true,
        selectedYear: year,
        selectedMonth: month,
        errorMessage: null,
      ),
    );

    try {
      final income = await getTotalByFilter(
        TotalByFilterParams(type: 'Income', year: year, month: month),
      );

      final expenses = await getTotalByFilter(
        TotalByFilterParams(type: 'Expense', year: year, month: month),
      );

      final transactions = await getTransactionsByMonth(
        TransactionsByMonthParams(year: year, month: month),
      );

      final expenseTransactions = transactions.where((t) => t.type == 'Expense').toList();

      final Map<String, List<Transaction>> groupedByCategory = groupBy(
        expenseTransactions,
        (t) => t.category,
      );

      final Map<String, double> categoryTotals = groupedByCategory.map((category, list) {
        final total = list.fold(0.0, (sum, item) => sum + item.amount);
        return MapEntry(category, total);
      });

      transactions.sort((a, b) => b.date.compareTo(a.date));

      emit(
        state.copyWith(
          monthlyTotalIncome: income,
          monthlyTotalExpense: expenses,
          monthlyBalance: income - expenses,
          monthlyCategoryTotals: categoryTotals,
          recentTransactions: transactions,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> loadWeeklySummary() async {
    const firstDayOfWeek = 1;
    final now = DateTime.now();

    final currentWeekStart = now.startOfWeek(firstDayOfWeek: firstDayOfWeek);
    final currentWeekEnd = now.endOfWeek(firstDayOfWeek: firstDayOfWeek);

    final lastWeekEndMarker = currentWeekStart.subtract(const Duration(days: 1));
    final lastWeekStart = lastWeekEndMarker.startOfWeek(firstDayOfWeek: firstDayOfWeek);

    try {
      final results = await Future.wait([
        getWeeklyExpenseSummary(
          GetWeeklyExpenseSummaryParams(
            startDate: currentWeekStart,
            endDate: currentWeekEnd,
          ),
        ),
        getWeeklyExpenseSummary(
          GetWeeklyExpenseSummaryParams(
            startDate: lastWeekStart,
            endDate: lastWeekEndMarker,
          ),
        ),
      ]);

      final currentWeekTotal = results[0];
      final lastWeekTotal = results[1];

      double comparison = 0.0;
      if (lastWeekTotal > 0) {
        comparison = (currentWeekTotal - lastWeekTotal) / lastWeekTotal;
      } else if (currentWeekTotal > 0) {
        comparison = 1.0;
      }

      emit(
        state.copyWith(
          weeklyTotalExpense: currentWeekTotal,
          weeklyComparisonPercentage: comparison,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }
}
