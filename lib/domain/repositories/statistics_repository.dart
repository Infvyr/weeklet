import 'package:weeklet/domain/entities/statistics.dart';

abstract class StatisticsRepository {
  Future<MonthlyStats> getMonthlyStats(int month, int year);
  // Future<AnnualStats> getAnnualStats(int year); // To be implemented later
}
