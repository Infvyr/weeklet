import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_available_periods_use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_monthly_stats_use_case.dart';
import 'package:weeklet/domain/usecases/stats/get_evolution_stats_use_case.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_tab.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required this.getMonthlyStatsUseCase,
    required this.getEvolutionStatsUseCase,
    required this.getAvailablePeriodsUseCase,
  }) : super(const StatsInitial()) {
    on<LoadMonthlyStats>(_onLoadMonthlyStats);
    on<ChangeStatsTab>(_onChangeStatsTab);
    on<ChartTouchInteraction>(_onChartTouchInteraction);
  }

  final GetMonthlyStatsUseCase getMonthlyStatsUseCase;
  final GetEvolutionStatsUseCase getEvolutionStatsUseCase;
  final GetAvailablePeriodsUseCase getAvailablePeriodsUseCase;

  Future<void> _onLoadMonthlyStats(
    LoadMonthlyStats event,
    Emitter<StatsState> emit,
  ) async {
    // If we are already loaded, we want to keep the current state to avoid flickering
    // but re-fetch data. If not loaded, show loading.
    final isInitialLoad = state is! MonthlyStatsLoaded;
    if (isInitialLoad) {
      emit(const StatsLoading());
    }

    try {
      // Only fetch available periods on initial load to avoid unnecessary queries
      Map<int, List<int>> availablePeriods = {};
      int? selectedMonth = event.month;

      if (isInitialLoad) {
        availablePeriods = await getAvailablePeriodsUseCase(NoParams());

        // Smart selection: if no month provided, pick current or last available
        if (event.month == null) {
          final availableMonths = availablePeriods[event.year] ?? [];
          if (availableMonths.contains(DateTime.now().month) &&
              DateTime.now().year == event.year) {
            // Use current month if available in this year
            selectedMonth = DateTime.now().month;
          } else if (availableMonths.isNotEmpty) {
            // Use last available month
            selectedMonth = availableMonths.last;
          }
          // else: keep selectedMonth as null (all months/annual)
        }
      }

      final params = GetMonthlyStatsParams(
        month: selectedMonth,
        year: event.year,
      );
      final stats = await getMonthlyStatsUseCase(params);

      if (state case final MonthlyStatsLoaded st) {
        emit(
          st.copyWith(
            stats: stats,
            month: selectedMonth,
            year: event.year,
          ),
        );
      } else {
        emit(
          MonthlyStatsLoaded(
            stats: stats,
            month: selectedMonth,
            year: event.year,
            availablePeriods: availablePeriods,
          ),
        );
      }

      // Reload evolution stats if on annual tab and month is not null
      if (state case final MonthlyStatsLoaded st
          when st.currentTab == StatsTab.annual && selectedMonth != null) {
        await _loadEvolutionStats(selectedMonth, event.year, emit);
      }
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  Future<void> _onChangeStatsTab(
    ChangeStatsTab event,
    Emitter<StatsState> emit,
  ) async {
    if (state case final MonthlyStatsLoaded st) {
      emit(st.copyWith(currentTab: event.tab));

      // Load evolution stats when switching to annual tab if not already loaded
      // Only load if month is not null (evolution stats are per-month)
      if (event.tab == StatsTab.annual && st.evolutionStats == null) {
        if (st.month case final int month) {
          await _loadEvolutionStats(month, st.year, emit);
        }
      }
    }
  }

  Future<void> _loadEvolutionStats(
    int month,
    int year,
    Emitter<StatsState> emit,
  ) async {
    try {
      final params = GetEvolutionStatsParams(month: month, year: year);
      final evolutionStats = await getEvolutionStatsUseCase(params);

      if (state case final MonthlyStatsLoaded st) {
        emit(st.copyWith(evolutionStats: evolutionStats));
      }
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  void _onChartTouchInteraction(
    ChartTouchInteraction event,
    Emitter<StatsState> emit,
  ) {
    if (state case final MonthlyStatsLoaded st) {
      emit(st.copyWith(touchedIndex: event.index));
    }
  }
}
