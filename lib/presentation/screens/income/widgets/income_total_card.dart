import 'package:flutter/material.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/utils/income_filter_utils.dart';

class IncomeTotalCard extends StatelessWidget {
  const IncomeTotalCard({
    super.key,
    required this.total,
    this.selectedMonth,
    this.currencySymbol = AppConstants.DEFAULT_CURRENCY,
  });

  final double total;
  final int? selectedMonth;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final monthName = selectedMonth != null
        ? IncomeFilterUtils.getMonthName(selectedMonth!).toLowerCase()
        : '';
    final formattedTotal = NumberFormatter.formatCurrencyWithSign(
      total,
      currencySymbol,
      isIncome: true,
    );
    final label = selectedMonth != null
        ? 'Total income for $monthName'
        : 'Total income';

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.green,
        child: Padding(
          padding: const .all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              Text(
                label,
                style: context.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Text(
                formattedTotal,
                style: context.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
