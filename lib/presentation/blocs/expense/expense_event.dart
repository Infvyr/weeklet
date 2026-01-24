import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/expense.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Event for the initial loading of the list from the database/API.
final class LoadExpensesRequested extends ExpenseEvent {
  const LoadExpensesRequested();
}

/// Triggered when the user wants to add a new expense.
/// We pass the raw data needed to create the object in the Bloc.
final class AddExpenseStarted extends ExpenseEvent {
  const AddExpenseStarted({
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.date,
  });

  final String amount;
  final String description;
  final String categoryId;
  final DateTime date;

  @override
  List<Object?> get props => [amount, description, categoryId, date];
}

/// Triggered to update an existing expense.
final class UpdateExpenseStarted extends ExpenseEvent {
  const UpdateExpenseStarted(this.expense);

  final Expense expense;

  @override
  List<Object?> get props => [expense];
}

/// Triggered to delete an expense by ID.
final class DeleteExpenseStarted extends ExpenseEvent {
  const DeleteExpenseStarted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Triggered when the user changes the filter criteria.
final class FilterDateChanged extends ExpenseEvent {
  const FilterDateChanged({this.year, this.month});

  final int? year;
  final int? month;

  @override
  List<Object?> get props => [year, month];
}

/// (Optional) Resets any error message from the success state.
/// Useful for clearing the SnackBar in the UI after display.
final class ClearActionErrorRequested extends ExpenseEvent {
  const ClearActionErrorRequested();
}
