import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class AddExpenseUseCase implements UseCase<void, Expense> {
  AddExpenseUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Expense params) => repository.addExpense(params);
}
