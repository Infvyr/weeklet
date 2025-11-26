import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.notes,
    required this.type,
  });

  final String id;
  final DateTime date;
  final double amount;
  final String category;
  final String notes;
  final String type;

  @override
  List<Object?> get props => [id, date, amount, category, notes, type];

  @override
  bool get stringify => true;
}
