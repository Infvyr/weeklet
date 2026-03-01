import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';

/// Widget responsible for initializing app data on startup.
/// This ensures separation of concerns - data loading logic is separate from UI navigation.
class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Trigger initial data loading when app starts
    _initializeAppData();
  }

  void _initializeAppData() {
    // Load all expenses
    context.read<ExpenseBloc>().add(const LoadExpensesRequested());

    // Load all incomes
    context.read<IncomeBloc>().add(const LoadIncomesRequested());

    // Load all categories
    context.read<CategoryBloc>().add(const GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
