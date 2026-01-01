sealed class ExpenseEvent {
  const ExpenseEvent();
}

final class AddExpenseEvent extends ExpenseEvent {
  const AddExpenseEvent({
    required this.amount,
    required this.note,
    required this.categoryId,
    required this.date,
  });

  final double amount;
  final String note;
  final String categoryId;
  final DateTime date;
}

final class UpdateExpenseEvent extends ExpenseEvent {
  const UpdateExpenseEvent({
    required this.id,
    required this.amount,
    required this.note,
    required this.categoryId,
    required this.date,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final String note;
  final String categoryId;
  final DateTime date;
  final DateTime createdAt;
}

final class DeleteExpenseEvent extends ExpenseEvent {
  const DeleteExpenseEvent({
    required this.id,
  });

  final String id;
}

final class GetAllExpensesEvent extends ExpenseEvent {
  const GetAllExpensesEvent();
}
