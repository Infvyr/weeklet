import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    required this.income,
    required this.expense,
    required this.balance,
    super.key,
  });

  final double income;
  final double expense;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'ro_RO', symbol: ' MDL');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text(
              'MONTHLY NET BALANCE',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            Text(
              formatter.format(balance),
              style: TextStyle(
                fontSize: 28,
                fontWeight: .bold,
                color: balance >= 0 ? Colors.green[700] : Colors.red[700],
              ),
            ),

            const Divider(height: 25),

            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                _buildDetail(context, 'Income', income, Colors.green),
                _buildDetail(context, 'Expense', expense, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    final formatter = NumberFormat.currency(locale: 'ro_RO', symbol: ' MDL');

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          formatter.format(amount),
          style: TextStyle(
            fontSize: 18,
            fontWeight: .w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
