import 'package:flutter/material.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_summary_cards/stats_balance_card.dart';
import 'package:weeklet/presentation/screens/stats/widgets/stats_summary_cards/stats_small_card.dart';

class StatsSummaryCards extends StatelessWidget {
  const StatsSummaryCards({
    super.key,
    required this.stats,
    required this.isAnnual,
    required this.currencySymbol,
  });

  final MonthlyStats stats;
  final bool isAnnual;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: StatsSmallCard(
              title: isAnnual ? 'Annual Income' : 'Monthly Income',
              amount: stats.totalIncome,
              percentage: stats.incomeGrowthPercentage,
              isIncome: true,
              isAnnual: isAnnual,
              icon: Icons.trending_up,
              currencySymbol: currencySymbol,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatsSmallCard(
              title: isAnnual ? 'Annual Expenses' : 'Monthly Expenses',
              amount: stats.totalExpenses,
              percentage: stats.expenseGrowthPercentage,
              isIncome: false,
              isAnnual: isAnnual,
              icon: Icons.attach_money,
              currencySymbol: currencySymbol,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      StatsBalanceCard(
        balance: stats.balance,
        isAnnual: isAnnual,
        currencySymbol: currencySymbol,
      ),
    ],
  );
}
