import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/expense.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

final class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

final class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

final class ExpenseSuccess extends ExpenseState {
  const ExpenseSuccess({
    required this.allExpenses,
    required this.filteredExpenses,
    required this.selectedYear,
    this.selectedMonth,
    this.actionError,
  });

  final List<Expense> allExpenses;
  final List<Expense> filteredExpenses;
  final int selectedYear; // Default: DateTime.now().year
  final int? selectedMonth;
  final String? actionError;

  @override
  List<Object?> get props => [
    allExpenses,
    filteredExpenses,
    selectedYear,
    selectedMonth,
    actionError,
  ];

  ExpenseSuccess copyWith({
    List<Expense>? allExpenses,
    List<Expense>? filteredExpenses,
    int? selectedYear,
    int? selectedMonth,
    String? actionError,
  }) => ExpenseSuccess(
    allExpenses: allExpenses ?? this.allExpenses,
    filteredExpenses: filteredExpenses ?? this.filteredExpenses,
    selectedYear: selectedYear ?? this.selectedYear,
    selectedMonth: selectedMonth ?? this.selectedMonth,
    actionError: actionError, // allow null to reset error
  );
}

final class ExpenseFailure extends ExpenseState {
  const ExpenseFailure(this.message);

  final String message;
  @override
  List<Object?> get props => [message];
}
