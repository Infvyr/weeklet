import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/income.dart';

sealed class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event for the initial loading of the list from the database.
final class LoadIncomesRequested extends IncomeEvent {
  const LoadIncomesRequested();
}

/// Triggered when the user wants to add a new income.
final class AddIncomeStarted extends IncomeEvent {
  const AddIncomeStarted({
    required this.amount,
    required this.description,
    required this.date,
  });

  final String amount;
  final String description;
  final DateTime date;

  @override
  List<Object?> get props => [amount, description, date];
}

/// Triggered to update an existing income.
final class UpdateIncomeStarted extends IncomeEvent {
  const UpdateIncomeStarted(this.income);

  final Income income;

  @override
  List<Object?> get props => [income];
}

/// Triggered to delete an income by ID.
final class DeleteIncomeStarted extends IncomeEvent {
  const DeleteIncomeStarted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Triggered when the user changes the filter criteria.
final class IncomeFilterDateChanged extends IncomeEvent {
  const IncomeFilterDateChanged({this.year, this.month});

  final int? year;
  final int? month;

  @override
  List<Object?> get props => [year, month];
}

/// Resets any error message from the success state.
final class ClearIncomeActionErrorRequested extends IncomeEvent {
  const ClearIncomeActionErrorRequested();
}
