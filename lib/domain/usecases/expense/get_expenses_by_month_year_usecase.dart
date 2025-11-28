import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class GetExpensesByMonthYearParams {
  GetExpensesByMonthYearParams({required this.month, required this.year});
  final int month;
  final int year;
}

class GetExpensesByMonthYearUseCase
    implements UseCase<List<Expense>, GetExpensesByMonthYearParams> {
  GetExpensesByMonthYearUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<List<Expense>> call(GetExpensesByMonthYearParams params) =>
      repository.getExpensesByMonthYear(params.month, params.year);
}
