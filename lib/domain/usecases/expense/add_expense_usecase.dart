import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class AddExpenseUseCase implements UseCase<void, Expense> {
  const AddExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Expense params) async {
    _validateExpense(params);
    return repository.addExpense(params);
  }

  void _validateExpense(Expense expense) {
    if (expense.description.trim().isEmpty) {
      throw ArgumentError('Expense description cannot be empty');
    }
    if (expense.amount <= 0) {
      throw ArgumentError('Expense amount must be greater than 0');
    }
    if (expense.categoryId.trim().isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
  }
}
