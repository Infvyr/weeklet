import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  Expense({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.note,
  });

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String categoryId;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  late String? note;
}
