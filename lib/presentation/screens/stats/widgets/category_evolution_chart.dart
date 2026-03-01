import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/category_color_utils.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/utils/evolution_stats_utils.dart';
import 'package:weeklet/domain/utils/expense_filter_utils.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';

class CategoryEvolutionChart extends StatelessWidget {
  const CategoryEvolutionChart({
    super.key,
    required this.evolutionStats,
  });

  final EvolutionStats evolutionStats;

  @override
  Widget build(BuildContext context) {
    // Filter out months with no data
    final snapshotsWithData = EvolutionStatsUtils.getSnapshotsWithData(
      evolutionStats,
    );

    // Get all unique categories sorted by name
    final sortedCategories = EvolutionStatsUtils.getAllCategoryNames(
      snapshotsWithData,
    );

    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        final touchedGroupIndex = state is MonthlyStatsLoaded
            ? (state.touchedIndex >= 0 ? state.touchedIndex : -1)
            : -1;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evoluție categorii - Ultimele 6 luni',
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 350,
                  child: BarChart(
                    BarChartData(
                      maxY: _getMaxY(snapshotsWithData),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _getYInterval(snapshotsWithData),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: context.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _generateBarGroups(
                        touchedGroupIndex,
                        sortedCategories,
                        snapshotsWithData,
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          direction: TooltipDirection.top,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              _buildTooltip(
                                groupIndex,
                                sortedCategories,
                                snapshotsWithData,
                              ),
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            context.read<StatsBloc>().add(
                              const ChartTouchInteraction(-1),
                            );
                            return;
                          }
                          context.read<StatsBloc>().add(
                            ChartTouchInteraction(
                              response.spot!.touchedBarGroupIndex,
                            ),
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index < snapshotsWithData.length) {
                                final snapshot = snapshotsWithData[index];
                                final monthName =
                                    ExpenseFilterUtils.getMonthName(
                                      snapshot.month,
                                    );
                                // Return first 3 letters of month name
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    monthName.substring(0, 3),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Legend
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    // Categories
                    ...sortedCategories.map((categoryName) {
                      final color = CategoryColorUtils.getColor(categoryName);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            categoryName,
                            style: context.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    }),
                    // Income (Venit)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Venit',
                          style: context.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getMaxY(List<MonthlySnapshot> snapshots) {
    if (snapshots.isEmpty) return 0;
    double max = 0;
    for (final snapshot in snapshots) {
      double monthMax = snapshot.totalIncome;
      for (final catStat in snapshot.categoryStats) {
        monthMax += catStat.totalAmount;
      }
      if (monthMax > max) max = monthMax;
    }
    return max * 1.1; // 10% padding
  }

  double _getYInterval(List<MonthlySnapshot> snapshots) {
    final maxY = _getMaxY(snapshots);
    return EvolutionStatsUtils.getYInterval(maxY);
  }

  List<BarChartGroupData> _generateBarGroups(
    int touchedGroupIndex,
    List<String> sortedCategories,
    List<MonthlySnapshot> snapshots,
  ) => List.generate(snapshots.length, (groupIndex) {
    final snapshot = snapshots[groupIndex];
    final isTouched = groupIndex == touchedGroupIndex;

    // Build a map of category name to total amount for quick lookup
    final categoryMap = {
      for (final cs in snapshot.categoryStats) cs.category.name: cs.totalAmount,
    };

    // Build category bars + income bar
    final rods = <BarChartRodData>[];

    // Add a bar for each category
    for (final categoryName in sortedCategories) {
      final categoryTotal = categoryMap[categoryName] ?? 0.0;
      final color = CategoryColorUtils.getColor(categoryName);
      rods.add(
        BarChartRodData(
          toY: categoryTotal,
          color: color,
          width: 6,
        ),
      );
    }

    // Add income bar (Venit) last
    rods.add(
      BarChartRodData(
        toY: snapshot.totalIncome,
        color: Colors.green,
        width: 6,
      ),
    );

    return BarChartGroupData(
      x: groupIndex,
      barRods: rods,
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  });

  BarTooltipItem? _buildTooltip(
    int groupIndex,
    List<String> sortedCategories,
    List<MonthlySnapshot> snapshots,
  ) {
    if (groupIndex < 0 || groupIndex >= snapshots.length) {
      return null;
    }

    final snapshot = snapshots[groupIndex];
    final monthName = ExpenseFilterUtils.getMonthName(snapshot.month);

    final lines = <TextSpan>[
      TextSpan(
        text: monthName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];

    // Build a map of category name to total amount for quick lookup
    final categoryMap = {
      for (final cs in snapshot.categoryStats) cs.category.name: cs.totalAmount,
    };

    // Add each category amount
    for (final categoryName in sortedCategories) {
      final categoryTotal = categoryMap[categoryName] ?? 0.0;
      final color = CategoryColorUtils.getColor(categoryName);
      lines.add(
        TextSpan(
          text: '$categoryName : ${categoryTotal.toStringAsFixed(2)} lei',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // Add income (Venit) line
    lines.add(
      TextSpan(
        text: '\nVenit : ${snapshot.totalIncome.toStringAsFixed(2)} lei',
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return BarTooltipItem(
      '',
      const TextStyle(),
      children: lines,
    );
  }
}
