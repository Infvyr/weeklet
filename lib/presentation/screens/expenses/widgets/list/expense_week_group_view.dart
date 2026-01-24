import 'package:flutter/material.dart';
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/utils/expense_grouping.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/list/expense_day_group_view.dart';
import 'package:weeklet/presentation/widgets/common/week_header_text.dart';
import 'package:weeklet/presentation/widgets/common/week_total_row.dart';

class ExpenseWeekGroupView extends StatelessWidget {
  const ExpenseWeekGroupView({
    super.key,
    required this.weekNumber,
    required this.expenses,
    required this.categories,
    this.currencySymbol = 'lei',
  });

  final int weekNumber;
  final List<Expense> expenses;
  final List<Category> categories;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final groupedByDay = ExpenseGrouping.groupByDay(expenses);
    final weekTotal = ExpenseGrouping.calculateTotal(expenses);
    final formattedTotal = NumberFormatter.formatCurrency(
      weekTotal,
      currencySymbol,
    );

    return Card(
      margin: const .only(bottom: 16),
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            WeekHeaderText(weekNumber: weekNumber),
            ...groupedByDay.entries.map(
              (entry) => ExpenseDayGroupView(
                date: entry.key,
                expenses: entry.value,
                categories: categories,
                currencySymbol: currencySymbol,
              ),
            ),
            WeekTotalRow(formattedTotal: formattedTotal),
          ],
        ),
      ),
    );
  }
}
