// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:weeklet/domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.notes,
    required this.type,
  });

  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
    id: entity.id,
    date: entity.date,
    amount: entity.amount,
    category: entity.category,
    notes: entity.notes,
    type: entity.type,
  );

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String notes;

  @HiveField(5)
  final String type;

  Transaction toEntity() => Transaction(
    id: id,
    date: date,
    amount: amount,
    category: category,
    notes: notes,
    type: type,
  );

  @override
  String toString() =>
      'TransactionModel(id: $id, date: $date, amount: $amount, category: $category, notes: $notes, type: $type)';
}
