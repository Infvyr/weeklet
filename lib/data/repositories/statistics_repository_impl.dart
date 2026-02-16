import 'package:weeklet/domain/entities/statistics.dart';
import 'package:weeklet/domain/repositories/expense_repository.dart';
import 'package:weeklet/domain/repositories/income_repository.dart';
import 'package:weeklet/domain/repositories/statistics_repository.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  const StatisticsRepositoryImpl({
    required this.expenseRepository,
    required this.incomeRepository,
    required this.categoryRepository,
  });

  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;
  final CategoryRepository categoryRepository;

  @override
  Future<MonthlyStats> getMonthlyStats(int month, int year) async {
    // 1. Get current month data
    final currentExpenses = await expenseRepository.getExpensesByMonthYear(
      month,
      year,
    );
    final allIncomes = await incomeRepository.getIncomes();
    final currentIncomes = allIncomes
        .where((i) => i.date.month == month && i.date.year == year)
        .toList();

    // 2. Get previous month data (for growth calculation)
    final prevMonth = month == 1 ? 12 : month - 1;
    final prevYear = month == 1 ? year - 1 : year;
    final prevExpenses = await expenseRepository.getExpensesByMonthYear(
      prevMonth,
      prevYear,
    );
    final prevIncomes = allIncomes
        .where((i) => i.date.month == prevMonth && i.date.year == prevYear)
        .toList();

    // 3. Calculate totals
    final totalIncome = currentIncomes.fold(0.0, (sum, i) => sum + i.amount);
    final totalExpense = currentExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final balance = totalIncome - totalExpense;

    final prevTotalIncome = prevIncomes.fold(0.0, (sum, i) => sum + i.amount);
    final prevTotalExpense = prevExpenses.fold(0.0, (sum, e) => sum + e.amount);

    // 4. Calculate growth
    final incomeGrowth = _calculateGrowth(totalIncome, prevTotalIncome);
    final expenseGrowth = _calculateGrowth(totalExpense, prevTotalExpense);

    // 5. Category breakdown
    final allCategories = await categoryRepository.getAllCategories();
    final categoryStats = <CategoryStats>[];

    for (final category in allCategories) {
      final categoryExpenses = currentExpenses.where(
        (e) => e.categoryId == category.id,
      );
      final categoryTotal = categoryExpenses.fold(
        0.0,
        (sum, e) => sum + e.amount,
      );

      if (categoryTotal > 0) {
        categoryStats.add(
          CategoryStats(
            category: category,
            totalAmount: categoryTotal,
            percentage: totalExpense > 0 ? categoryTotal / totalExpense : 0.0,
          ),
        );
      }
    }

    // Sort by amount descending
    categoryStats.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return MonthlyStats(
      totalIncome: totalIncome,
      totalExpenses: totalExpense,
      balance: balance,
      incomeGrowthPercentage: incomeGrowth,
      expenseGrowthPercentage: expenseGrowth,
      categoryStats: categoryStats,
    );
  }

  double _calculateGrowth(double current, double previous) {
    if (previous == 0) return 0.0; // Or 1.0 (100%)? 0.0 means no comparison.
    return (current - previous) / previous;
  }
}
