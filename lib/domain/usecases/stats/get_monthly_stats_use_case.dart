import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/repositories/statistics_repository.dart';

class GetMonthlyStatsUseCase {
  const GetMonthlyStatsUseCase(this.repository);

  final StatisticsRepository repository;

  Future<MonthlyStats> call(int month, int year) =>
      repository.getMonthlyStats(month, year);
}
