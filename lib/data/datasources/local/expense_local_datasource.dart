import 'package:hive_flutter/hive_flutter.dart';
import 'package:weeklet/data/models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<void> updateExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpensesByMonthYear(int month, int year);
  Future<List<ExpenseModel>> getAllExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  ExpenseLocalDataSourceImpl(this.expenseBox);

  final Box<ExpenseModel> expenseBox;

  @override
  Future<void> addExpense(ExpenseModel model) async => expenseBox.put(
    model.id,
    model,
  );

  @override
  Future<void> deleteExpense(String id) async => expenseBox.delete(id);

  @override
  Future<void> updateExpense(ExpenseModel model) async => expenseBox.put(
    model.id,
    model,
  );

  @override
  Future<List<ExpenseModel>> getExpensesByMonthYear(int month, int year) async =>
      expenseBox.values
          .where((model) => model.date.month == month && model.date.year == year)
          .toList();

  @override
  Future<List<ExpenseModel>> getAllExpenses() async => expenseBox.values.toList();
}
