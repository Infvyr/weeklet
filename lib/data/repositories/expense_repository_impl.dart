import 'package:weeklet/data/datasources/local/expense_local_datasource.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this.localDataSource);

  final ExpenseLocalDataSource localDataSource;

  @override
  Future<void> addExpense(Expense expense) => localDataSource.addExpense(expense);

  @override
  Future<void> deleteExpense(String id) => localDataSource.deleteExpense(id);

  @override
  Future<void> updateExpense(Expense expense) => localDataSource.updateExpense(expense);

  @override
  Future<List<Expense>> getExpensesByMonthYear(int month, int year) =>
      localDataSource.getExpensesByMonthYear(month, year);

  @override
  Future<List<Expense>> getAllExpenses() => localDataSource.getAllExpenses();
}
