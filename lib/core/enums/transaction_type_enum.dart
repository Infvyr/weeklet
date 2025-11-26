enum TransactionType {
  income,
  expense,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName => switch (this) {
    TransactionType.income => 'Income',
    TransactionType.expense => 'Expense',
  };

  String get dbValue => name;
}
