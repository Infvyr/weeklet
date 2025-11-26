import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklet/app/router/app_routes.dart';
import 'package:weeklet/presentation/blocs/expense/expense_cubit.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/widgets/balance_card.dart';
import 'package:weeklet/presentation/widgets/category_distribution_card.dart';
import 'package:weeklet/presentation/widgets/month_year_selector.dart';
import 'package:weeklet/presentation/widgets/recent_transactions_list.dart';
import 'package:weeklet/presentation/widgets/weekly_expense_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ExpenseCubit, ExpenseState>(
    builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage.toString()));
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              MonthYearSelector(
                currentYear: state.selectedYear,
                currentMonth: state.selectedMonth,
                onDateChanged: (year, month) {
                  context.read<ExpenseCubit>().loadMonthlySummary(year, month);
                },
              ),

              BalanceCard(
                income: state.monthlyTotalIncome,
                expense: state.monthlyTotalExpense,
                balance: state.monthlyBalance,
              ),

              WeeklyExpenseCard(
                weeklyTotal: state.weeklyTotalExpense,
                comparisonPercentage: state.weeklyComparisonPercentage,
              ),

              CategoryDistributionCard(
                categoryTotals: state.monthlyCategoryTotals,
              ),

              RecentTransactionsList(transactions: state.recentTransactions),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.pushNamed(AppRoute.addTransaction.name),
          child: const Icon(Icons.add),
        ),
      );
    },
  );
}
