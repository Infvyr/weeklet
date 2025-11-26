import 'package:flutter/material.dart';

class WeeklyExpenseCard extends StatelessWidget {
  const WeeklyExpenseCard({
    required this.weeklyTotal,
    this.comparisonPercentage = 0.0,
    super.key,
  });

  final double weeklyTotal;
  final double comparisonPercentage;

  @override
  Widget build(BuildContext context) {
    final bool isHigher = comparisonPercentage > 0;
    final Color indicatorColor = isHigher ? Colors.red.shade700 : Colors.green.shade700;
    final String indicatorText = isHigher ? 'more' : 'less';
    final String comparisonValue =
        '${(comparisonPercentage.abs() * 100).toStringAsFixed(1)}%';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Week Expenses',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: .w600,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.arrow_circle_down,
                  color: Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Text(
                  '${weeklyTotal.toStringAsFixed(2)} MDL',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),

            Row(
              spacing: 5,
              children: [
                Icon(
                  isHigher ? Icons.trending_up : Icons.trending_down,
                  color: indicatorColor,
                  size: 20,
                ),
                Text.rich(
                  TextSpan(
                    text: comparisonValue,
                    style: TextStyle(
                      color: indicatorColor,
                      fontWeight: .bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' $indicatorText compared to last week.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: .normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
