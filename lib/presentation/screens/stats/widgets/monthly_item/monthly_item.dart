import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/utils/expense_filter_utils.dart';
import 'package:weeklet/domain/utils/monthly_snapshot_utils.dart';
import 'package:weeklet/presentation/screens/stats/widgets/monthly_item/monthly_bar_row.dart';

class MonthlyItem extends StatelessWidget {
  const MonthlyItem({
    super.key,
    required this.snapshot,
    required this.maxIncome,
  });

  final MonthlySnapshot snapshot;
  final double maxIncome;

  @override
  Widget build(BuildContext context) {
    final monthName = ExpenseFilterUtils.getMonthAbbreviation(snapshot.month);
    final balanceText = MonthlySnapshotUtils.formatBalanceText(
      snapshot.balance,
    );
    final balanceColor =
        MonthlySnapshotUtils.isBalancePositive(snapshot.balance)
        ? context.theme.appBarTheme.backgroundColor
        : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month name and balance header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                balanceText,
                style: context.labelMedium?.copyWith(
                  color: balanceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Venit row with label
          MonthlyBarRow(
            label: 'Venit',
            amount: snapshot.totalIncome,
            maxAmount: maxIncome,
            color: context.successColor,
          ),
          // Cheltuieli row with label
          MonthlyBarRow(
            label: 'Cheltuieli',
            amount: snapshot.totalExpenses,
            maxAmount: maxIncome,
            color: context.colorScheme.error,
          ),
        ],
      ),
    );
  }
}
