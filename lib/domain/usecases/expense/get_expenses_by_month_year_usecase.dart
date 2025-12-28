import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class GetExpensesByMonthYearParams extends Equatable {
  const GetExpensesByMonthYearParams({
    required this.month,
    required this.year,
  });

  final int month;
  final int year;

  @override
  List<Object> get props => [month, year];
}

class GetExpensesByMonthYearUseCase
    implements UseCase<List<Expense>, GetExpensesByMonthYearParams> {
  const GetExpensesByMonthYearUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<List<Expense>> call(GetExpensesByMonthYearParams params) async {
    if (params.month < 1 || params.month > 12) {
      throw ArgumentError.value(
        params.month,
        'month',
        'Month must be between 1 and 12',
      );
    }
    if (params.year < 2000) {
      throw ArgumentError.value(
        params.year,
        'year',
        'Year must be 2000 or later',
      );
    }
    return repository.getExpensesByMonthYear(params.month, params.year);
  }
}
