import 'package:weeklet/domain/entities/transaction.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class TransactionsByMonthParams {
  TransactionsByMonthParams({required this.year, required this.month});
  final int year;
  final int month;
}

class GetTransactionsByMonthUseCase
    extends UseCase<List<Transaction>, TransactionsByMonthParams> {
  GetTransactionsByMonthUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<List<Transaction>> call(TransactionsByMonthParams params) =>
      repository.getTransactionsByMonth(params.year, params.month);
}
