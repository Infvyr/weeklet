import 'package:weeklet/domain/entities/expense.dart';

sealed class ExpenseState {
  const ExpenseState();
}

final class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

final class ExpenseLoaded extends ExpenseState {
  const ExpenseLoaded({
    required this.expense,
  });

  final Expense expense;
}

final class ExpensesLoading extends ExpenseState {
  const ExpensesLoading();
}

final class ExpensesLoaded extends ExpenseState {
  const ExpensesLoaded({
    required this.expenses,
  });

  final List<Expense> expenses;
}

final class ExpensesSuccess extends ExpenseState {
  const ExpensesSuccess({
    required this.message,
  });

  final String message;
}

final class ExpensesError extends ExpenseState {
  const ExpensesError({
    required this.message,
  });

  final String message;
}
