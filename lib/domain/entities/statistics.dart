import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/category.dart';

class MonthlyStats extends Equatable {
  const MonthlyStats({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.incomeGrowthPercentage,
    required this.expenseGrowthPercentage,
    required this.categoryStats,
  });

  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final double incomeGrowthPercentage; // Compared to last month
  final double expenseGrowthPercentage; // Compared to last month
  final List<CategoryStats> categoryStats;

  @override
  List<Object> get props => [
    totalIncome,
    totalExpenses,
    balance,
    incomeGrowthPercentage,
    expenseGrowthPercentage,
    categoryStats,
  ];
}

class CategoryStats extends Equatable {
  const CategoryStats({
    required this.category,
    required this.totalAmount,
    required this.percentage,
  });

  final Category category;
  final double totalAmount;
  final double
  percentage; // 0.0 to 1.0 (or 0-100 based on preference, I'll use 0.0-1.0)

  @override
  List<Object> get props => [category, totalAmount, percentage];
}
