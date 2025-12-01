import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class DeleteExpenseUseCase implements UseCase<void, String> {
  DeleteExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(String params) async {
    if (params.trim().isEmpty) {
      throw ArgumentError('Expense ID cannot be empty');
    }
    return repository.deleteExpense(params);
  }
}
