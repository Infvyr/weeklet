import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';

import 'base/use_case.dart';

class GetWeeklyExpenseSummaryUseCase
    extends UseCase<double, GetWeeklyExpenseSummaryParams> {
  GetWeeklyExpenseSummaryUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<double> call(GetWeeklyExpenseSummaryParams params) async {
    const expenseType = TransactionType.expense;

    final total = await repository.getTotalByDateRange(
      startDate: params.startDate,
      endDate: params.endDate,
      type: expenseType.dbValue,
    );
    return total;
  }
}

class GetWeeklyExpenseSummaryParams {
  GetWeeklyExpenseSummaryParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}
