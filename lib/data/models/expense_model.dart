import 'package:weeklet/domain/entities/expense.dart';

class ExpenseModel {
  ExpenseModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.note,
  });

  factory ExpenseModel.fromEntity(Expense entity) => ExpenseModel(
    id: entity.id,
    categoryId: entity.categoryId,
    title: entity.title,
    amount: entity.amount,
    date: entity.date,
    createdAt: entity.createdAt,
    note: entity.note,
  );
  final String id;
  final String categoryId;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime createdAt;
  final String? note;

  Expense toEntity() => Expense(
    id: id,
    categoryId: categoryId,
    title: title,
    amount: amount,
    date: date,
    createdAt: createdAt,
    note: note,
  );

  ExpenseModel copyWith({
    String? id,
    String? categoryId,
    String? title,
    double? amount,
    DateTime? date,
    DateTime? createdAt,
    String? note,
  }) => ExpenseModel(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    note: note ?? this.note,
  );

  @override
  String toString() =>
      'ExpenseModel(id: $id, categoryId: $categoryId, title: $title, amount: $amount, date: $date, createdAt: $createdAt, note: $note)';
}
