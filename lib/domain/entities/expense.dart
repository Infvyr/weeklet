class Expense {
  Expense({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.note,
  });

  late String id;
  late String categoryId;
  late String title;
  late double amount;
  late DateTime date;
  late DateTime createdAt;
  late String? note;
}
