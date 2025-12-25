import 'package:weeklet/data/datasources/local/expense_local_datasource.dart';
import 'package:weeklet/data/models/expense_model.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(
    this.localDataSource,
  );

  final ExpenseLocalDataSource localDataSource;

  @override
  Future<void> addExpense(
    Expense expense,
  ) async {
    final model = ExpenseModel.fromEntity(
      expense,
    );
    await localDataSource.addExpense(
      model,
    );
  }

  @override
  Future<void> deleteExpense(
    String id,
  ) => localDataSource.deleteExpense(id);

  @override
  Future<void> updateExpense(
    Expense expense,
  ) async {
    final model = ExpenseModel.fromEntity(
      expense,
    );
    await localDataSource.updateExpense(
      model,
    );
  }

  @override
  Future<List<Expense>> getExpensesByMonthYear(
    int month,
    int year,
  ) async {
    final models = await localDataSource.getExpensesByMonthYear(
      month,
      year,
    );
    return models
        .map(
          (model) => model.toEntity(),
        )
        .toList();
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final models = await localDataSource.getAllExpenses();
    return models
        .map(
          (model) => model.toEntity(),
        )
        .toList();
  }
}
