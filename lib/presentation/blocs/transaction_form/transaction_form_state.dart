// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:weeklet/core/enums/category_enum.dart';
import 'package:weeklet/core/enums/transaction_type_enum.dart';

enum FormStatus { initial, loading, success, failure }

class TransactionFormState extends Equatable {
  const TransactionFormState({
    this.status = FormStatus.initial,
    this.errorMessage,
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
  });

  factory TransactionFormState.initial() => TransactionFormState(
    type: TransactionType.expense.dbValue,
    amount: 0.0,
    date: DateTime.now(),
    category: CategoryType.salary.dbValue,
    notes: '',
    status: FormStatus.initial,
  );

  final FormStatus status;
  final String? errorMessage;

  final String type;
  final double amount;
  final DateTime date;
  final String category;
  final String notes;

  @override
  List<Object?> get props => [status, errorMessage, type, amount, date, category, notes];

  TransactionFormState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? type,
    double? amount,
    DateTime? date,
    String? category,
    String? notes,
  }) => TransactionFormState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    category: category ?? this.category,
    notes: notes ?? this.notes,
  );

  @override
  bool get stringify => true;
}
