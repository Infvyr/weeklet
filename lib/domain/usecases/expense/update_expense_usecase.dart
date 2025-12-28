import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class UpdateExpenseUseCase implements UseCase<void, Expense> {
  const UpdateExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Expense params) async {
    _validateExpense(params);
    return repository.updateExpense(params);
  }

  void _validateExpense(Expense params) {
    if (params.description.trim().isEmpty) {
      throw ArgumentError('Expense description cannot be empty');
    }
    if (params.amount <= 0) {
      throw ArgumentError('Expense amount must be greater than 0');
    }
    if (params.categoryId.trim().isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
  }
}
