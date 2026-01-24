import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/di/service_locator.dart' show sl;
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add_expense_form_view.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/list/export.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();
    // Load expenses and categories on screen init
    sl<ExpenseBloc>().add(const LoadExpensesRequested());
    sl<CategoryBloc>().add(const GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('My Expenses'),
    ),
    body: BlocBuilder<ExpenseBloc, ExpenseState>(
      bloc: sl<ExpenseBloc>(),
      builder: (context, expenseState) => BlocBuilder<CategoryBloc, CategoryState>(
        bloc: sl<CategoryBloc>(),
        builder: (context, categoryState) {
          // Loading state
          if (expenseState is ExpenseLoading || categoryState is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (expenseState is ExpenseFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: context.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load expenses',
                    style: context.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      sl<ExpenseBloc>().add(const LoadExpensesRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success state
          if (expenseState is ExpenseSuccess && categoryState is CategoriesLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ExpenseListView(
                expenses: expenseState.filteredExpenses,
                categories: categoryState.categories,
                currencySymbol: 'lei',
              ),
            );
          }

          // Initial state - show empty
          return const SizedBox.shrink();
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Add new expense',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<ExpenseBloc>()),
            BlocProvider.value(value: sl<CategoryBloc>()),
          ],
          child: SizedBox(
            height: context.screenHeight * 0.8,
            child: const AddExpenseFormView(),
          ),
        ),
      ),
      child: const Icon(Icons.add),
    ),
  );
}
