import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/repositories/statistics_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class GetEvolutionStatsParams extends Equatable {
  const GetEvolutionStatsParams({
    required this.month,
    required this.year,
  });

  final int month;
  final int year;

  @override
  List<Object> get props => [month, year];
}

class GetEvolutionStatsUseCase
    implements UseCase<EvolutionStats, GetEvolutionStatsParams> {
  const GetEvolutionStatsUseCase(this.repository);

  final StatisticsRepository repository;

  @override
  Future<EvolutionStats> call(GetEvolutionStatsParams params) =>
      repository.getEvolutionStats(params.month, params.year);
}
