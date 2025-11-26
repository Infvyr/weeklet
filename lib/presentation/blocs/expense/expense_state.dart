import 'package:equatable/equatable.dart';
import 'package:weeklet/domain/entities/transaction.dart';

class ExpenseState extends Equatable {
  const ExpenseState({
    this.isLoading = false,
    this.errorMessage,
    required this.selectedYear,
    required this.selectedMonth,
    required this.monthlyTotalExpense,
    required this.monthlyTotalIncome,
    required this.monthlyBalance,
    required this.monthlyCategoryTotals,
    required this.recentTransactions,
    required this.weeklyTotalExpense,
    required this.weeklyComparisonPercentage,
  });

  factory ExpenseState.initial() {
    final now = DateTime.now();
    return ExpenseState(
      selectedYear: now.year,
      selectedMonth: now.month,
      monthlyTotalExpense: 0.0,
      monthlyTotalIncome: 0.0,
      monthlyBalance: 0.0,
      monthlyCategoryTotals: const {},
      recentTransactions: const [],
      weeklyTotalExpense: 0.0,
      weeklyComparisonPercentage: 0.0,
    );
  }

  final bool isLoading;
  final String? errorMessage;
  final int selectedYear;
  final int selectedMonth;
  final double monthlyTotalExpense;
  final double monthlyTotalIncome;
  final double monthlyBalance;
  final Map<String, double> monthlyCategoryTotals;
  final List<Transaction> recentTransactions;
  final double weeklyTotalExpense;
  final double weeklyComparisonPercentage;

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    monthlyBalance,
    selectedMonth,
    monthlyCategoryTotals,
    recentTransactions,
  ];

  ExpenseState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? selectedYear,
    int? selectedMonth,
    double? monthlyTotalExpense,
    double? monthlyTotalIncome,
    double? monthlyBalance,
    Map<String, double>? monthlyCategoryTotals,
    List<Transaction>? recentTransactions,
    double? weeklyTotalExpense,
    double? weeklyComparisonPercentage,
  }) => ExpenseState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
    selectedYear: selectedYear ?? this.selectedYear,
    selectedMonth: selectedMonth ?? this.selectedMonth,
    monthlyTotalExpense: monthlyTotalExpense ?? this.monthlyTotalExpense,
    monthlyTotalIncome: monthlyTotalIncome ?? this.monthlyTotalIncome,
    monthlyBalance: monthlyBalance ?? this.monthlyBalance,
    monthlyCategoryTotals: monthlyCategoryTotals ?? this.monthlyCategoryTotals,
    recentTransactions: recentTransactions ?? this.recentTransactions,
    weeklyTotalExpense: weeklyTotalExpense ?? this.weeklyTotalExpense,
    weeklyComparisonPercentage:
        weeklyComparisonPercentage ?? this.weeklyComparisonPercentage,
  );

  @override
  bool get stringify => true;
}
