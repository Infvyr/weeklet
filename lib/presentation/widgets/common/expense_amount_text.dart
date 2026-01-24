import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';

/// Text widget displaying expense amount with optional income styling
class ExpenseAmountText extends StatelessWidget {
  const ExpenseAmountText({
    super.key,
    required this.formattedAmount,
    this.isIncome = false,
  });

  final String formattedAmount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? Colors.green : context.colorScheme.onSurface;

    return Text(
      formattedAmount,
      style: context.bodyLarge?.copyWith(
        fontWeight: .w600,
        color: color,
      ),
    );
  }
}
