import 'package:hive/hive.dart';
import 'package:weeklet/data/models/transaction_model.dart';
import 'package:weeklet/domain/entities/transaction.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._transactionBox);

  final Box<TransactionModel> _transactionBox;

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // Convert from Entity (Domain) to Model (Data)
    final model = TransactionModel(
      id: transaction.id,
      date: transaction.date,
      amount: transaction.amount,
      category: transaction.category,
      notes: transaction.notes,
      type: transaction.type,
    );

    await _transactionBox.put(model.id, model);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      date: transaction.date,
      amount: transaction.amount,
      category: transaction.category,
      notes: transaction.notes,
      type: transaction.type,
    );

    await _transactionBox.put(model.id, model);
  }

  @override
  Future<void> deleteTransaction(String id) async => _transactionBox.delete(id);

  // Convert from Model (saved) back to Entity (for usage in Domain/Presentation)
  @override
  Future<List<Transaction>> getAllTransactions() async =>
      _transactionBox.values.toList().cast<Transaction>();

  @override
  Future<List<Transaction>> getTransactionsByMonth(int year, int month) async {
    final filteredModels = _transactionBox.values
        .where((model) => model.date.year == year && model.date.month == month)
        .toList();

    final entities = filteredModels.map((model) => model.toEntity()).toList();

    return entities;
  }

  @override
  Future<double> getTotalAmountByFilter({
    required String type,
    int? year,
    int? month,
    String? category,
  }) async {
    final double total = _transactionBox.values
        .where((t) => t.type == type)
        .where((t) => year == null || t.date.year == year)
        .where((t) => month == null || t.date.month == month)
        .where((t) => category == null || t.category == category)
        .fold(0.0, (sum, item) => sum + item.amount);

    return total;
  }

  @override
  Future<double> getTotalByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
  }) async {
    final filteredTransactions = _transactionBox.values.where((model) {
      final transactionDate = model.date;

      final isDateInRange =
          transactionDate.isAfter(startDate) && transactionDate.isBefore(endDate);

      final isMatchingType = model.type == type;

      return isDateInRange && isMatchingType;
    }).toList();

    final total = filteredTransactions.fold(
      0.0,
      (sum, model) => sum + model.amount,
    );

    return total;
  }
}
