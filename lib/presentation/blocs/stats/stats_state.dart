import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/presentation/blocs/stats/stats_tab.dart';

sealed class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

final class StatsInitial extends StatsState {
  const StatsInitial();
}

final class StatsLoading extends StatsState {
  const StatsLoading();
}

final class MonthlyStatsLoaded extends StatsState {
  const MonthlyStatsLoaded({
    required this.stats,
    required this.month,
    required this.year,
    this.currentTab = StatsTab.monthly,
    this.touchedIndex = -1,
  });

  final MonthlyStats stats;
  final int month;
  final int year;
  final StatsTab currentTab;
  final int touchedIndex;

  MonthlyStatsLoaded copyWith({
    MonthlyStats? stats,
    int? month,
    int? year,
    StatsTab? currentTab,
    int? touchedIndex,
  }) => MonthlyStatsLoaded(
    stats: stats ?? this.stats,
    month: month ?? this.month,
    year: year ?? this.year,
    currentTab: currentTab ?? this.currentTab,
    touchedIndex: touchedIndex ?? this.touchedIndex,
  );

  @override
  List<Object?> get props => [stats, month, year, currentTab, touchedIndex];
}

final class StatsError extends StatsState {
  const StatsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
