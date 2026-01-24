import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add_expense_form_view.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/list/expense_list_view.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseState = context.watch<ExpenseBloc>().state;
    final categoryState = context.watch<CategoryBloc>().state;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Expenses'),
        centerTitle: true,
      ),
      body: switch ((expenseState, categoryState)) {
        (ExpenseLoading _, _) || (_, CategoryLoading _) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),

        (ExpenseFailure _, _) => Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Failed to load expenses', style: context.bodyLarge),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.read<ExpenseBloc>().add(
                  const LoadExpensesRequested(),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        (final ExpenseSuccess success, final CategoriesLoaded catLoaded) =>
          SingleChildScrollView(
            padding: const .all(16.0),
            child: ExpenseListView(
              expenses: success.filteredExpenses,
              categories: catLoaded.categories,
            ),
          ),

        _ => const SizedBox.shrink(),
      },
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new expense',
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => SizedBox(
            height: context.screenHeight * 0.8,
            child: const AddExpenseFormView(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
