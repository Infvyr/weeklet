import 'package:flutter/material.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_summary_cards/stats_balance_card.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart';

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
            child: StatsSmallCard(
              title: 'Monthly Income',
              amount: stats.totalIncome,
              percentage: stats.incomeGrowthPercentage,
              isIncome: true,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatsSmallCard(
              title: 'Monthly Expenses',
              amount: stats.totalExpenses,
              percentage: stats.expenseGrowthPercentage,
              isIncome: false,
              icon: Icons.attach_money,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      StatsBalanceCard(balance: stats.balance),
    ],
  );
}
