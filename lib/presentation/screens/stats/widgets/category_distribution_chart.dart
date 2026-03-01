import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/utils/category_color_utils.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';

class CategoryDistributionChart extends StatelessWidget {
  const CategoryDistributionChart({
    super.key,
    required this.categoryStats,
  });

  final List<CategoryStats> categoryStats;

  @override
  Widget build(BuildContext context) {
    if (categoryStats.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        final touchedIndex = state is MonthlyStatsLoaded
            ? state.touchedIndex
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
                  'Category Distribution - Current Month',
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            context.read<StatsBloc>().add(
                              const ChartTouchInteraction(-1),
                            );
                            return;
                          }
                          context.read<StatsBloc>().add(
                            ChartTouchInteraction(
                              pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex,
                            ),
                          );
                        },
                      ),
                      sections: _generateSections(touchedIndex),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Legend
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(categoryStats.length, (index) {
                    final stat = categoryStats[index];
                    final isTouched = index == touchedIndex;
                    final isAnythingTouched = touchedIndex != -1;
                    final opacity = (isTouched || !isAnythingTouched)
                        ? 1.0
                        : 0.5;
                    final fontWeight = isTouched
                        ? FontWeight.bold
                        : FontWeight.normal;

                    final color = CategoryColorUtils.getColor(
                      stat.category.name,
                    );
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: opacity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: isTouched
                                  ? Border.all(
                                    color: context.colorScheme.onSurface,
                                    width: 2,
                                  )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            stat.category.name,
                            style: context.labelMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: fontWeight,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _generateSections(int touchedIndex) {
    return List.generate(categoryStats.length, (i) {
      final stat = categoryStats[i];
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 16.0 : 12.0;
      final double radius = isTouched ? 60.0 : 50.0;
      final color = CategoryColorUtils.getColor(stat.category.name);

      return PieChartSectionData(
        color: color,
        value: stat.totalAmount,
        title: '${(stat.percentage * 100).toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
