import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/domain/usecases/stats/get_monthly_stats_use_case.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required this.getMonthlyStatsUseCase,
  }) : super(const StatsInitial()) {
    on<LoadMonthlyStats>(_onLoadMonthlyStats);
    on<ChangeStatsTab>(_onChangeStatsTab);
    on<ChartTouchInteraction>(_onChartTouchInteraction);
  }

  final GetMonthlyStatsUseCase getMonthlyStatsUseCase;

  Future<void> _onLoadMonthlyStats(
    LoadMonthlyStats event,
    Emitter<StatsState> emit,
  ) async {
    // If we are already loaded, we want to keep the current state to avoid flickering
    // but re-fetch data. If not loaded, show loading.
    if (state is! MonthlyStatsLoaded) {
      emit(const StatsLoading());
    }

    try {
      final stats = await getMonthlyStatsUseCase(event.month, event.year);
      if (state is MonthlyStatsLoaded) {
        emit(
          (state as MonthlyStatsLoaded).copyWith(
            stats: stats,
            month: event.month,
            year: event.year,
          ),
        );
      } else {
        emit(
          MonthlyStatsLoaded(
            stats: stats,
            month: event.month,
            year: event.year,
          ),
        );
      }
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  void _onChangeStatsTab(ChangeStatsTab event, Emitter<StatsState> emit) {
    if (state is MonthlyStatsLoaded) {
      emit((state as MonthlyStatsLoaded).copyWith(currentTab: event.tab));
    }
  }

  void _onChartTouchInteraction(
    ChartTouchInteraction event,
    Emitter<StatsState> emit,
  ) {
    if (state is MonthlyStatsLoaded) {
      emit((state as MonthlyStatsLoaded).copyWith(touchedIndex: event.index));
    }
  }
}
