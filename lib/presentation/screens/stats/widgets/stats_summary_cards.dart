import 'package:flutter/material.dart';
import 'package:weeklet/core/theme/colors.dart';
import 'package:weeklet/domain/entities/statistics.dart';

class StatsSummaryCards extends StatelessWidget {
  const StatsSummaryCards({
    super.key,
    required this.stats,
  });

  final MonthlyStats stats;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _SmallCard(
              title: 'Monthly Income',
              amount: stats.totalIncome,
              percentage: stats.incomeGrowthPercentage,
              amountColor: Colors.greenAccent,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _SmallCard(
              title: 'Monthly Expenses',
              amount: stats.totalExpenses,
              percentage: stats.expenseGrowthPercentage,
              amountColor: Colors.white,
              icon: Icons.attach_money,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _BalanceCard(balance: stats.balance),
    ],
  );
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.amountColor,
    required this.icon,
  });

  final String title;
  final double amount;
  final double percentage;
  final Color amountColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isPositive = percentage >= 0;
    final percentageColor = isPositive ? Colors.green : Colors.red;
    final percentageIcon = isPositive
        ? Icons.call_made
        : Icons.call_received; // Arrow up/down

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface, // Dark card background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.darkOnSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.darkOnSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '+${amount.toStringAsFixed(2)} RON',
            style: TextStyle(
              color: amountColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(percentageIcon, size: 12, color: percentageColor),
              const SizedBox(width: 4),
              Text(
                '${(percentage * 100).abs().toStringAsFixed(1)}% vs last month',
                style: TextStyle(color: percentageColor, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.darkPrimaryColor, // Blue background
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.white70,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              'Monthly Balance',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '+${balance.toStringAsFixed(2)} RON',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Realized Savings',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    ),
  );
}
