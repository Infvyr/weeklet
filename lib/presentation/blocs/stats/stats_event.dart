import 'package:equatable/equatable.dart';
import 'package:weeklet/presentation/blocs/stats/stats_tab.dart';

sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

class LoadMonthlyStats extends StatsEvent {
  const LoadMonthlyStats({
    required this.month,
    required this.year,
  });

  final int month;
  final int year;

  @override
  List<Object> get props => [month, year];
}

class ChangeStatsTab extends StatsEvent {
  const ChangeStatsTab(this.tab);
  final StatsTab tab;

  @override
  List<Object> get props => [tab];
}

class ChartTouchInteraction extends StatsEvent {
  const ChartTouchInteraction(this.index);
  final int index;

  @override
  List<Object> get props => [index];
}
