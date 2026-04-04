import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/utils/expense_grouping.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/list/expense_week_group_view.dart';
import 'package:weeklet/presentation/widgets/common/empty_state_view.dart';

class ExpenseListView extends StatelessWidget {
  const ExpenseListView({
    super.key,
    required this.expenses,
    required this.categories,
    this.currencySymbol = AppConstants.DEFAULT_CURRENCY,
  });

  final List<Expense> expenses;
  final List<Category> categories;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const EmptyStateView(
        icon: Icons.receipt_long_outlined,
        title: 'No expenses yet',
        subtitle: 'Tap + to add your first expense',
      );
    }

    final groupedByWeek = ExpenseGrouping.groupByWeek(expenses);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const .only(bottom: 50),
      itemCount: groupedByWeek.length,
      itemBuilder: (context, index) {
        final entry = groupedByWeek.entries.elementAt(index);
        return ExpenseWeekGroupView(
          weekNumber: entry.key.week,
          expenses: entry.value,
          categories: categories,
          currencySymbol: currencySymbol,
        );
      },
    );
  }
}
