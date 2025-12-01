import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class AddExpenseUseCase implements UseCase<void, Expense> {
  AddExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Expense params) async {
    if (params.title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty');
    }
    if (params.amount <= 0) {
      throw ArgumentError('Expense amount must be greater than 0');
    }
    if (params.categoryId.trim().isEmpty) {
      throw ArgumentError('Category ID cannot be empty');
    }
    return repository.addExpense(params);
  }
}
