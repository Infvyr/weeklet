import 'package:weeklet/domain/entities/transaction.dart';

abstract class ExpenseRepository {
  /// Add a new transaction.
  Future<void> addTransaction(Transaction transaction);

  /// Updates an existing transaction.
  Future<void> updateTransaction(Transaction transaction);

  /// Delete a transaction by ID.
  Future<void> deleteTransaction(String id);

  /// Returns all transactions like for backup/export operations etc.
  Future<List<Transaction>> getAllTransactions();

  /// Returns filtered transactions for a specific month and year (useful for Journal).
  Future<List<Transaction>> getTransactionsByMonth(int year, int month);

  /// Calculates the total amount filtered by type, year, month or category (useful for Dashboard/Stats).
  Future<double> getTotalAmountByFilter({
    required String type,
    int? year,
    int? month,
    String? category,
  });

  // Method to get the total in a data range
  Future<double> getTotalByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
  });
}
