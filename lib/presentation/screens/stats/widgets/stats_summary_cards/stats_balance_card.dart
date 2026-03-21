import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/number_formatter.dart';

class StatsBalanceCard extends StatelessWidget {
  const StatsBalanceCard({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: context.theme.appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Monthly Balance',
                overflow: TextOverflow.ellipsis,
                style: context.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          NumberFormatter.formatCurrencyWithSign(
            balance,
            'RON',
            isIncome: false,
          ),
          style: context.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Realized Savings',
          style: context.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
