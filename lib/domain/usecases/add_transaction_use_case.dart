import 'package:weeklet/core/enums/transaction_type_enum.dart';
import 'package:weeklet/domain/entities/transaction.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';

import 'base/use_case.dart';

class AddTransactionUseCase extends UseCase<void, Transaction> {
  AddTransactionUseCase(this.repository);

  final ExpenseRepository repository;

  @override
  Future<void> call(Transaction transaction) async {
    if (transaction.id.isEmpty) {
      throw Exception('Validation Error: Transaction ID cannot be empty.');
    }

    if (transaction.amount <= 0) {
      throw Exception(
        'Validation Error: The transaction amount must be greater than zero.',
      );
    }

    final lowerCaseType = transaction.type.toLowerCase();
    if (lowerCaseType != TransactionType.expense.name &&
        lowerCaseType != TransactionType.income.name) {
      throw Exception(
        'Validation Error: Transaction type must be "Expense" or "Income".',
      );
    }

    if (transaction.category.trim().isEmpty) {
      throw Exception('Validation Error: Transaction category cannot be empty.');
    }

    if (transaction.date.year < 2000 ||
        transaction.date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      throw Exception('Validation Error: The transaction date is invalid.');
    }

    return repository.addTransaction(transaction);
  }
}
