import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

class CategoryDistributionCard extends StatelessWidget {
  const CategoryDistributionCard({
    required this.categoryTotals,
    super.key,
  });

  final Map<String, double> categoryTotals;

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'There are no expenses recorded for this month.',
              textAlign: .center,
            ),
          ),
        ),
      );
    }

    final total = categoryTotals.values.fold(0.0, (sum, item) => sum + item);

    // Only display expenses > 0
    final validEntries = categoryTotals.entries.where((e) => e.value > 0).toList();

    final pieSections = validEntries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final categoryName = entry.key.length > 10
          ? '${entry.key.substring(0, 8)}...'
          : entry.key;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: _getColorForCategory(entry.key),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            const Text(
              'Expense Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
              ),
            ),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                ),
              ),
            ),

            ...validEntries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      color: _getColorForCategory(entry.key),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.key}: ${NumberFormat.currency(
                        locale: 'ro_RO',
                        symbol: ' MDL',
                      ).format(entry.value)}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Communal':
        return Colors.blue;
      case 'Shopping':
        return Colors.orange;
      case 'Vehicle':
        return Colors.lime;
      case 'Internet/TV':
        return Colors.purple;
      case 'Deposit':
        return Colors.teal;
      case 'Other':
        return Colors.pink;
      default:
        return Colors.cyan;
    }
  }
}
