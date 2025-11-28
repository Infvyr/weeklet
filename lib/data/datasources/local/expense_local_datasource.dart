import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/domain/entities/expense.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> updateExpense(Expense expense);
  Future<List<Expense>> getExpensesByMonthYear(int month, int year);
  Future<List<Expense>> getAllExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  ExpenseLocalDataSourceImpl(this.expenseBox);
  final Box<Expense> expenseBox;

  @override
  Future<void> addExpense(Expense expense) async {
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await expenseBox.delete(id);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<List<Expense>> getExpensesByMonthYear(int month, int year) async => expenseBox
      .values
      .where((expense) => expense.date.month == month && expense.date.year == year)
      .toList();

  @override
  Future<List<Expense>> getAllExpenses() async => expenseBox.values.toList();
}
